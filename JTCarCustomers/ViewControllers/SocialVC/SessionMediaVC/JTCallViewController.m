//
//  JTCallViewController.m
//  JTSocial
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCallViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JTCallViewController () <NIMNetCallManagerDelegate>
{
    SystemSoundID ringSystemSoundID;
    
    // 视频才有的属性
    BOOL isFrameChange; // YES:本地视频显示大
    BOOL isHideVideoUI; // 是否显示视频UI
    BOOL isHideAudioUI; // 是否隐藏音频UI
}

@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation JTCallViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [JTSocialStautsUtil sharedCenter].netCallStatus = JTNetCallStatusConnect;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [JTSocialStautsUtil sharedCenter].netCallStatus = JTNetCallStatusNone;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    [self.view insertSubview:self.maskView atIndex:0];
    [self.view insertSubview:self.bottom atIndex:0];
    
//    __weak typeof(self) weakself = self;
    [Utility downloadImageWithURLString:self.userinfo.avatarUrl success:^(UIImage *image) {
//        [weakself.bottom setImage:[Utility boxblurImage:image withBlurNumber:.3]];
    }];
    if (self.callType == NIMNetCallTypeVideo && self.isIssue) {
        [self.view insertSubview:self.bigVideoPreView atIndex:2];
        [self.view insertSubview:self.smallVideoPreView atIndex:3];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:YES];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    [self changeHeadsetPluggedIn:[Utility isHeadsetPluggedIn]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateChangeNotification:) name:kCallStateChangeNotification object:nil];
    [super viewDidLoad];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)onTimer:(NSTimer *)timer
{
    runCount ++;
    
    if (isConnectionSuccess)
    {
        NSString *dateStr = @"";
        NSInteger hour = runCount / 3600;
        NSInteger minute = runCount % 3600 / 60;
        NSInteger second = runCount % 3600 % 60;
        if (hour > 0) {
            dateStr = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)hour, (int)minute, (int)second];
        } else {
            dateStr = [NSString stringWithFormat:@"%02d:%02d", (int)minute, (int)second];
        }
        [self updateTimeLB:dateStr];
    }
    else
    {
        if (runCount == NoBodyPromptTimeOut) {
            if (self.isIssue) {
                [self showHint:@"对方手机可能不在身边，建议稍后再次尝试"];
            }
        }
        else if (runCount > NoBodyResponseTimeOut) {
            if (self.isIssue) {
                [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callID];
                [self playTimeOutRing];
                [self closeCall];
            }
        }
    }
}

- (void)audioRouteChangeListenerCallback:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            [self changeHeadsetPluggedIn:YES];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            [self changeHeadsetPluggedIn:NO];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            break;
    }
}

- (void)callStateChangeNotification:(NSNotification *)notification {
    
    if ([notification.object boolValue]) {
        if (!isConnectionSuccess && !_isIssue) {
            [self responseCall:NO];
        }
        else
        {
            [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callID];
            [self closeRing];
            [self closeCall];
        }
    }
}

- (void)responseCall:(BOOL)accept
{
    __weak typeof(self) weakself = self;
    [[NIMAVChatSDK sharedSDK].netCallManager response:self.callID accept:accept option:self.option completion:^(NSError *error, UInt64 callID) {
        if (!error) {
            [weakself inConnection];
        }
        else {
            [weakself showHint:@"连接失败"];
            [weakself closeCall];
        }
    }];
    [self closeRing];
    if (accept) {
        [self waitForConnection];
    }
    else {
        [self showHint:@"聊天已取消"];
        [self closeCall];
    }
}

- (void)closeCall
{
    [self stopTimer];
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onResponse:(UInt64)callID from:(NSString *)callee accepted:(BOOL)accepted {
    
    [self closeRing];
    if (self.callID == callID) {
        if (!accepted) {
            [self showHint:(self.callType == NIMNetCallTypeAudio)?@"对方拒绝你的语音聊天请求":@"对方拒绝你的视频聊天请求"];
            [self playHangUpRing];
            [self closeCall];
        }
        else
        {
            [self inConnection];
        }
    }
}

- (void)onHangup:(UInt64)callID
              by:(NSString *)user
{
    if (self.callID == callID) {
        [self showHint:isConnectionSuccess?@"对方已挂断，聊天结束":@"聊天已取消"];
        [self closeCall];
    }
}

- (void)onResponsedByOther:(UInt64)callID
                  accepted:(BOOL)accepted
{
    
}

- (void)onCallEstablished:(UInt64)callID
{
    if (self.callID == callID) {
        runCount = 0;
        isConnectionSuccess = YES;
        [self connectionSuccess];
    }
    [self closeRing];
}

- (void)onCallDisconnected:(UInt64)callID
                 withError:(nullable NSError *)error
{
    if (self.callID == callID) {
        [self showHint:@"连接失败"];
        [self closeCall];
    }
}

- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control
{
    if (self.callID == callID) {
        switch (control) {

            case NIMNetCallControlTypeToAudio:
            {
                [[NIMAVChatSDK sharedSDK].netCallManager switchType:NIMNetCallMediaTypeAudio];
                [self setCallType:NIMNetCallMediaTypeAudio];
                [self showHint:@"对方已切到语音聊天，请使用听筒接听"];
                [self switchToAudioUI];
            }
                break;
            case NIMNetCallControlTypeBusyLine:
            {
                [[NIMAVChatSDK sharedSDK].netCallManager hangup:callID];
                [self showHint:(self.callType == NIMNetCallTypeAudio)?@"对方线路忙，请稍后重新邀请对方语音聊天。":@"对方线路忙，请稍后重新邀请对方视频聊天。"];
                [self playOnCallRing];
                [self closeCall];
            }
                break;
            case NIMNetCallControlTypeFeedabck:
            {
            }
                break;
            default:
                break;
        }
    }
}

- (void)onNetStatus:(NIMNetCallNetStatus)status
               user:(NSString *)user
{
    if ([[JTUserInfo shareUserInfo].userID isEqualToString:user]) {
        [self showHint:@"当前通话连接质量不佳"];
    }
}

- (void)onLocalDisplayviewReady:(UIView *)displayView
{
    if (self.localPreView) {
        [self.localPreView removeFromSuperview];
    }
    displayView.frame = self.bigVideoPreView.bounds;
    displayView.userInteractionEnabled = NO;
    _localPreView = displayView;
    [self.bigVideoPreView addSubview:_localPreView];
}


- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self.remotePreView render:yuvData width:width height:height];
    }
}

