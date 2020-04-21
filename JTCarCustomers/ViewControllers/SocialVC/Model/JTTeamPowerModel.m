//
//  JTTeamPowerModel.m
//  JTCarCustomers
//
//  Created by apple on 2017/7/8.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTeamPowerModel.h"

@implementation JTTeamPowerModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)setTeam:(NIMTeam *)team
{
    _team = team;
    [self reset];
    if ([[NIMSDK sharedSDK].teamManager isMyTeam:self.team.teamId]) {
        self.isMyTeam = YES;
        self.myTeamMember = [[NIMSDK sharedSDK].teamManager teamMember:[JTUserInfo shareUserInfo].userYXAccount inTeam:self.team.teamId];
        __weak typeof(self) weakself = self;
        [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.team.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            for (NIMTeamMember *member in members) {
                if ([member.userId isEqualToString:[JTUserInfo shareUserInfo].userYXAccount]) {
                    weakself.myTeamMember = member;
                    break;
                };
            }
        }];
        self.ownerID = self.team.owner;
        self.isGroupMain = ([self.team.owner isEqualToString:[JTUserInfo shareUserInfo].userYXAccount])?YES:NO;
        self.isMuted = self.myTeamMember.isMuted;
        if (self.team.serverCustomInfo && ![self.team.serverCustomInfo isBlankString])
        {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[self.team.serverCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
            if (info && [info isKindOfClass:[NSDictionary class]]) {
                if ([info objectForKey:@"ban_chat"] && [info[@"ban_chat"] isKindOfClass:[NSArray class]]) {
                    [self.banPowerUserArray addObjectsFromArray:[info objectForKey:@"ban_chat"]];
                    [self setIsBanPower:[self.banPowerUserArray containsObject:[JTUserInfo shareUserInfo].userID]];
                }
                if ([info objectForKey:@"ban"] && [info[@"ban"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *source in info[@"ban"]) {
                        [self.bannedUserdict setObject:source[@"time"] forKey:source[@"uid"]];
                    }
                }
                if (self.isMuted && self.bannedUserdict.count && [self.bannedUserdict objectForKey:[JTUserInfo shareUserInfo].userID]) {
                    self.bannedTimeInterval = [[self.bannedUserdict objectForKey:[JTUserInfo shareUserInfo].userID] doubleValue] - [[NSDate date] timeIntervalSince1970] + [HttpRequestTool sharedInstance].timeInterval;
                }
                if ([info objectForKey:@"batch_follow"] && [info[@"batch_follow"] isKindOfClass:[NSArray class]]) {
                    [self.oneEnterAddPowerUserArray addObjectsFromArray:info[@"batch_follow"]];
                    [self setIsOneEnterAddPower:[self.oneEnterAddPowerUserArray containsObject:[JTUserInfo shareUserInfo].userID]];
                }
                if ([info objectForKey:@"remove_user"] && [info[@"remove_user"] isKindOfClass:[NSArray class]]) {
                    [self.removePowerUserArray addObjectsFromArray:info[@"remove_user"]];
                    [self setIsRemovePower:[self.removePowerUserArray containsObject:[JTUserInfo shareUserInfo].userID]];
                }
                if ([info objectForKey:@"invite_user"] && [info[@"invite_user"] isKindOfClass:[NSArray class]]) {
                    [self.invitePowerUserArray addObjectsFromArray:info[@"invite_user"]];
                    [self setIsInvitePower:[self.invitePowerUserArray containsObject:[JTUserInfo shareUserInfo].userID]];
                }
                self.joinTeamType = [[info objectForKey:@"invite"] integerValue];
                self.category = [[info objectForKey:@"category"] integerValue];
            }
        }
        if (self.myTeamMember.customInfo && ![self.myTeamMember.customInfo isBlankString])
        {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[self.myTeamMember.customInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
            if (info && [info isKindOfClass:[NSDictionary class]])
            {
                self.isShowGroupNickName = [[info objectForKey:@"isShowNickName"] boolValue];
                self.displayedAnnounceTime = [info objectForKey:@"announceTime"];
            }
        }
        if (self.team.announcement && !self.isGroupMain)
        {
            NSArray *array = [team.announcement componentsSeparatedByString:@"#"];
            if (array && [array isKindOfClass:[NSArray class]] && array.count == 2) {
                self.announceID = [NSString stringWithFormat:@"%@", array[0]];
                self.announceTime = [NSString stringWithFormat:@"%@", array[1]];
            }
        }
    }
}

- (void)reset
{
    [self setIsMyTeam:NO];
    [self setOwnerID:@""];
    [self setIsGroupMain:NO];
    [self setIsMuted:NO];
    [self.banPowerUserArray removeAllObjects];
    [self setIsBanPower:NO];
    [self.bannedUserdict removeAllObjects];
    [self setBannedTimeInterval:0];
    [self.oneEnterAddPowerUserArray removeAllObjects];
    [self setIsOneEnterAddPower:NO];
    [self.removePowerUserArray removeAllObjects];
    [self setIsRemovePower:NO];
    [self.invitePowerUserArray removeAllObjects];
    [self setIsInvitePower:NO];
    [self setJoinTeamType:2];
    [self setCategory:0];
    [self setIsShowGroupNickName:NO];
    [self setDisplayedAnnounceTime:@""];
    [self setAnnounceID:@""];
    [self setAnnounceTime:@""];
}

- (NSMutableArray *)banPowerUserArray
{
    if (!_banPowerUserArray) {
        _banPowerUserArray = [NSMutableArray array];
    }
    return _banPowerUserArray;
}

- (NSMutableDictionary *)bannedUserdict
{
    if (!_bannedUserdict) {
        _bannedUserdict = [NSMutableDictionary dictionary];
    }
    return _bannedUserdict;
}

- (NSMutableArray *)oneEnterAddPowerUserArray
{
    if (!_oneEnterAddPowerUserArray) {
        _oneEnterAddPowerUserArray = [NSMutableArray array];
    }
    return _oneEnterAddPowerUserArray;
}

- (NSMutableArray *)removePowerUserArray
{
    if (!_removePowerUserArray) {
        _removePowerUserArray = [NSMutableArray array];
    }
    return _removePowerUserArray;
}

- (NSMutableArray *)invitePowerUserArray
{
    if (!_invitePowerUserArray) {
        _invitePowerUserArray = [NSMutableArray array];
    }
    return _invitePowerUserArray;
}

@end
