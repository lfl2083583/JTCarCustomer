//
//  JTCameraViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCameraViewController.h"
#import "JTCameraView.h"
#import "JTCameraFunctionView.h"
#import "JTCameraResultView.h"

@interface JTCameraViewController () <JTCameraFunctionDelegate, JTCameraResultDelegate>;

@property (nonatomic, strong) JTCameraView *cameraView;
@property (nonatomic, strong) JTCameraFunctionView *cameraFunctionView;
@property (nonatomic, strong) JTCameraResultView *cameraResultView;

@end

@implementation JTCameraViewController

- (instancetype)initWithCompletionImageHandler:(void (^)(UIImage *))completionImageHandler completionVideoHandler:(void (^)(NSString *))completionVideoHandler
{
    self = [super init];
    if (self) {
        self.completionImageHandler = completionImageHandler;
        self.completionVideoHandler = completionVideoHandler;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.cameraView startPreview];
    [super viewWillDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.cameraView stopPreview];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.cameraFunctionView];
    [self.view addSubview:self.cameraResultView];
}

#pragma mark - JTCameraFunctionDelegate
- (void)closeCamera
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)flashCamera
{
    [self.cameraView flashCamera];
}

- (void)modeCamera
{
    [self.cameraView modeCamera];
}

- (void)photograph
{
    __weak typeof(self) weakself = self;
    [self.cameraView photographWithCompletionImageHandler:^(UIImage *image) {
        [weakself.cameraResultView setImage:image];
    }];
}

- (void)startVideoRecorder
{
    [self.cameraView startVideoRecorder];
}

- (void)stopVideoRecorder:(CGFloat)recorderDuration
{
    __weak typeof(self) weakself = self;
    [self.cameraView stopVideoRecorder:recorderDuration completionVideoHandler:^(NSString *outPath) {
        [weakself.cameraResultView setVideoPath:outPath];
    }];
}

#pragma mark - JTCameraResultDelegate
- (void)remake
{
    [self.cameraView startPreview];
}

- (void)sendImage:(UIImage *)image
{
    _completionImageHandler(image);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendVideo:(NSString *)videoPath
{
    _completionVideoHandler(videoPath);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (JTCameraView *)cameraView
{
    if (!_cameraView) {
        _cameraView = [[JTCameraView alloc] initWithFrame:self.view.bounds minDuration:3 maxDuration:10];
    }
    return _cameraView;
}

- (JTCameraFunctionView *)cameraFunctionView
{
    if (!_cameraFunctionView) {
        _cameraFunctionView = [[JTCameraFunctionView alloc] initWithFrame:self.view.bounds delegate:self maxRecorderDuration:10];
    }
    return _cameraFunctionView;
}

- (JTCameraResultView *)cameraResultView
{
    if (!_cameraResultView) {
        _cameraResultView = [[JTCameraResultView alloc] initWithFrame:self.view.bounds delegate:self];
    }
    return _cameraResultView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
