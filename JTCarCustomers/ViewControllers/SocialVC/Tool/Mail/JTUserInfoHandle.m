//
//  JTUserInfoHandle.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/14.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "NSDictionary+Json.h"
#import "JTUserInfoHandle.h"

@implementation JTUserInfoHandle

+ (JTAppUserType)showAppUserType:(NIMUser *)user
{
    JTAppUserType userType = JTAppUserTypeNotmal;
    if (user) {
        if (user.userInfo.ext && [user.userInfo.ext isKindOfClass:[NSString class]])  {
            NSDictionary *ext = [NSJSONSerialization JSONObjectWithData:[user.userInfo.ext dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([ext objectForKey:@"user_type"]) {
                return [[ext objectForKey:@"user_type"] integerValue];
            }
        }
    }
    return userType;
}

+ (NSDictionary *)showUserExtWithUser:(NIMUser *)user {
    if (user) {
        NIMUserInfo *userInfo = [user userInfo];
        if (userInfo.ext && [userInfo.ext isKindOfClass:[NSDictionary class]])  {
            NSDictionary *ext = [NSJSONSerialization JSONObjectWithData:[userInfo.ext dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([ext objectForKey:@"user"]) {
                return ext[@"user"];
            }
        }
    }
    return nil;
}

+ (NSString *)showNick:(NSString *)sessionID {
    return [JTUserInfoHandle showNick:sessionID inSession:[NIMSession session:sessionID type:NIMSessionTypeP2P]];
}

+ (NSString *)showNick:(NSString *)sessionID inSession:(NIMSession *)session
{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:sessionID];
    NIMTeamMember *member;
    if (session.sessionType == NIMSessionTypeTeam) {
        member = [[NIMSDK sharedSDK].teamManager teamMember:sessionID
                                                     inTeam:session.sessionId];
    }
    return [JTUserInfoHandle showNick:user member:member];
}

+ (NSString *)showNick:(NIMUser *)user member:(NIMTeamMember *)member {
    NSString *name = nil;
    do{
        if ([user.alias length] && ![user.alias isEqualToString:@"null"] && ![user.alias isEqual:[NSNull null]])
        {
            name = user.alias;
            break;
        }
        if (member && [member.nickname length] && ![member.nickname isEqualToString:@"null"] && ![member.nickname isEqual:[NSNull null]])
        {
            name = member.nickname;
            break;
        }
        if ([user.userInfo.nickName length])
        {
            name = user.userInfo.nickName;
            break;
        }
    } while (0);
    return name;
}

+ (JTUserContactType)showUserContactType:(NIMUser *)user {
    JTUserContactType userContactType = JTUserContactTypeStranger;
    if (user) {
        if (user.ext && [user.ext isKindOfClass:[NSString class]])  {
            NSDictionary *ext = [NSJSONSerialization JSONObjectWithData:[user.ext dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([ext objectForKey:@"follow"]) {
                return [ext[@"follow"] integerValue];
            }
        }
    }
    return userContactType;
}

+ (NSInteger)showFocusTime:(NIMUser *)user {
    NSInteger focusTime = 0;
    if (user) {
        if (user.ext && [user.ext isKindOfClass:[NSString class]])  {
            NSDictionary *ext = [NSJSONSerialization JSONObjectWithData:[user.ext dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([ext objectForKey:@"time"]) {
                return [ext[@"time"] integerValue];
            }
        }
    }
    return focusTime;
}

+ (NSString *)showUserId:(NIMUser *)user {
    NSString *userID = @"";
    if (user) {
        if (user.userInfo.ext && [user.userInfo.ext isKindOfClass:[NSString class]])  {
            NSDictionary *ext = [NSJSONSerialization JSONObjectWithData:[user.userInfo.ext dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([ext objectForKey:@"uid"]) {
                return [NSString stringWithFormat:@"%@", [ext objectForKey:@"uid"]];
            }
        }
    }
    return userID;
}
@end
