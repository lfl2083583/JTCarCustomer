//
//  JTTeamRemoveAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamRemoveAttachment.h"

@implementation JTTeamRemoveAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamRemove ),
                           CMData : @{ CMTeamRemoveTeamId : self.teamId?self.teamId : @"",
                                       CMTeamRemoveTeamName : self.teamName?self.teamName : @"",
                                       CMTeamRemoveTeamAvatar : self.teamAvatar?self.teamAvatar : @"",
                                       CMTeamRemoveUserId : self.userId?self.userId : @"",
                                       CMTeamRemoveYunXinId : self.yunxinID?self.yunxinID : @"",
                                       CMTeamRemoveUserName : self.userName?self.userName : @"",
                                       CMTeamRemoveTime : self.removeTime?self.removeTime : @"",
                                       CMTeamRemoveOperationType : @(self.operationType)
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

- (NSString *)teamRemoveText
{
    if (!_teamRemoveText) {
        _teamRemoveText = [NSString stringWithFormat:@"已将你移出群"];
    }
    return _teamRemoveText;
}

@end
