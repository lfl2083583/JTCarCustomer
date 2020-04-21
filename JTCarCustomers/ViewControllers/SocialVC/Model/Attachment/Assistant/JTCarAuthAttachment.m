//
//  JTCarAuthAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarAuthAttachment.h"

@implementation JTCarAuthAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeCarAuth ),
                           CMData : @{ CMCarAuthStatus : @(self.status),
                                       CMCarAuthContent : self.content?self.content : @"",
                                       CMCarAuthID : self.carID?self.carID : @"",
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
    NSString *title = (self.status == 1) ? @"车辆认证成功" : @"车辆认证失败";
    CGFloat titleWidth = [Utility getTextString:title textFont:Font(16) frameWidth:contentWidth attributedString:nil].width;
    return CGSizeMake(MAX(contentSize.width+28, titleWidth), contentSize.height+(self.status?30:65));
}

@end
