//
//  JTLivePlayViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTLivePlayViewController.h"
#import "NELivePlayerController.h"
#import "ZTPopoverViewController.h"

@interface JTLivePlayViewController ()

@property (strong, nonatomic) NELivePlayerController *player; //播放器sdk
@property (strong, nonatomic) UIView *playerContainerView; //播放器包裹视图
@property (weak, nonatomic) IBOutlet UIView *operationView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *promptLB;
@property (weak, nonatomic) IBOutlet UIView *connectView;


@end

@implementation JTLivePlayViewController

- (instancetype)initWithStoreServiceLiveModel:(JTStoreServiceLiveModel *)model
{
    self = [super initWithNibName:@"JTLivePlayViewController" bundle:nil];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)dealloc
{
    [self.activityIndicatorView stopAnimating];
    [self.player shutdown]; // 退出播放并释放相关资源
    [self.player.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _playerContainerView.frame = self.view.bounds;
    _player.view.frame = self.playerContainerView.bounds;
}

- (IBAction)reconnectClick:(id)sender {
    [self.activityIndicatorView startAnimating];
    [self.loadingView setHidden:NO];
    [self.promptLB setHidden:YES];
    [self.connectView setHidden:YES];
}

- (IBAction)angleClick:(UIButton *)sender {
    
//    __weak typeof(self) weakself = self;
    ZTPopoverModel *model = [[ZTPopoverModel alloc] initWithTextFont:Font(14) textColor:BlackLeverColor3 selectTextColor:BlueLeverColor1 iconArr:nil titleArr:@[@"发起群聊", @"添加朋友", @"拍照分享", @"扫一扫"] doneBlock:^(NSInteger selectedIndex) {
        switch (selectedIndex) {
            case 0:
            {
            }
                break;
            case 1:
            {
            }
                break;
            case 2:
            {
            }
                break;
            case 3:
            {
            }
                break;
            default:
                break;
        }
    }];
    ZTPopoverViewController *itemPopVC = [[ZTPopoverViewController alloc] init];
    itemPopVC.model = model;
    itemPopVC.popoverPresentationController.sourceView = sender;  //rect参数是以view的左上角为坐标原点（0，0）
    itemPopVC.popoverPresentationController.sourceRect = sender.bounds;
    [self presentViewController:itemPopVC animated:YES completion:nil];
}

- (IBAction)shareClick:(id)sender {
}

- (IBAction)closeClick:(id)sender {
    [JTSocialStautsUtil sharedCenter].liveStatus = JTLiveStatusNone;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)downClick:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:[@[@"bt_liveUp_right", @"bt_liveDown_right", @"bt_liveLeft_right", @"bt_liveRight_right"] objectAtIndex:sender.tag]] forState:UIControlStateNormal];
    [[HttpRequestTool sharedInstance] postWithURLString:Camera_Start parameters:@{@"accessToken": @"at.4twhxqzo7bwotv4352q98cn7b1cnk6i2-9gtzze9uvh-0cxrx69-tntlh8dok", @"deviceSerial": @"C13978870", @"channelNo": @"1", @"direction": @(sender.tag), @"speed": @"1"} success:^(id responseObject, ResponseState state) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)upClick:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:[@[@"bt_liveUp", @"bt_liveDown", @"bt_liveLeft", @"bt_liveRight"] objectAtIndex:sender.tag]] forState:UIControlStateNormal];
    [[HttpRequestTool sharedInstance] postWithURLString:Camera_Stop parameters:@{@"accessToken": @"at.4twhxqzo7bwotv4352q98cn7b1cnk6i2-9gtzze9uvh-0cxrx69-tntlh8dok", @"deviceSerial": @"C13978870", @"channelNo": @"1", @"direction": @(sender.tag)} success:^(id responseObject, ResponseState state) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [JTSocialStautsUtil sharedCenter].liveStatus = JTLiveStatusWatching;
    [self.view insertSubview:self.playerContainerView atIndex:0];
    [self.playerContainerView addSubview:self.player.view];
    [self.player prepareToPlay];
    [self.activityIndicatorView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlaybackStateChanged:)
                                                 name:NELivePlayerPlaybackStateChangedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSueecss:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerMoviePlayerSeekCompleted:)
                                                 name:NELivePlayerMoviePlayerSeekCompletedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_player];
    
}
//https://open.ys7.com/doc/zh/book/index/device_ptz.html#device_ptz-api1
///调用prepareToPlay后，播放器初始化视频文件完成后的消息通知
- (void)NELivePlayerDidPreparedToPlay:(NSNotification *)notification {
}
///播放器加载状态发生改变时的消息通知
- (void)NeLivePlayerloadStateChanged:(NSNotification *)notification {
    switch (self.player.loadState) {
        case NELPMovieLoadStatePlayable:        // 在该状态下，播放器初始化完成，可以播放，若shouldAutoplay 设置成YES，播放器初始化完成后会自动播放；
            break;
        case NELPMovieLoadStatePlaythroughOK:   // 在该状态下，在网络不好的情况下缓冲完成，可以播放
        {
            [self.activityIndicatorView stopAnimating];
            [self.loadingView setHidden:YES];
            [self.promptLB setHidden:YES];
            [self.connectView setHidden:YES];
        }
            break;
        case NELPMovieLoadStateStalled:         // 在播放过程中网络不好需要缓冲数据的时候播放会自动暂停
        {
            [self.activityIndicatorView startAnimating];
            [self.loadingView setHidden:NO];
            [self.promptLB setHidden:YES];
            [self.connectView setHidden:YES];
        }
            break;
        default:
            break;;
    }
}
///播放器播放完成或播放发生错误时的消息通知。
- (void)NELivePlayerPlayBackFinished:(NSNotification *)notification {
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue]) {
        case NELPMovieFinishReasonPlaybackEnded:   // 正常播放结束
        {
            [self.activityIndicatorView stopAnimating];
            [self.loadingView setHidden:YES];
            [self.promptLB setHidden:NO];
            [self.connectView setHidden:YES];
        }
            break;
        case NELPMovieFinishReasonPlaybackError:   // 播放发生错误导致结束
        {
            if (self.promptLB.hidden) {
                [self.activityIndicatorView stopAnimating];
                [self.loadingView setHidden:YES];
                [self.promptLB setHidden:YES];
                [self.connectView setHidden:NO];
            }
        }
            break;
        case NELPMovieFinishReasonUserExited:      // 人为退出(暂未使用，保留值)
            break;
        default:
            break;;
    }
}
///播放器播放状态发生改变时的消息通知
- (void)NELivePlayerPlaybackStateChanged:(NSNotification *)notification {
    switch (self.player.playbackState) {
        case NELPMoviePlaybackStatePaused:    // 停止状态
        {
            [self.activityIndicatorView stopAnimating];
            [self.loadingView setHidden:YES];
            [self.promptLB setHidden:NO];
            [self.connectView setHidden:YES];
        }
            break;
        case NELPMoviePlaybackStatePlaying:   // 播放状态
            break;
        case NELPMoviePlaybackStateStopped:   // 暂停状态，可调play继续播放
            break;
        case NELPMoviePlaybackStateSeeking:   // Seek状态
            break;
        default:
            break;
    }
}
///播放器第一帧视频显示时的消息通知
- (void)NELivePlayerFirstVideoDisplayed:(NSNotification *)notification {
}
///播放器第一帧音频播放时的消息通知
- (void)NELivePlayerFirstAudioDisplayed:(NSNotification *)notification {
}
///播放器资源释放完成时的消息通知
- (void)NELivePlayerReleaseSueecss:(NSNotification *)notification {
}
///seek完成时的消息通知，仅适用于点播，直播不支持。
- (void)NELivePlayerMoviePlayerSeekCompleted:(NSNotification *)notification {
}
///视频码流包解析异常时的消息通知
- (void)NELivePlayerVideoParseError:(NSNotification *)notification {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NELivePlayerController *)player
{
    if (!_player) {
        _player = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"rtmp://rtmp.open.ys7.com/openlive/4d174a52e2544be6bd6eb143c70e6fc9.hd"] error:nil];
