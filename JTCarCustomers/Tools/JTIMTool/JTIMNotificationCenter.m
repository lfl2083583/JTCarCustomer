//
//  JTIMNotificationCenter.m
//  JTDirectSeeding
//
//  Created by apple on 2017/4/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTIMNotificationCenter.h"
#import <objc/runtime.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "JTSessionViewController.h"
#import "JTMessageFunsViewController.h"
#import "JTMessageMoneyViewController.h"
#import "JTMessageTeamViewController.h"
#import "JTMessageAssistantViewController.h"
#import "JTCallOnViewController.h"

#import "JTCallBonusAttachment.h"
#import "JTFunsAttachment.h"

#import <AVFoundation/AVFoundation.h>
#import "JTMessageMaker.h"

NSString *const kMultiIMDelegateKey = @"multiIMDatagateKey";
NSString *const kMultiIMBroadcastDelegateKey = @"multiIMBroadcastDatagateKey";

static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface JTIMNotificationCenter ()

@property (nonatomic, strong) NSDate *lastPlaySoundDate;
@property (nonatomic, strong) CTCallCenter *center;

@end

@implementation JTIMNotificationCenter

void MessageSoundFinishedPlayingCallback(SystemSoundID sound_id, void* user_data)
{
    AudioServicesDisposeSystemSoundID(sound_id);
}

+ (instancetype)sharedCenter
{
    static JTIMNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTIMNotificationCenter alloc] init];
    });
    return instance;
}

- (void)start
{
    NSLog(@"Notification Center Setup");
}

