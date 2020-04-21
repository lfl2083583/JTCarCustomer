//
//  JTCallBonusAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCallBonusAttachment.h"

@implementation JTCallBonusAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeCallBonus ),
                           CMData : @{ CMCallBonusFromId : self.fromId?self.fromId : @"",
                                       CMCallBonusFromName : self.fromName?self.fromName : @"",
                                       CMCallBonusId : self.bonusId?self.bonusId : @"",
                                       CMCallBonusToId : self.toId?self.toId : @"",
                                       CMCallBonusToName : self.toName?self.toName : @"",
                                       CMCallBonusSessionID : self.sessionID?self.sessionID : @"",
                                       CMCallBonusType : @(self.bonusType),
                                       CMCallBonusLastFlag : self.lastFlag?self.lastFlag : @""
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

- (NSString *)bonusText
{
    if (!_bonusText || _bonusText.length == 0) {
        _bonusText = [self.packetOperationInfo objectForKey:@"text"];
    }
    return _bonusText;
}

- (NSMutableAttributedString *)bonusAttributedString
{
    if (!_bonusAttributedString) {
        _bonusAttributedString = [self.packetOperationInfo objectForKey:@"attributed"];
    }
    return _bonusAttributedString;
}

- (NSMutableArray *)bonusLinks
{
    if (!_bonusLinks) {
        _bonusLinks = [self.packetOperationInfo objectForKey:@"links"];
    }
    return _bonusLinks;
}

- (NSDictionary *)packetOperationInfo
{
    if (!_packetOperationInfo) {
        NSString *text = @"";
        if ([self.fromId isEqualToString:[[JTUserInfo shareUserInfo] userID]]) {
            if ([self.toId isEqualToString:[[JTUserInfo shareUserInfo] userID]]) {
                text = [self.lastFlag boolValue] ? @"你领取了自己的 红包 你的红包已被领完" : @"你领取了自己的 红包";
            }
            else
            {
                text = [self.lastFlag boolValue] ? [NSString stringWithFormat:@"%@领取了你的 红包 你的红包已被领完", self.toName] : [NSString stringWithFormat:@"%@领取了你的 红包", self.toName];
            }
        }
        else if ([self.toId isEqualToString:[[JTUserInfo shareUserInfo] userID]])
        {
            text = [NSString stringWithFormat:@"你领取了%@的 红包", self.fromName];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableArray *links = [NSMutableArray array];
        [attributedString addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0, text.length)];
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(-1.5) range:NSMakeRange(0, text.length)];
        NSRange range = [text rangeOfString:@"红包"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        [links addObject:@{@"value": self.bonusId, @"range": [NSValue valueWithRange:range]}];
        _packetOperationInfo = @{@"text": text, @"attributed": attributedString, @"links": links};
    }
    return _packetOperationInfo;
}

- (CGSize)contentSize:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = [self contenText:message];
    CGSize textSize = [Utility getTextString:attributedString.string textFont:Font(JTTipTextFont) frameWidth:(App_Frame_Width-40) attributedString:attributedString];
    return CGSizeMake(textSize.width+28, textSize.height+6);
}

- (NSMutableAttributedString *)contenText:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = self.bonusAttributedString;
    [attributedString addAttribute:NSFontAttributeName value:Font(JTTipTextFont) range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (NSArray *)contentLinks:(NIMMessage *)message
{
    return self.bonusLinks;
}
@end
