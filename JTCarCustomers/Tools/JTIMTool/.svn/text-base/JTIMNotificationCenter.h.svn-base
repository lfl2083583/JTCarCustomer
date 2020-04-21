//
//  JTIMNotificationCenter.h
//  JTDirectSeeding
//
//  Created by apple on 2017/4/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JTIMNotificationCenterDelegate <NSObject>

- (void)onHandleRecvMessages:(NSArray *)messages;

@end

@protocol JTIMBroadcastNotificationCenterDelegate <NSObject>

- (void)onHandleRecvBroadcastMessages:(NIMBroadcastMessage *)broadcastMessage;

@end

@interface JTIMNotificationCenter : NSObject <NIMChatManagerDelegate, NIMNetCallManagerDelegate, NIMBroadcastManagerDelegate>

@property (assign, nonatomic) BOOL isCallCenter; // 开启了手机电话

+ (instancetype)sharedCenter;
- (void)start;

/**
 *  添加聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)addDelegate:(id<JTIMNotificationCenterDelegate>)delegate;

/**
 *  移除聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)removeDelegate:(id<JTIMNotificationCenterDelegate>)delegate;

/**
 *  添加广播委托
 *
 *  @param delegate 广播委托
 */
- (void)addBroadcastDelegate:(id<JTIMBroadcastNotificationCenterDelegate>)delegate;

/**
 *  移除广播委托
 *
 *  @param delegate 广播委托
 */
- (void)removeBroadcastDelegate:(id<JTIMBroadcastNotificationCenterDelegate>)delegate;

@end
