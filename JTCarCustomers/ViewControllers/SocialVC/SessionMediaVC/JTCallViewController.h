//
//  JTCallViewController.h
//  JTSocial
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESGLView.h"

//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声
#define DelaySelfStartControlTime 10
//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声
#define NoBodyPromptTimeOut 30
//激活铃声后无人接听的超时时间
#define NoBodyResponseTimeOut 45

@interface JTCallViewController : UIViewController
{
    BOOL isConnectionSuccess;
    NSTimer *_timer;
    NSInteger runCount;
}

@property (assign, nonatomic) NIMNetCallMediaType callType;  // 通话类型
@property (assign, nonatomic) BOOL isIssue;           // 是否拨打方
@property (copy, nonatomic) NSString *caller;         // 主叫账号
@property (copy, nonatomic) NSString *callee;         // 呼叫账号
@property (assign, nonatomic) UInt64 callID;          // 通话ID
@property (strong, nonatomic) NIMUserInfo *userinfo;  // 用户本地信息
@property (strong, nonatomic) NIMNetCallOption *option; 
@property (strong, nonatomic) NIMNetCallVideoCaptureParam *param;

@property (strong, nonatomic) UIImageView *bottom;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *bigVideoPreView;   // 大视频层
@property (strong, nonatomic) UIView *smallVideoPreView; // 小视频层
@property (weak, nonatomic) UIView *localPreView;        // 本地视频
@property (strong, nonatomic) NTESGLView *remotePreView; // 远程视频

- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control;
/**
 是否接通通话

 @param accept YES为接通
 */
- (void)responseCall:(BOOL)accept;

/**
 关闭页面
 */
- (void)closeCall;

// 等待连接
- (void)waitForConnection;
// 连接中
- (void)inConnection;
// 连接成功
- (void)connectionSuccess;
// 切换音频UI
- (void)switchToAudioUI;
// 显示视频UI
- (void)showVideoUI;
// 隐藏视频UI
- (void)hideVideoUI;
// 输出设备改变
- (void)changeHeadsetPluggedIn:(BOOL)pluggedIn;
// 更新时间
- (void)updateTimeLB:(NSString *)time;
// 提示
- (void)showHint:(NSString *)hint;

#pragma mark - Ring
// 铃声 - 正在呼叫请稍后
- (void)playConnnetRing;
// 铃声 - 对方暂时无法接听
- (void)playHangUpRing;
// 铃声 - 对方正在通话中
- (void)playOnCallRing;
// 铃声 - 对方无人接听
- (void)playTimeOutRing;
// 铃声 - 接收方铃声
- (void)playReceiverRing;
// 铃声 - 拨打方铃声
- (void)playSenderRing;
// 铃声 - 关闭铃声
- (void)closeRing;
@end
