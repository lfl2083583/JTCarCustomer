//
//  JTIdentityAuthAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTIdentityAuthAttachment.h"

@implementation JTIdentityAuthAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeIdentityAuth ),
                           CMData : @{ CMIdentityAuthStatus : @(self.status),
                                       CMIdentityAuthContent : self.content?self.content : @"",
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
    NSString *title = (self.status == 1) ? @"实名认证成功" : @"实名认证失败";
    CGFloat titleWidth = [Utility getTextString:title textFont:Font(16) frameWidth:contentWidth attributedString:nil].width;
    return CGSizeMake(MAX(contentSize.width+28, titleWidth), contentSize.height+(self.status?30:65));
}

@end
