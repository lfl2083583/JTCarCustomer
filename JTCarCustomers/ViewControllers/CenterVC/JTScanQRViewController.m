//
//  JTScanQRViewController.m
//  JTCarCustomers
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 JTTeam. All rights reserved.
//
#import "JTPersonQRView.h"
#import "JTScanQRViewController.h"
#import "JTCardViewController.h"
#import "JTSessionViewController.h"
#import "JTTeamInfoViewController.h"
#import "JTDeviceAccess.h"


@interface JTScanQRViewController () <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isResultHandler;
}

#pragma mark - ---属性---
/**
 *输入输出中间桥梁(会话)
 */
@property (strong, nonatomic) AVCaptureSession *session;

/**
 *计时器
 */
@property (strong, nonatomic) CADisplayLink *link;

/**
 *有效扫描区域循环往返的一条线（这里用的是一个背景图）
 */
@property (strong, nonatomic) UIImageView *scrollLine;

/**
 *扫码有效区域外自加的文字提示
 */
@property (strong, nonatomic) UILabel *tip;

/**
 *用于底图
 */
@property (strong, nonatomic) UIView *bottom;

/**
 *用于相册
 */
@property (strong, nonatomic) UIButton *album;

/**
 *用于控制照明灯的开启
 */
@property (strong, nonatomic) UIButton *lamp;

/**
 *用于控制照明灯的开启
 */
@property (strong, nonatomic) UIButton *code;

/**
 *用于记录scrollLine的上下循环状态
 */
@property (assign, nonatomic) BOOL up;

/**
 *用户导航条的颜色设置
 */
@property (strong, nonatomic) UINavigationBar *navigationBar;

#pragma mark -------

@end

@implementation JTScanQRViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.up = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"扫一扫"];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        //无权限提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机\n设置>隐私>相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
    }
    isResultHandler = YES;
    [self session];
    
    // 2.添加一个上下循环运动的线条（这里直接是添加一个背景图片来运动）
    [self.view addSubview:self.scrollLine];
    
    // 3.添加其他有效控件
    [self.view addSubview:self.tip];
    [self.view addSubview:self.bottom];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.session startRunning];
    // 计时器添加到循环中去
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
    [self.link invalidate];
    self.link = nil;
}

- (UIImageView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-kScrollLineWidth)/2, kStatusBarHeight+kTopBarHeight+kFrameTop, kScrollLineWidth, kScrollLineHeight)];
        _scrollLine.image = [UIImage imageNamed:Line_img];
    }
    return _scrollLine;
}

- (UILabel *)tip {
    if (!_tip) {
        _tip = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight+kTipY, App_Frame_Width, kTipHeight)];
        _tip.text = @"将取景框对准二维码即可自动扫描";
        _tip.numberOfLines = 0;
        _tip.textColor = WhiteColor;
        _tip.textAlignment = NSTextAlignmentCenter;
        _tip.font = [UIFont systemFontOfSize:14];
    }
    return _tip;
}

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(lineAnimation)];
    }
    return _link;
}

- (UIView *)bottom
{
    if (!_bottom) {
        _bottom = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-100, App_Frame_Width, 100)];
        _bottom.backgroundColor = UIColorFromRGBoraAlpha(0x000000, .5);
        [_bottom addSubview:self.album];
        [_bottom addSubview:self.lamp];
        [_bottom addSubview:self.code];
    }
    return _bottom;
}

