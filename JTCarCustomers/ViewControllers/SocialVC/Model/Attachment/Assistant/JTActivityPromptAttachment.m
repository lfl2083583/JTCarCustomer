//
//  JTActivityPromptAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityPromptAttachment.h"

@implementation JTActivityPromptAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeActivityPrompt ),
                           CMData : @{ CMActivityID : self.activityID?self.activityID : @"",
                                       CMActivityContent : self.content?self.content : @"",
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
    CGFloat contentWidth = JTBubbleMaxWidth-28;
    CGSize contentSize = [Utility getTextString:self.content textFont:Font(16) frameWidth:contentWidth attributedString:nil];
    return CGSizeMake(MAX(contentSize.width+28, [Utility getTextString:@"活动消息" textFont:Font(16) frameWidth:contentWidth attributedString:nil].width), contentSize.height+65);
}

@end