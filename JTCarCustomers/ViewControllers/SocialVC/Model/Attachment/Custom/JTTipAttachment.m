//
//  JTTipAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTipAttachment.h"

@implementation JTTipAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTip ),
                           CMData : @{ CMTipText : self.text?self.text : @""
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
    CGSize textSize = [Utility getTextString:self.text textFont:Font(JTTipTextFont) frameWidth:(App_Frame_Width-40) attributedString:nil];
    return CGSizeMake(textSize.width+28, textSize.height+6);
}

- (NSMutableAttributedString *)contenText:(NIMMessage *)message
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.text];
    [string addAttribute:NSFontAttributeName value:Font(JTTipTextFont) range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0, message.text.length)];
    [string addAttribute:NSBaselineOffsetAttributeName value:@(-3) range:NSMakeRange(0, message.text.length)];
    return string;
}

@end
