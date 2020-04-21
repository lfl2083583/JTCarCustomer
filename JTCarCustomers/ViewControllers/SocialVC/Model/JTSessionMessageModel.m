//
//  JTSessionMessageModel.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionMessageModel.h"
#import "JTSessionContentConfig.h"

@implementation JTSessionMessageModel

- (instancetype)initWithMessage:(NIMMessage *)message
{
    if (self = [self init])
    {
        self.message = message;
    }
    return self;
}

- (void)setMessage:(NIMMessage *)message
{
    _message = message;
    id <JTSessionContentConfig> config;
    if (message.messageType == NIMMessageTypeCustom)
    {
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        config = (id)object.attachment;
    }
    else
    {
        config = [[JTSessionContentConfig shareSessionContentConfig] configBy:message];
    }
    if ([config respondsToSelector:@selector(contentSize:)]) {
        self.contentSize = [config contentSize:message];
    }
    if ([config respondsToSelector:@selector(contenText:)]) {
        self.string = [config contenText:message];
    }
    if ([config respondsToSelector:@selector(contentLinks:)]) {
        self.links = [config contentLinks:message];
    }
    if ([config respondsToSelector:@selector(contentBubbleImage:)]) {
        self.bubbleImage = [config contentBubbleImage:message];
    }
}

@end
