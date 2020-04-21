//
//  JTUserInfoHandle.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/14.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTUserContactType)
{
    /** 陌生人 **/
    JTUserContactTypeStranger = 0,
    /** 我关注了他（关注的人） **/
    JTUserContactTypeFocus,
    /** 他关注了我 （粉丝）**/
    JTUserContactTypeFans,
    /** 相互关注（好友） **/
    JTUserContactTypeFriends
};

typedef NS_ENUM(NSInteger, JTAppUserType)
{
    /** 普通用户 **/
    JTAppUserTypeNotmal = 1,
    /** 达人用户 **/
    JTAppUserTypeTalent = 2,
};


@interface JTUserInfoHandle : NSObject


/**
 显示App用户类型

 @param user 用户
 @return App用户类型
 */
+ (JTAppUserType)showAppUserType:(NIMUser *)user;

/**
 获取用户信息拓展内容
 
 @param user 用户
 @return 用户信息拓展内容
 */
+ (NSDictionary *)showUserExtWithUser:(NIMUser *)user;


/**
 显示用户名称
 
 @param sessionID 云信ID
 @return 用户名称
 */
+ (NSString *)showNick:(NSString *)sessionID;

/**
 显示用户名称
 
 @param sessionID 云信ID
 @param session 会话类型，不传为单聊
 @return 用户名称
 */
+ (NSString *)showNick:(NSString *)sessionID inSession:(NIMSession *)session;

/**
 显示用户名称
 
 @param user 用户
 @param member 群成员
 @return 用户名称
 */
+ (NSString *)showNick:(NIMUser *)user member:(NIMTeamMember *)member;


/**
 显示联系人类型

 @param user 用户
 @return 联系人类型
 */
+ (JTUserContactType)showUserContactType:(NIMUser *)user;


/**
 显示关注用户的时间

 @param user 用户
 @return 关注用户的时间
 */
+ (NSInteger)showFocusTime:(NIMUser *)user;


/**
 显示用户uid（非云信uid）

 @param user 用户
 @return 用户uid
 */
+ (NSString *)showUserId:(NIMUser *)user;
@end
