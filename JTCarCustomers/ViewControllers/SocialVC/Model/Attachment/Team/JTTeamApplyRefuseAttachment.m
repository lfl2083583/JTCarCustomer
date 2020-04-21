//
//  JTTeamApplyRefuseAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamApplyRefuseAttachment.h"

@implementation JTTeamApplyRefuseAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamApplyRefuse ),
                           CMData : @{ CMTeamApplyRefuseTeamId : self.teamId?self.teamId : @"",
                                       CMTeamApplyRefuseTeamName : self.teamName?self.teamName : @"",
                                       CMTeamApplyRefuseTeamAvatar : self.teamAvatar?self.teamAvatar : @"",
                                       CMTeamApplyRefuseUserId : self.userId?self.userId : @"",
                                       CMTeamApplyRefuseYunXinId : self.yunxinID?self.yunxinID : @"",
                                       CMTeamApplyRefuseUserName : self.userName?self.userName : @"",
                                       CMTeamApplyRefuseTime : self.applyRefuseTime?self.applyRefuseTime : @"",
                                       CMTeamApplyRefuseInviteId : self.inviteId?self.inviteId : @"",
                                       CMTeamApplyRefuseJoinType : self.joinType?self.joinType : @"",
                                       CMTeamApplyRefuseOperationType : @(self.operationType)
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

- (NSString *)teamApplyRefuseText
{
    if (!_teamApplyRefuseText) {
        _teamApplyRefuseText = [NSString stringWithFormat:@"拒绝让你加群"];
    }
    return _teamApplyRefuseText;
}

@end