- (void)waitForConnection
{
    if (self.callType == NIMNetCallTypeVideo) {
        if (!self.isIssue) {
            [self.view insertSubview:self.bigVideoPreView atIndex:2];
            [self.view insertSubview:self.smallVideoPreView atIndex:3];
        }
    }
}

- (void)inConnection
{
}

- (void)connectionSuccess
{
    if (self.callType == NIMNetCallTypeVideo) {
        [self.localPreView setFrame:self.smallVideoPreView.bounds];
        [self.bigVideoPreView addSubview:self.remotePreView];
        [self.smallVideoPreView addSubview:self.localPreView];
    }
}

- (void)switchToAudioUI
{
    if (_bigVideoPreView) {
        [self.bigVideoPreView removeFromSuperview];
    }
    if (_smallVideoPreView) {
        [self.smallVideoPreView removeFromSuperview];
    }
}

- (void)showVideoUI
{
    
}

- (void)hideVideoUI
{
    
}

- (void)changeHeadsetPluggedIn:(BOOL)pluggedIn
{
    
}

- (void)updateTimeLB:(NSString *)time
{
    
}

- (NIMNetCallOption *)option
{
    if (!_option) {
        _option = [[NIMNetCallOption alloc] init];
        _option.videoCaptureParam = self.param;
        _option.autoRotateRemoteVideo = YES;
        _option.preferredVideoEncoder = NIMNetCallVideoCodecDefault;
        _option.preferredVideoDecoder = NIMNetCallVideoCodecDefault;
        /*
         _option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
         */
        _option.autoDeactivateAudioSession = YES;
        _option.audioDenoise = YES;
        _option.voiceDetect = YES;
        _option.audioHowlingSuppress = NO;
        _option.preferHDAudio = NO;
        _option.scene = NIMAVChatSceneDefault;
        _option.serverRecordAudio = NO;
        _option.serverRecordVideo = NO;
        _option.webrtcCompatible = NO;
    }
    return _option;
}

- (NIMNetCallVideoCaptureParam *)param
{
    if (!_param) {
        _param = [[NIMNetCallVideoCaptureParam alloc] init];
        _param.preferredVideoQuality = NIMNetCallVideoQualityDefault;
        _param.startWithBackCamera = NO;
    }
    return _param;
}

- (UIImageView *)bottom
{
    if (!_bottom) {
        _bottom = [[UIImageView alloc] init];
        _bottom.frame = SC_DEVICE_BOUNDS;
        _bottom.backgroundColor = [UIColor clearColor];
        _bottom.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bottom;
}

- (UIView *)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.frame = SC_DEVICE_BOUNDS;
        _maskView.backgroundColor = RGBCOLOR(39, 47, 53, 0.55);
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomDidTap:)];
        _tapGesture.numberOfTapsRequired    = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_maskView addGestureRecognizer:_tapGesture];

    }
    return _maskView;
}

- (UIView *)bigVideoPreView
{
    if (!_bigVideoPreView) {
        _bigVideoPreView = [[UIView alloc] init];
        _bigVideoPreView.frame = SC_DEVICE_BOUNDS;
        _bigVideoPreView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigDidTap:)];
        _tapGesture.numberOfTapsRequired    = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_bigVideoPreView addGestureRecognizer:_tapGesture];
    }
    return _bigVideoPreView;
}

