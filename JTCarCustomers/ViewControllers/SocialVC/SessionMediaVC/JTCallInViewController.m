//
//  JTCallInViewController.m
//  JTSocial
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCallInViewController.h"
#import "ZTCirlceImageView.h"

@interface JTCallInViewController ()

@property (weak, nonatomic) IBOutlet ZTCirlceImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *promptLB;

@property (weak, nonatomic) IBOutlet UIButton *handUpBT;
@property (weak, nonatomic) IBOutlet UILabel *handUPLB;
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

@implementation JTCallInViewController

- (void)viewDidLoad {
    self.isIssue = YES;
    self.userinfo = [[[NIMSDK sharedSDK].userManager userInfo:self.callee] userInfo];
    [super viewDidLoad];
    [self.avatar setAvatarByUrlString:[self.userinfo.avatarUrl avatarHandleWithSquare:120] defaultImage:DefaultBigAvatar];
    _nameLB.text = [JTUserInfoHandle showNick:self.callee];
    _promptLB.text = @"正在等待对方接收邀请";
    [self startByCaller];
}

- (void)startByCaller {
    self.option.extendMessage = [@{@"userID": [JTUserInfo shareUserInfo].userID} mj_JSONString];
    self.option.apnsContent = [NSString stringWithFormat:@"%@请求", self.callType ? @"语音通话" : @"视频聊天"];
    self.option.apnsSound = @"video_chat_tip_receiver.aac";
    self.option.videoCaptureParam.startWithCameraOn = (self.callType == NIMNetCallTypeVideo);
    
    __weak typeof(self) weakself = self;
    if (self.callType == NIMNetCallTypeAudio) {
        [self showHint:@"请用听筒接听"];
    }
    [[NIMAVChatSDK sharedSDK].netCallManager start:@[self.callee] type:self.callType option:self.option completion:^(NSError * _Nullable error, UInt64 callID) {
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DelaySelfStartControlTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself onControl:callID from:weakself.callee type:NIMNetCallControlTypeFeedabck];
            });
            [weakself playSenderRing];
            [weakself setCallID:callID];
        }
        else
        {
            [self showHint:@"连接失败"];
            [weakself closeCall];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)hangUpClick:(id)sender {
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callID];
    [self showHint:@"聊天已取消"];
    [self closeRing];
    [self closeCall];
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
}

- (void)inConnection
{
    [super inConnection];
}

- (void)connectionSuccess
{
    [super connectionSuccess];
    [self.promptLB setHidden:YES];
    [self changeUIStuats];
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
