//
//  JTTeamInviteAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamInviteAttachment.h"

@implementation JTTeamInviteAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamInvite ),
                           CMData : @{ CMTeamInviteId : self.inviteId?self.inviteId : @"",
                                       CMTeamInviteUserId : self.userId?self.userId : @"",
                                       CMTeamInviteYunXinId : self.yunxinID?self.yunxinID : @"",
                                       CMTeamInviteUserName : self.userName?self.userName : @"",
                                       CMTeamInviteUserAvatar : self.avatarUrlString?self.avatarUrlString : @"",
                                       CMTeamInviteTeamId : self.teamId?self.teamId : @"",
                                       CMTeamInviteTeamName : self.teamName?self.teamName : @"",
                                       CMTeamInviteJoinType : self.joinType?self.joinType : @"",
                                       CMTeamInviteTime : self.inviteTime?self.inviteTime : @"",
                                       CMTeamInviteOperationType : @(self.operationType)
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

- (NSString *)teamInviteText
{
    if (!_teamInviteText) {
        _teamInviteText = [NSString stringWithFormat:@"%@邀请你加入群组%@", self.userName, self.teamName];
    }
    return _teamInviteText;
}
@end