#ifdef DEBUG
        [NELivePlayerController setLogLevel:NELP_LOG_DEFAULT];
#else
        [NELivePlayerController setLogLevel:NELP_LOG_SILENT];
#endif
        [_player setBufferStrategy:NELPLowDelay]; // 直播低延时模式
        [_player setPauseInBackground:NO]; // 设置播放器切入后台后的播放状态 YES：后台暂停 NO：继续播放
        [_player setScalingMode:NELPMovieScalingModeNone]; // 设置画面显示模式，默认原始大小
        [_player setMute:YES]; // 静音功能 YES：开启静音 NO：关闭静音
        [_player setHardwareDecoder:NO]; // 设置是否开启硬件解码 YES：硬件解码 NO：软件解码;
        [_player setPlaybackTimeout:30000]; // 设置拉流超时时间
        [_player setShouldAutoplay:YES]; // 设置播放器初始化视频文件完成后是否自动播放，默认自动播放 YES：自动播放 NO：手动播放
    }
    return _player;
}

- (UIView *)playerContainerView
{
    if (!_playerContainerView) {
        _playerContainerView = [[UIView alloc] initWithFrame:SC_DEVICE_BOUNDS];
        _playerContainerView.backgroundColor = [UIColor blackColor];
    }
    return _playerContainerView;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
