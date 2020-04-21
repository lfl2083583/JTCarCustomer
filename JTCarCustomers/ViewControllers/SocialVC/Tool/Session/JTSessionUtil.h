//
//  JTSessionUtil.h
//  JTSocial
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const JTRecentSessionAtMark;
extern NSString *const JTRecentSessionDraftMark;
extern NSString *const JTRecentSessionDisableAttentionTipMark;
extern NSString *const JTRecentSessionAnnounceMark;

extern NSString *const JTDraftText;
extern NSString *const JTDraftItem;

@interface JTSessionUtil : NSObject

/**
 获取会话对象

 @param session 会话
 @return return value description
 */
+ (NIMRecentSession *)recentSession:(NIMSession *)session;

/**
 添加@标记

 @param session session description
 */
+ (void)addRecentSessionAtMark:(NIMSession *)session;

/**
 删除@标记

 @param session session description
 */
+ (void)removeRecentSessionAtMark:(NIMSession *)session;

/**
 判读是否有@标记

 @param recent recent description
 @return return value description
 */
+ (BOOL)recentSessionIsAtMark:(NIMRecentSession *)recent;

/**
 添加草稿标记

 @param session session description
 @param content content description
 */
+ (void)addRecentSessionDraftMark:(NIMSession *)session content:(id)content;

/**
 删除草稿标记

 @param session session description
 */
+ (void)removeRecentSessionDraftMark:(NIMSession *)session;

/**
 判断是否有草稿标记

 @param recent recent description
 @return return value description
 */
+ (id)recentSessionDraftMark:(NIMRecentSession *)recent;

/**
 添加关注提示标记

 @param session session description
 */
+ (void)addRecentSessionDisableAttentionTipMark:(NIMSession *)session;

/**
 禁用关注提示标记

 @param recent recent description
 @return return value description
 */
+ (BOOL)recentSessionIsDisableAttentionTipMark:(NIMRecentSession *)recent;

/**
 添加公告标记
 
 @param session session description
 */
+ (void)addRecentSessionAnnounceMark:(NIMSession *)session;

/**
 删除公告标记
 
 @param session session description
 */
+ (void)removeRecentSessionAnnounceMark:(NIMSession *)session;

/**
 判读是否有公告标记
 
 @param recent recent description
 @return return value description
 */
+ (BOOL)recentSessionIsAnnounceMark:(NIMRecentSession *)recent;

/**
 获取提示消息文案

 @param message message description
 @return return value description
 */
+ (NSString *)messageTipContent:(NIMMessage *)message;

/**
 是否可以撤回

 @param message message description
 @return return value description
 */
+ (BOOL)canMessageBeRevoked:(NIMMessage *)message;

/**
 撤回提示文案

 @param message message description
 @return return value description
 */
+ (NSString *)tipOnMessageRevoked:(id)message;
@end
