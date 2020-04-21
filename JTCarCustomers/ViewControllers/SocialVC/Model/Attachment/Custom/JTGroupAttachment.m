//
//  JTGroupAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTGroupAttachment.h"

@implementation JTGroupAttachment

- (instancetype)initWithGroupId:(NSString *)groupId name:(NSString *)name icon:(NSString *)icon
{
    self = [super init];
    if (self) {
        _groupId = groupId;
        _name = name;
        _icon = icon;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeGroup ),
                           CMData : @{ CMCustomGroupID : self.groupId?self.groupId : @"",
                                       CMCustomGroupName : self.name?self.name : @"",
                                       CMCustomGroupIcon : self.icon?self.icon : @"",
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

- (CGSize)contentSize:(NIMMessage *)message {
    return CGSizeMake(200, 80);
}

- (NSString *)contentBubbleImage:(NIMMessage *)message
{
    return message.isOutgoingMsg ? @"icon_sender_node_white_normal " : @"icon_receiver_node_normal";
}

@end
