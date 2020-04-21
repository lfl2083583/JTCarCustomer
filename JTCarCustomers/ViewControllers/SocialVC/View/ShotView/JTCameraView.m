//
//  JTCameraView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCameraView.h"
#import <AVFoundation/AVFoundation.h>
#import "JTDeviceAccess.h"

@interface JTCameraView () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) UIView *containerView;//录制视频容器
@property (nonatomic, strong) AVCaptureSession *captureSession;//负责输入和输出设置之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureStillImageOutput *captureImageFileOutput;//图片输出流;
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property (nonatomic, copy) NSString *outPath; //文件路径
@property (nonatomic, assign) CGFloat recordTime; //录制时间
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy) void(^completionImageHandler)(UIImage *image);
@property (nonatomic, copy) void(^completionVideoHandler)(NSString *outPath);

@end

@implementation JTCameraView

- (instancetype)initWithFrame:(CGRect)frame minDuration:(CGFloat)minDuration maxDuration:(CGFloat)maxDuration
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMinDuration:minDuration];
        [self setMaxDuration:maxDuration];
        [self setUp];
    }
    return self;
}

//取得指定位置的摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

- (void)startPreview
{
    [self.captureSession startRunning];
}

- (void)stopPreview
{
    [self.captureSession stopRunning];
}

- (void)flashCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        //闪光灯开
        if (device.flashMode != AVCaptureFlashModeOn)
        {
            [device setFlashMode:AVCaptureFlashModeOn];
        }
        //闪光灯关
        else
        {
            [device setFlashMode:AVCaptureFlashModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (void)modeCamera
{
    AVCaptureDevice *currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        [self setCaptureDeviceInput:toChangeDeviceInput];
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}

- (void)photographWithCompletionImageHandler:(void (^)(UIImage *))completionImageHandler
{
    self.completionImageHandler = completionImageHandler;
    AVCaptureConnection *captureConnection = [self.captureImageFileOutput connectionWithMediaType:AVMediaTypeVideo];
    __weak typeof(self) weakself = self;
    [self.captureImageFileOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        if (weakself.completionImageHandler) {
            weakself.completionImageHandler(image);
        }
    }];
}

- (void)startVideoRecorder
{
    self.recordTime = 0;
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
    self.outPath = [self generateOutPath];
    [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:self.outPath] recordingDelegate:self];
}

- (void)stopVideoRecorder:(CGFloat)recorderDuration completionVideoHandler:(void (^)(NSString *))completionVideoHandler
{
    self.recordTime = recorderDuration;
    self.completionVideoHandler = completionVideoHandler;
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];
    }
}

- (void)setUp
{
    _containerView = [[UIView alloc] initWithFrame:SC_DEVICE_BOUNDS];
    [self addSubview:_containerView];
    
    _captureSession = [[AVCaptureSession alloc] init];
    //获得输入设备
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    if (!audioCaptureDevice) {
        NSLog(@"取得声音出了问题.");
        return;
    }
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
    }
    //初始化设备输出对象，用于获得输出数据
    _captureImageFileOutput = [[AVCaptureStillImageOutput alloc] init];
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureImageFileOutput];
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    _captureVideoPreviewLayer.frame = _containerView.bounds;
    //填充模式
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //将视频预览层添加到界面中
    [_containerView.layer addSublayer:_captureVideoPreviewLayer];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"开始录制...");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (!error) {
        if (self.recordTime < self.minDuration) {
            [self removeDisabledRecordFile];
            [[HUDTool shareHUDTool] showHint:[NSString stringWithFormat:@"录制时间必须大于%.0f秒", self.minDuration]];
        }
        else if (self.recordTime > self.maxDuration + 1) {
            [self removeDisabledRecordFile];
            [[HUDTool shareHUDTool] showHint:[NSString stringWithFormat:@"录制时间必须小于%.0f秒", self.maxDuration]];
        }
        else
        {
            if (self.completionVideoHandler) {
                self.completionVideoHandler(self.outPath);
            }
        }
    }
    NSLog(@"视频录制完成.");
}

#define KVideoUrlPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Record/SmallVideo"]
- (NSString *)generateOutPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh-mm-ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];

    if (![self.fileManager fileExistsAtPath:KVideoUrlPath]){
        [self.fileManager createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *outPath = [KVideoUrlPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", dateString]];
    return outPath;
}

- (void)removeDisabledRecordFile
{
    if (![self.fileManager fileExistsAtPath:self.outPath]){
        [self.fileManager removeItemAtPath:self.outPath error:nil];
    }
}

- (void)compressedRecordFile
{
    
}

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}
@end
