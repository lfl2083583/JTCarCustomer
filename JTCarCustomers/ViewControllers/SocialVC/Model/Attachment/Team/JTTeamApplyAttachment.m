//
//  JTTeamApplyAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamApplyAttachment.h"

@implementation JTTeamApplyAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamApply ),
                           CMData : @{ CMTeamApplyInviteId : self.inviteId?self.inviteId : @"",
                                       CMTeamApplyUserId : self.userId?self.userId : @"",
                                       CMTeamApplyYunXinId : self.yunxinID?self.yunxinID : @"",
                                       CMTeamApplyUserName : self.userName?self.userName : @"",
                                       CMTeamApplyUserAvatar : self.avatarUrlString?self.avatarUrlString : @"",
                                       CMTeamApplyTeamId : self.teamId?self.teamId : @"",
                                       CMTeamApplyTeamName : self.teamName?self.teamName : @"",
                                       CMTeamApplyRemarks : self.remarks?self.remarks : @"",
                                       CMTeamApplyJoinType : self.joinType?self.joinType : @"",
                                       CMTeamInviteTime : self.applyTime?self.applyTime : @"",
                                       CMTeamApplyOperationType : @(self.operationType)
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

- (NSString *)teamApplyText
{
    if (!_teamApplyText) {
        _teamApplyText = [NSString stringWithFormat:@"%@申请加入群组%@", self.userName, self.teamName];
    }
    return _teamApplyText;
}

@end
