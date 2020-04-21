//
//  JTCallOnViewController.m
//  JTSocial
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCallOnViewController.h"
#import "ZTCirlceImageView.h"

@interface JTCallOnViewController ()

@property (weak, nonatomic) IBOutlet ZTCirlceImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *promptLB;

@property (weak, nonatomic) IBOutlet UIButton *handUpBT;
@property (weak, nonatomic) IBOutlet UILabel *handUPLB;
@property (weak, nonatomic) IBOutlet UIButton *connectBT;
@property (weak, nonatomic) IBOutlet UILabel *connectLB;
@property (weak, nonatomic) IBOutlet UIButton *muteBT;
@property (weak, nonatomic) IBOutlet UILabel *muteLB;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;
@property (weak, nonatomic) IBOutlet UILabel *cancelLB;
@property (weak, nonatomic) IBOutlet UIButton *speakerBT;
@property (weak, nonatomic) IBOutlet UILabel *speakerLB;
@property (weak, nonatomic) IBOutlet UIButton *voiceBT;
@property (weak, nonatomic) IBOutlet UILabel *voiceLB;
@property (weak, nonatomic) IBOutlet UIButton *pickUpBT;
@property (weak, nonatomic) IBOutlet UILabel *pickUpLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@end

@implementation JTCallOnViewController

- (instancetype)initWithNetCallMediaType:(NIMNetCallMediaType)callType caller:(NSString *)caller callId:(uint64_t)callID {
    self = [super initWithNibName:@"JTCallOnViewController" bundle:nil];
    if (self) {
        self.isIssue = NO;
        self.callType = callType;
        self.caller = caller;
        self.callID = callID;
        self.userinfo = [[[NIMSDK sharedSDK].userManager userInfo:self.caller] userInfo];
        [[NIMAVChatSDK sharedSDK].netCallManager switchType:callType];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.avatar setAvatarByUrlString:[self.userinfo.avatarUrl avatarHandleWithSquare:120] defaultImage:DefaultBigAvatar];
    _nameLB.text = [JTUserInfoHandle showNick:self.caller];
    _promptLB.text = (self.callType == NIMNetCallTypeVideo) ? @"邀请你进行视频聊天..." : @"邀请你进行语音聊天...";
    if (self.callType == NIMNetCallTypeAudio) {
        [self showHint:@"请用听筒接听"];
    }
    [self playReceiverRing];
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callID type:NIMNetCallControlTypeFeedabck];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)hangUpClick:(id)sender {
    [self responseCall:NO];
}

- (IBAction)connectClick:(id)sender {
    __weak typeof(self) weakself = self;
    if (self.callType == NIMNetCallTypeVideo) {
        [JTDeviceAccess checkNetworkEnable:@"在移动网络环境下开启音视频会消耗您的流量，是否继续开启" result:^(BOOL result) {
            if (result) {
                [JTDeviceAccess checkMicrophoneEnable:@"麦克风权限受限,无法视频聊天" result:^(BOOL result) {
                    if (result) {
                        [JTDeviceAccess checkCameraEnable:@"相机权限受限,无法视频聊天" result:^(BOOL result) {
                            if (result) {
                                [weakself responseCall:result];
                            }
                            else
                            {
                                [weakself responseCall:NO];
                            }
                        }];
                    }
                    else
                    {
                        [weakself responseCall:NO];
                    }
                }];
            }
            else
            {
                [weakself responseCall:NO];
            }
        }];
    }
    else
    {
        [JTDeviceAccess checkNetworkEnable:@"在移动网络环境下开启音视频会消耗您的流量，是否继续开启" result:^(BOOL result) {
            if (result) {
                [JTDeviceAccess checkMicrophoneEnable:@"麦克风权限受限,无法语音聊天" result:^(BOOL result) {
                    if (result) {
                        [weakself responseCall:result];
                    }
                    else
                    {
                        [weakself responseCall:NO];
                    }
                }];
            }
            else
            {
                [weakself responseCall:NO];
            }
        }];
    }
}