- (void)addDelegate:(id<JTIMNotificationCenterDelegate>)delegate
{
    NSPointerArray *delegateArray = objc_getAssociatedObject(self, (__bridge const void *)(kMultiIMDelegateKey));
    if (!delegateArray) {
        delegateArray = [NSPointerArray weakObjectsPointerArray];
        objc_setAssociatedObject(self, (__bridge const void *)(kMultiIMDelegateKey), delegateArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [delegateArray addPointer:(__bridge void *)delegate];
}

- (void)removeDelegate:(id<JTIMNotificationCenterDelegate>)delegate
{
    NSPointerArray *delegateArray = objc_getAssociatedObject(self, (__bridge const void *)(kMultiIMDelegateKey));
    if (delegateArray && delegateArray.count > 0) {
        [delegateArray addPointer:NULL];
        [delegateArray compact];
    }
}

- (void)addBroadcastDelegate:(id<JTIMBroadcastNotificationCenterDelegate>)delegate
{
    NSPointerArray *delegateArray = objc_getAssociatedObject(self, (__bridge const void *)(kMultiIMBroadcastDelegateKey));
    if (!delegateArray) {
        delegateArray = [NSPointerArray weakObjectsPointerArray];
        objc_setAssociatedObject(self, (__bridge const void *)(kMultiIMBroadcastDelegateKey), delegateArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [delegateArray addPointer:(__bridge void *)delegate];
}

- (void)removeBroadcastDelegate:(id<JTIMBroadcastNotificationCenterDelegate>)delegate
{
    NSPointerArray *delegateArray = objc_getAssociatedObject(self, (__bridge const void *)(kMultiIMBroadcastDelegateKey));
    if (delegateArray && delegateArray.count > 0) {
        [delegateArray addPointer:NULL];
        [delegateArray compact];
    }
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
        [[NIMSDK sharedSDK].broadcastManager addDelegate:self];
        
        __weak typeof(self) weakself = self;
        _center = [[CTCallCenter alloc] init];
        _center.callEventHandler = ^(CTCall *call) {
            /*
             电话通了Call has just been connected
             来电话了Call is incoming
             正在播出电话call is dialing
             */
            if ([call.callState isEqualToString:CTCallStateConnected] || [call.callState isEqualToString:CTCallStateIncoming] || [call.callState isEqualToString:CTCallStateDialing])
            {
                weakself.isCallCenter = YES;
            }
            /*
             挂断了电话咯Call has been disconnected
             嘛都没做Nothing is done
             */
            else
            {
                weakself.isCallCenter = NO;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kCallStateChangeNotification object:@(weakself.isCallCenter)];
        };
    }
    return self;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
    [[NIMSDK sharedSDK].broadcastManager removeDelegate:self];
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray *)messages
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:messages];
    NIMMessage *lastMessage = (NIMMessage *)[messages lastObject];
    /*
     对自定义消息进行解析
     */
    if (lastMessage.messageType == NIMMessageTypeCustom) {
        if ([lastMessage.session.sessionId isEqualToString:kJTCallBonusID]) {
            NIMCustomObject *object = (NIMCustomObject *)lastMessage.messageObject;
            if ([object.attachment isKindOfClass:[JTCallBonusAttachment class]]) {
                for (NIMMessage *message in messages) {
                    NIMCustomObject *currentObject = (NIMCustomObject *)message.messageObject;
                    NIMSessionType sessionType = ([(JTCallBonusAttachment *)currentObject.attachment bonusType] == 1) ? NIMSessionTypeP2P : NIMSessionTypeTeam;
                    NIMSession *session = [NIMSession session:[(JTCallBonusAttachment *)currentObject.attachment sessionID] type:sessionType];
                    [[NIMSDK sharedSDK].conversationManager saveMessage:message
                                                             forSession:session
                                                             completion:nil];
                    [array removeObject:message];
                }
            }
        }
        else if ([lastMessage.session.sessionId isEqualToString:kJTNormalID]) {
            NIMCustomObject *object = (NIMCustomObject *)lastMessage.messageObject;
            if ([object.attachment isKindOfClass:[JTFunsAttachment class]]) {
                for (NIMMessage *message in messages) {
                    NIMCustomObject *currentObject = (NIMCustomObject *)message.messageObject;
                    NIMSession *session = [NIMSession session:[(JTFunsAttachment *)currentObject.attachment yunxinId] type:NIMSessionTypeP2P];
                    NIMMessage *currentMessage = [JTMessageMaker messageWithFuns:@"null" yunxinId:[(JTFunsAttachment *)currentObject.attachment yunxinId] type:0 time:@"null"];
                    currentMessage.from = [(JTFunsAttachment *)currentObject.attachment yunxinId];
                    [[NIMSDK sharedSDK].conversationManager saveMessage:currentMessage
                                                             forSession:session
                                                             completion:nil];
                }
            }
        }
    }
    if (array.count > 0) {
        [self handleMessageAt:array];
    }
}

- (void)onRecvRevokeMessageNotification:(NIMRevokeMessageNotification *)notification
{
    NIMMessage *tipMessage = [JTMessageMaker messageWithTip:[JTSessionUtil tipOnMessageRevoked:notification]];
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.shouldBeCounted = NO;
    tipMessage.setting = setting;
    tipMessage.timestamp = notification.timestamp;
    NSMutableArray *delegateArray = objc_getAssociatedObject(self, (__bridge const void *)(kMultiIMDelegateKey));
    if (delegateArray && delegateArray.count > 0) {
        for (id<JTIMNotificationCenterDelegate> aDelegate in delegateArray) {
            if ([aDelegate isKindOfClass:[JTSessionViewController class]]) {
                if ([[(JTSessionViewController *)aDelegate session] isEqual:notification.session]) {
                    [[(JTSessionViewController *)aDelegate sessionConfigurator] deleteMessage:notification.message];
                }
            }
        }
    }
    [[NIMSDK sharedSDK].conversationManager saveMessage:tipMessage
                                             forSession:notification.session
                                             completion:nil];
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallMediaType)type message:(NSString *)extendMessage {
    
    if ([JTUserInfo shareUserInfo].isLogin) {
        if (self.isCallCenter || [JTSocialStautsUtil sharedCenter].liveStatus == JTLiveStatusLiving || [JTSocialStautsUtil sharedCenter].netCallStatus == JTNetCallStatusConnect) {
            [[NIMAVChatSDK sharedSDK].netCallManager control:callID type:NIMNetCallControlTypeBusyLine];
        }
        else
        {
            JTCallOnViewController *callOnVC = [[JTCallOnViewController alloc] initWithNetCallMediaType:type caller:caller callId:callID];
            [[Utility currentViewController] presentViewController:callOnVC animated:YES completion:nil];
        }
    }
}

#pragma mark - NIMBroadcastManagerDelegate
- (void)onReceiveBroadcastMessage:(NIMBroadcastMessage *)broadcastMessage
{
//    NSMutableArray *broadcastDelegateArray = objc_getAssociatedObject(self, (__bridge const void *)(kMultiIMBroadcastDelegateKey));
//    if (broadcastDelegateArray && broadcastDelegateArray.count > 0) {
//        for (id<JTIMBroadcastNotificationCenterDelegate> aBroadcastDelegate in broadcastDelegateArray) {
//            if ([aBroadcastDelegate respondsToSelector:@selector(onHandleRecvBroadcastMessages:)]) {
//                [aBroadcastDelegate onHandleRecvBroadcastMessages:broadcastMessage];
//            }
//        }
//    }
}

- (void)handleMessageAt:(NSArray *)messages
{
    BOOL isMark = NO;
    NSMutableArray *delegateArray = objc_getAssociatedObject(self, (__bridge const void *)(kMultiIMDelegateKey));
    NIMSession *session = [(NIMMessage *)messages.lastObject session];
    if (delegateArray && delegateArray.count > 0) {
        for (id<JTIMNotificationCenterDelegate> aDelegate in delegateArray) {
            BOOL isSender = NO;
            if ([aDelegate isKindOfClass:[JTSessionViewController class]]) {
                if ([[(JTSessionViewController *)aDelegate session] isEqual:session]) {
                    isSender = YES;
                }
            }
            else if ([aDelegate isKindOfClass:[JTMessageAssistantViewController class]])
            {
                if ([[(JTMessageAssistantViewController *)aDelegate session] isEqual:session]) {
                    isSender = YES;
                }
            }
            else if ([aDelegate isKindOfClass:[JTMessageMoneyViewController class]])
            {
                if ([[(JTMessageMoneyViewController *)aDelegate session] isEqual:session]) {
                    isSender = YES;
                }
            }
            else if ([aDelegate isKindOfClass:[JTMessageFunsViewController class]])
            {
                if ([[(JTMessageFunsViewController *)aDelegate session] isEqual:session]) {
                    isSender = YES;
                }
            }
            else if ([aDelegate isKindOfClass:[JTMessageTeamViewController class]])
            {
                if ([[(JTMessageTeamViewController *)aDelegate session] isEqual:session]) {
                    isSender = YES;
                }
            }
            if (isSender) {
                isMark = YES;
                if ([aDelegate respondsToSelector:@selector(onHandleRecvMessages:)]) {
                    [aDelegate onHandleRecvMessages:messages];
                }
            }
        }
    }
    if (!isMark) {
        if ([self isThanSoundInterval] && [self isNoDisturb:messages]) {
            [self playMessageAudioTip];
            [self playMessageShockTip];
        }
        for (NIMMessage *message in messages) {
            if ([message.apnsMemberOption.userIds containsObject:[[NIMSDK sharedSDK].loginManager currentAccount]] || [message.text isEqualToString:@"所有人"]) {
                [JTSessionUtil addRecentSessionAtMark:session];
                return;
            }
            if (message.messageType == NIMMessageTypeNotification) {
                NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
                if (object.notificationType == NIMNotificationTypeTeam) {
                    NIMTeamNotificationContent *content = (NIMTeamNotificationContent *)object.content;
                    if (content.operationType == NIMTeamOperationTypeUpdate) {
                        id attachment = [content attachment];
                        if ([attachment isKindOfClass:[NIMUpdateTeamInfoAttachment class]]) {
                            NIMUpdateTeamInfoAttachment *teamAttachment = (NIMUpdateTeamInfoAttachment *)attachment;
                            if ([teamAttachment.values count] == 1) {
                                NIMTeamUpdateTag tag = [[[teamAttachment.values allKeys] firstObject] integerValue];
                                if (tag == NIMTeamUpdateTagAnouncement) {
                                    [JTSessionUtil addRecentSessionAnnounceMark:session];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

- (BOOL)isThanSoundInterval
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (self.lastPlaySoundDate && timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return NO;
    }
    // 保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    return YES;
}

- (BOOL)isNoDisturb:(NSArray *)messages
{
    NIMSession *session = [(NIMMessage *)messages.lastObject session];
    BOOL isNoDisturb = NO;
    
    if (session.sessionType == NIMSessionTypeP2P) {
        isNoDisturb = [[NIMSDK sharedSDK].userManager notifyForNewMsg:session.sessionId];
    }
    else if (session.sessionType == NIMSessionTypeTeam) {
        isNoDisturb =  ([[NIMSDK sharedSDK].teamManager notifyStateForNewMsg:session.sessionId] == NIMTeamNotifyStateAll);
    }
    return isNoDisturb;
}

- (void)playMessageAudioTip
{
    if (![JTUserInfo shareUserInfo].isCloseAudio)
    {
        NSURL *audioPath = [[NSBundle mainBundle] URLForResource:@"message" withExtension:@"wav"];

        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioPath), &soundID);
        AudioServicesAddSystemSoundCompletion(soundID,
                                              NULL, // uses the main run loop
                                              NULL, // uses kCFRunLoopDefaultMode
                                              MessageSoundFinishedPlayingCallback, // the name of our custom callback function
                                              NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                              );

        AudioServicesPlaySystemSound(soundID);
    }
}

- (void)playMessageShockTip
{
    if (![JTUserInfo shareUserInfo].isCloseShock)
    {
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate,
                                              NULL, // uses the main run loop
                                              NULL, // uses kCFRunLoopDefaultMode
                                              MessageSoundFinishedPlayingCallback, // the name of our custom callback function
                                              NULL
                                              );

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

@end
