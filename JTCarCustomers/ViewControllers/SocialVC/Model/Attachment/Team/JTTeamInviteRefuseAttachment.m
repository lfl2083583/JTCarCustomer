//
//  JTTeamInviteRefuseAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamInviteRefuseAttachment.h"

@implementation JTTeamInviteRefuseAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamInviteRefuse ),
                           CMData : @{ CMTeamInviteRefuseInviteId : self.inviteId?self.inviteId : @"",
                                       CMTeamInviteRefuseUserId : self.userId?self.userId : @"",
                                       CMTeamInviteRefuseYunXinId : self.yunxinID?self.yunxinID : @"",
                                       CMTeamInviteRefuseUserName : self.userName?self.userName : @"",
                                       CMTeamInviteRefuseUserAvatar : self.avatarUrlString?self.avatarUrlString : @"",
                                       CMTeamInviteRefuseTeamId : self.teamId?self.teamId : @"",
                                       CMTeamInviteRefuseTeamName : self.teamName?self.teamName : @"",
                                       CMTeamInviteRefuseTime : self.inviteRefuseTime?self.inviteRefuseTime : @"",
                                       CMTeamInviteRefuseOperationType : @(self.operationType)
                                       }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

- (NSString *)teamInviteRefuseText
{
    if (!_teamInviteRefuseText) {
        _teamInviteRefuseText = [NSString stringWithFormat:@"%@拒绝加入你的群组%@", self.userName, self.teamName];
    }
    return _teamInviteRefuseText;
}

@end