- (IBAction)muteClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NIMAVChatSDK sharedSDK].netCallManager setMute:sender.selected];
}

- (IBAction)cancelClick:(id)sender {
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callID];
    [self showHint:@"聊天结束"];
    [self closeCall];
}

- (IBAction)speakerClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:sender.selected];
}

- (IBAction)voiceClick:(id)sender {
    [self showHint:@"请用听筒接听"];
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callID type:NIMNetCallControlTypeToAudio];
    [[NIMAVChatSDK sharedSDK].netCallManager switchType:NIMNetCallMediaTypeAudio];
    [self setCallType:NIMNetCallMediaTypeAudio];
    [self switchToAudioUI];
}

- (IBAction)pickUpClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:sender.selected?NIMNetCallCameraBack:NIMNetCallCameraFront];
}

- (void)waitForConnection
{
    [super waitForConnection];
    self.promptLB.text = @"正在连接对方...请稍后...";
    [self changeUIStuats];
}

- (void)inConnection
{
    [super inConnection];
    [self.promptLB setHidden:YES];
}

- (void)connectionSuccess
{
    [super connectionSuccess];
}

- (void)switchToAudioUI
{
    [super switchToAudioUI];
    [self changeUIStuats];
}

- (void)showVideoUI
{
    [super showVideoUI];
    [self.cancelBT setHidden:NO];
    [self.cancelLB setHidden:NO];
    [self.voiceBT setHidden:NO];
    [self.voiceLB setHidden:NO];
    [self.pickUpBT setHidden:NO];
    [self.pickUpLB setHidden:NO];
    [self.timeLB setHidden:NO];
}

- (void)hideVideoUI
{
    [super hideVideoUI];
    [self.cancelBT setHidden:YES];
    [self.cancelLB setHidden:YES];
    [self.voiceBT setHidden:YES];
    [self.voiceLB setHidden:YES];
    [self.pickUpBT setHidden:YES];
    [self.pickUpLB setHidden:YES];
    [self.timeLB setHidden:YES];
}

- (void)changeHeadsetPluggedIn:(BOOL)pluggedIn
{
    [self.speakerBT setSelected:NO];
    [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:NO];
    [self.speakerBT setUserInteractionEnabled:!pluggedIn];
    [self.speakerBT setImage:[UIImage imageNamed:pluggedIn?@"bt_speaker_invalid":@"bt_speaker_normal"] forState:UIControlStateNormal];
}

- (void)updateTimeLB:(NSString *)time
{
    [super updateTimeLB:time];
    [self.timeLB setText:time];
}

- (void)changeUIStuats
{
    [self.handUpBT setHidden:YES];
    [self.handUPLB setHidden:YES];
    [self.connectBT setHidden:YES];
    [self.connectLB setHidden:YES];
    [self.avatar setHidden:(self.callType == NIMNetCallTypeVideo)];
    [self.nameLB setHidden:(self.callType == NIMNetCallTypeVideo)];
    [self.muteBT setHidden:(self.callType == NIMNetCallTypeVideo)];
    [self.muteLB setHidden:(self.callType == NIMNetCallTypeVideo)];
    [self.speakerBT setHidden:(self.callType == NIMNetCallTypeVideo)];
    [self.speakerLB setHidden:(self.callType == NIMNetCallTypeVideo)];
    [self.cancelBT setHidden:NO];
    [self.cancelLB setHidden:NO];
    [self.voiceBT setHidden:!(self.callType == NIMNetCallTypeVideo)];
    [self.voiceLB setHidden:!(self.callType == NIMNetCallTypeVideo)];
    [self.pickUpBT setHidden:!(self.callType == NIMNetCallTypeVideo)];
    [self.pickUpLB setHidden:!(self.callType == NIMNetCallTypeVideo)];
    [self.timeLB setHidden:NO];
}

@end
