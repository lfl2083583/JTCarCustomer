//
//  JTSessionLayoutConfig.h
//  JTSocial
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTSessionLayoutConfig : NSObject


+ (instancetype)shareJTSessionLayoutConfig;

- (void)clean;

/**
 是否显示群昵称

 @param sessionID 会话ID
 @return return value description
 */
- (BOOL)isShowTeamNickName:(NSString *)sessionID;


/**
 是否隐藏气泡

 @param message 消息体
 @return return value description
 */
- (BOOL)isHideBubbleImage:(NIMMessage *)message;
@end
