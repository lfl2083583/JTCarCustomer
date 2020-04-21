//
//  JTTeamDismissAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamDismissAttachment.h"

@implementation JTTeamDismissAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamDismiss ),
                           CMData : @{ CMTeamDismissTeamId : self.teamId?self.teamId : @"",
                                       CMTeamDismissTeamName : self.teamName?self.teamName : @"",
                                       CMTeamDismissTeamAvatar : self.teamAvatar?self.teamAvatar : @"",
                                       CMTeamDismissUserId : self.userId?self.userId : @"",
                                       CMTeamDismissYunXinId : self.yunxinID?self.yunxinID : @"",
                                       CMTeamDismissUserName : self.userName?self.userName : @"",
                                       CMTeamDismissTime : self.dismissTime?self.dismissTime : @""
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

- (NSString *)teamDismissText
{
    if (!_teamDismissText) {
        _teamDismissText = [NSString stringWithFormat:@"群聊已解散"];
    }
    return _teamDismissText;
}

@end