- (UIView *)smallVideoPreView
{
    if (!_smallVideoPreView) {
        _smallVideoPreView = [[UIView alloc] init];
        float ratio = kScreenHeight/750;
        _smallVideoPreView.frame = CGRectMake(kScreenWidth-ratio*200-5, 20, ratio*200, ratio*355);
        _smallVideoPreView.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(smallDidPan:)];
        _panGesture.minimumNumberOfTouches  = 1;
        _panGesture.maximumNumberOfTouches  = 1;
        [_smallVideoPreView addGestureRecognizer:_panGesture];
        
        UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallDidTap:)];
        _tapGesture.numberOfTapsRequired    = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_smallVideoPreView addGestureRecognizer:_tapGesture];
    }
    return _smallVideoPreView;
}

- (NTESGLView *)remotePreView
{
    if (!_remotePreView) {
        _remotePreView = [[NTESGLView alloc] init];
        _remotePreView.frame = SC_DEVICE_BOUNDS;
        _remotePreView.contentMode = UIViewContentModeScaleAspectFill;
        _remotePreView.backgroundColor = [UIColor clearColor];
    }
    return _remotePreView;
}

- (void)bottomDidTap:(UIPanGestureRecognizer *)panGesture
{
    if (isConnectionSuccess) {
        isHideAudioUI = !isHideAudioUI;
        if (isHideAudioUI) {
            
        }
        else
        {
            
        }
    }
}

- (void)bigDidTap:(UIPanGestureRecognizer *)panGesture
{
    if (isConnectionSuccess) {
        isHideVideoUI = !isHideVideoUI;
        if (isHideVideoUI) {
            [self hideVideoUI];
        }
        else
        {
            [self showVideoUI];
        }
    }
}

- (void)smallDidPan:(UIPanGestureRecognizer *)panGesture
{
    if (isConnectionSuccess) {
        CGPoint translation = [panGesture translationInView:self.view];
        if ((panGesture.view.left + translation.x) >= 5 && (panGesture.view.right + translation.x) <= kScreenWidth-5
            && (panGesture.view.top + translation.y) >= 20 && (panGesture.view.bottom + translation.y) <= kScreenHeight-5) {
            panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);
        }
        if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
            if (panGesture.view.left > 5 && panGesture.view.center.x < kScreenWidth/2) {
                [UIView animateWithDuration:.15 animations:^{
                    panGesture.view.left = 5;
                }];
            }
            else if (panGesture.view.center.x > kScreenWidth/2 && panGesture.view.right < kScreenWidth-5) {
                [UIView animateWithDuration:.15 animations:^{
                    panGesture.view.right = kScreenWidth-5;
                }];
            }
        }
        [panGesture setTranslation:CGPointZero inView:self.view];
    }
}

- (void)smallDidTap:(UITapGestureRecognizer *)tapGesture
{
    if (isConnectionSuccess) {
        isFrameChange = !isFrameChange;
        if (isFrameChange) {
            [self.localPreView setFrame:self.bigVideoPreView.bounds];
            [self.remotePreView setFrame:self.smallVideoPreView.bounds];
            [self.bigVideoPreView addSubview:self.localPreView];
            [self.smallVideoPreView addSubview:self.remotePreView];
        }
        else
        {
            [self.localPreView setFrame:self.smallVideoPreView.bounds];
            [self.remotePreView setFrame:self.bigVideoPreView.bounds];
            [self.bigVideoPreView addSubview:self.remotePreView];
            [self.smallVideoPreView addSubview:self.localPreView];
        }
    }
}


- (void)showHint:(NSString *)hint
{
    [[HUDTool shareHUDTool] showHint:hint yOffset:[UIScreen mainScreen].bounds.size.height/2 - 150];
}

#pragma mark - Ring
// 铃声 - 正在呼叫请稍后
- (void)playConnnetRing {
    [self closeRing];
    [self playAudio:@"video_connect_chat_tip_sender"];
    [self.player setNumberOfLoops:1];
}

// 铃声 - 对方暂时无法接听
- (void)playHangUpRing {
    [self closeRing];
    [self playAudio:@"video_chat_tip_HangUp"];
    [self.player setNumberOfLoops:1];
}

// 铃声 - 对方正在通话中
- (void)playOnCallRing {
    [self closeRing];
    [self playAudio:@"video_chat_tip_OnCall"];
    [self.player setNumberOfLoops:1];
}

// 铃声 - 对方无人接听
- (void)playTimeOutRing {
    [self closeRing];
    [self playAudio:@"video_chat_tip_onTimer"];
    [self.player setNumberOfLoops:1];
}

// 铃声 - 接收方铃声
- (void)playReceiverRing {
    [self closeRing];
    [self playAudio:@"video_chat_tip_receiver"];
    [self.player setNumberOfLoops:20];
}

// 铃声 - 拨打方铃声
- (void)playSenderRing {
    [self closeRing];
    [self playAudio:@"video_chat_tip_sender"];
    [self.player setNumberOfLoops:20];
}

// 铃声 - 关闭铃声
- (void)closeRing {
    [self.player stop];
}

- (void)playAudio:(NSString *)urlName;
{
    NSURL *audioPath = [[NSBundle mainBundle] URLForResource:urlName withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioPath error:nil];
    if (self.player) {
        [self.player play];
    }
}

@end
