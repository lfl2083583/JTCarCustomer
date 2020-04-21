//
//  JTPushNotificationProcessingCenter.h
//  JTSocial
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTPushNotificationProcessingCenter : NSObject

+ (instancetype)sharedCenter;


/**
 处理接收的推送消息

 @param messages 推送消息
 @param isClick 是否点击通知中心触发
 */
- (void)receiveMessages:(NSDictionary *)messages isClick:(BOOL)isClick;

@end