- (UIButton *)album
{
    if (!_album) {
        _album = [UIButton buttonWithType:UIButtonTypeCustom];
        [_album setImage:[UIImage imageNamed:album_nor] forState:UIControlStateNormal];
        [_album setImage:[UIImage imageNamed:album_down] forState:UIControlStateHighlighted];
        _album.frame = CGRectMake(kButtonSpace, 0, kButtonWidth, 100);
        [_album addTarget:self action:@selector(touchAlbum:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _album;
}

- (UIButton *)lamp {
    if (!_lamp) {
        _lamp = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lamp setImage:[UIImage imageNamed:lamp_on] forState:UIControlStateNormal];
        [_lamp setImage:[UIImage imageNamed:lamp_off] forState:UIControlStateSelected];
        _lamp.frame = CGRectMake(CGRectGetMaxX(self.album.frame)+kButtonSpace, 0, kButtonWidth, 100);
        [_lamp addTarget:self action:@selector(touchLamp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lamp;
}

- (UIButton *)code
{
    if (!_code) {
        _code = [UIButton buttonWithType:UIButtonTypeCustom];
        [_code setImage:[UIImage imageNamed:code_nor] forState:UIControlStateNormal];
        [_code setImage:[UIImage imageNamed:code_down] forState:UIControlStateHighlighted];
        _code.frame = CGRectMake(CGRectGetMaxX(self.lamp.frame)+kButtonSpace, 0, kButtonWidth, 100);
        [_code addTarget:self action:@selector(touchCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _code;
}

- (AVCaptureSession *)session {
    if (!_session) {
        // 1.获取输入设备（摄像头）
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 2.根据输入设备创建输入对象
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
        if (input == nil) {
            return nil;
        }
        
        // 3.创建元数据的输出对象
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        
        // 4.设置代理监听输出对象输出的数据,在主线程中刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 5.创建会话(桥梁)
        AVCaptureSession *session = [[AVCaptureSession alloc]init];
        
        // 实现高质量的输出和摄像，默认值为AVCaptureSessionPresetHigh，可以不写
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        // 6.添加输入和输出到会话中（判断session是否已满）
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        if ([session canAddOutput:output]) {
            [session addOutput:output];
        }
        
        // 7.告诉输出对象, 需要输出什么样的数据 (二维码还是条形码等) 要先创建会话才能设置
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode];
        
        // 8.创建预览图层
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        [previewLayer setFrame:self.view.bounds];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.view.layer insertSublayer:previewLayer atIndex:0];
        
        // 9.设置有效扫描区域，默认整个图层(很特别，1、要除以屏幕宽高比例，2、其中x和y、width和height分别互换位置)
        CGRect rect = CGRectMake((kStatusBarHeight+kTopBarHeight+kFrameTop)/APP_Frame_Height, kFrameLeft/App_Frame_Width, kFrameHeight/APP_Frame_Height, kFrameWidth/App_Frame_Width);
        output.rectOfInterest = rect;
        
        // 10.设置中空区域，即有效扫描区域(中间扫描区域透明度比周边要低的效果)
        UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        [maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:kBgAlpha]];
        [self.view addSubview:maskView];
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
        [rectPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kFrameLeft, kStatusBarHeight+kTopBarHeight+kFrameTop, kFrameWidth, kFrameHeight) cornerRadius:1] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = rectPath.CGPath;
        maskView.layer.mask = shapeLayer;
        
        _session = session;
    }
    return _session;
}

- (void)lineAnimation {
    if (_up == YES) {
        CGFloat y = self.scrollLine.frame.origin.y;
        y += 2;
        [self.scrollLine setY:y];
        if (y >= (kStatusBarHeight+kTopBarHeight+kFrameTop+kFrameWidth-kScrollLineHeight)) {
            _up = NO;
        }
    } else {
        CGFloat y = self.scrollLine.frame.origin.y;
        y -= 2;
        [self.scrollLine setY:y];
        if (y <= kStatusBarHeight+kTopBarHeight+kFrameTop) {
            _up = YES;
        }
    }
}

#pragma mark - 调用相册
- (void)touchAlbum:(id)sender {
    //1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    // 2.创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    // 选中之后大图编辑模式
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}


#pragma mark - 开灯或关灯
- (void)touchLamp:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    [ScanCodeQRSystemFunctions openLight:btn.selected];
}

#pragma mark - 我的二维码
- (void)touchCode:(id)sender {

    [[Utility mainWindow] presentView:[[[NSBundle mainBundle] loadNibNamed:@"JTPersonQRView" owner:nil options:nil] lastObject] animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
//相册获取的照片进行处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    // 2.从选中的图片中读取二维码数据
    // 2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 2.3取出探测到的数据
    if (feature.count == 0) {
        [[HUDTool shareHUDTool] showHint:@"没有扫描到有效二维码"];
    }
    else
    {
        for (CIQRCodeFeature *result in feature) {
            NSString *message = result.messageString;
            // 二维码信息回传
            [self handleScanResult:message];
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
// 扫描到数据时会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0 && isResultHandler) {
        [ScanCodeQRSystemFunctions openShake:YES Sound:YES];
        // 3.取出扫描到得数据
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        if (obj) {
            //二维码信息回传
            [self handleScanResult:[obj stringValue]];
        }
    }
}

- (void)extracted:(NSString *)message weakself:(JTScanQRViewController *const __weak)weakself {
    [ScanCodeQRSystemFunctions showInSafariWithURLMessage:message Success:^(id source, QRCodeType qrcodeType, id info) {
        
        [weakself.session stopRunning];// 1.停止扫描
        [weakself.link invalidate];
        weakself.link = nil;
        //[weakself.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];// 2.停止冲击波
        if (qrcodeType == QRCodeTypeWebUrl) {
           //[weakself pushNextViewController:[[NormalWebViewController alloc] initWithNavTitle:nil urlString:source]];
        }
        else if (qrcodeType == QRCodeTypeUser) {
            NSDictionary *dictionary = source;
            [weakself pushNextViewController:[[JTCardViewController alloc] initWithUserID:dictionary[@"userID"]]];
        }
        else if (qrcodeType == QRCodeTypeSession) {
            [weakself pushNextViewController:[[JTSessionViewController alloc] initWithSession:[NIMSession session:source type:NIMSessionTypeTeam]]];
        }
        else if (qrcodeType == QRCodeTypeGroup) {
            NSDictionary *dictionary = source;
            NIMTeam *team = info;
            JTTeamInfoViewController *teamInfoVC = [[JTTeamInfoViewController alloc] initWithTeam:team teamSource:JTTeamSourceFromQR];
            teamInfoVC.inviteID = dictionary[@"inveterID"];
            [weakself pushNextViewController:teamInfoVC];
        }
        else if (qrcodeType == QRCodeTypeInviteCode) {
            
        }
        
    } Failure:^(NSError *error) {
        
        [[HUDTool shareHUDTool] showHint:@"该信息无法跳转"];
        isResultHandler = YES;
    }];
}

- (void)handleScanResult:(NSString *)message
{
    isResultHandler = NO;
    __weak typeof(self) weakself = self;
    [self extracted:message weakself:weakself];
}

- (void)pushNextViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    UIViewController *root = self.navigationController.viewControllers[0];
    self.navigationController.viewControllers = @[root, viewController];
}

#pragma mark - 二维码块传值
- (void)successfulGetQRCodeInfo:(successBlock)success {
    self.block = success;
}

- (void)dealloc
{
    CCLOG(@"JTScanQRViewController释放了");
}

@end
