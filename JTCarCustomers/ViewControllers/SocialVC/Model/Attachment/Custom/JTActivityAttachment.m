//
//  JTActivityAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityAttachment.h"

@implementation JTActivityAttachment

- (instancetype)initWithActivityId:(NSString *)activityId
                          coverUrl:(NSString *)coverUrl
                             theme:(NSString *)theme
                              time:(NSString *)time
                           address:(NSString *)address
{
    self = [super init];
    if (self) {
        _activityId = activityId;
        _coverUrl = coverUrl;
        _theme = theme;
        _time = time;
        _address = address;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeActivity ),
                           CMData : @{ CMCustomActivityID : self.activityId?self.activityId : @"",
                                       CMCustomActivityCoverUrl : self.coverUrl?self.coverUrl : @"",
                                       CMCustomActivityTheme : self.theme?self.theme : @"",
                                       CMCustomActivityTime : self.time?self.time : @"",
                                       CMCustomActivityAddress : self.address?self.address : @"",
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

- (CGSize)contentSize:(NIMMessage *)message
{
    return CGSizeMake(JTBubbleMaxWidth, 130);
}

- (NSString *)contentBubbleImage:(NIMMessage *)message
{
    return message.isOutgoingMsg ? @"icon_sender_node_white_normal " : @"icon_receiver_node_normal";
}
@end
