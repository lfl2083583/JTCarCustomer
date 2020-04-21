//
//  JTTipContentConfig.m
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTipContentConfig.h"

@implementation JTTipContentConfig

- (CGSize)contentSize:(NIMMessage *)message
{
    CGSize textSize = [Utility getTextString:message.text textFont:Font(JTTipTextFont) frameWidth:(App_Frame_Width-40) attributedString:[self contenText:message]];
    return CGSizeMake(textSize.width+28, textSize.height+6);
}

- (NSMutableAttributedString *)contenText:(NIMMessage *)message
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message.text];
    [string addAttribute:NSFontAttributeName value:Font(JTTipTextFont) range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0, message.text.length)];
    [string addAttribute:NSBaselineOffsetAttributeName value:@(-3) range:NSMakeRange(0, message.text.length)];
    return string;
}

@end
