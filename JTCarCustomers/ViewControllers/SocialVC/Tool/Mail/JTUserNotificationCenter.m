//
//  JTUserNotificationCenter.m
//  JTSocial
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTUserNotificationCenter.h"

@implementation JTUserNotificationCenter

+ (instancetype)sharedCenter
{
    static JTUserNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTUserNotificationCenter alloc] init];
    });
    return instance;
}

- (void)start
{
    NSLog(@"Notification Center Setup");
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [[NIMSDK sharedSDK].userManager addDelegate:self];
        [[NIMSDK sharedSDK].teamManager addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
}

//将个人信息和群组信息变化通知给 NIMKit 。
//如果您的应用不托管个人信息给云信，则需要您自行在上层监听个人信息变动，并将变动通知给 NIMKit。
#pragma mark - NIMUserManagerDelegate
- (void)onFriendChanged:(NIMUser *)user
{
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[user.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTUserInfoUpdatedNotification object:user];
    }];
}

- (void)onBlackListChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTUserInfoUpdatedNotification object:nil];
}

- (void)onUserInfoChanged:(NIMUser *)user
{
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[user.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTUserInfoUpdatedNotification object:user];
    }];
}

#pragma mark - NIMTeamManagerDelegate
- (void)onTeamAdded:(NIMTeam *)team
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTTeamInfoUpdatedNotification object:team];
}

- (void)onTeamUpdated:(NIMTeam *)team
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTTeamInfoUpdatedNotification object:team];
}

- (void)onTeamRemoved:(NIMTeam *)team
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTTeamInfoUpdatedNotification object:team];
}

- (void)onTeamMemberChanged:(NIMTeam *)team
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTTeamMembersUpdatedNotification object:team];
}
@end
