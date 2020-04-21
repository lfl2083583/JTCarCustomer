//
//  JTCommentActivityAttachment.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCommentActivityAttachment.h"

@implementation JTCommentActivityAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeCommentActivity ),
                           CMData : @{ CMCommentActivityAvatarUrl : self.avatarUrl?self.avatarUrl : @"",
                                       CMCommentActivityName : self.name?self.name : @"",
                                       CMCommentActivityUserID : self.userID?self.userID : @"",
                                       CMCommentActivityContent : self.content?self.content : @"",
                                       CMCommentActivityTime : @(self.time),
                                       CMCommentActivityCoverUrl : self.coverUrl?self.coverUrl : @"",
                                       CMCommentActivityUrl : self.activityUrl?self.activityUrl : @"",
                                       CMCommentActivityID : self.activityID?self.activityID : @"",
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

@end
