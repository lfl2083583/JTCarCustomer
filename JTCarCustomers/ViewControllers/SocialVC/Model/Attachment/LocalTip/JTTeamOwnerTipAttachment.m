//
//  JTTeamOwnerTipAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamOwnerTipAttachment.h"

@implementation JTTeamOwnerTipAttachment

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamOwnerTip ),
                           CMData : @{ CMTeamOwnerTipText : self.text?self.text : @"",
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

- (NSString *)teamOwnerTipText
{
    if (!_teamOwnerTipText || _teamOwnerTipText.length == 0) {
        _teamOwnerTipText = [self.teamOwnerTipOperationInfo objectForKey:@"text"];
    }
    return _teamOwnerTipText;
}

- (NSMutableAttributedString *)teamOwnerTipAttributedString
{
    if (!_teamOwnerTipAttributedString) {
        _teamOwnerTipAttributedString = [self.teamOwnerTipOperationInfo objectForKey:@"attributed"];
    }
    return _teamOwnerTipAttributedString;
}

- (NSMutableArray *)teamOwnerTipLinks
{
    if (!_teamOwnerTipLinks) {
        _teamOwnerTipLinks = [self.teamOwnerTipOperationInfo objectForKey:@"links"];
    }
    return _teamOwnerTipLinks;
}

- (NSDictionary *)teamOwnerTipOperationInfo
{
    if (!_teamOwnerTipOperationInfo) {
        NSString *text = self.text;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableArray *links = [NSMutableArray array];
        [attributedString addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0, text.length)];
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(-1.5) range:NSMakeRange(0, text.length)];
        NSRange range_1 = [text rangeOfString:@"邀请好友"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range_1];
        [links addObject:@{@"value": [NSString stringWithFormat:@"%ld", (long)TeamOwnerTipOperationActionTypeInvite], @"range": [NSValue valueWithRange:range_1]}];
        NSRange range_2 = [text rangeOfString:@"分享群聊"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range_2];
        [links addObject:@{@"value": [NSString stringWithFormat:@"%ld", (long)TeamOwnerTipOperationActionTypeShare], @"range": [NSValue valueWithRange:range_2]}];
        _teamOwnerTipOperationInfo = @{@"text": text, @"attributed": attributedString, @"links": links};
    }
    return _teamOwnerTipOperationInfo;
}

- (CGSize)contentSize:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = [self contenText:message];
    CGSize textSize = [Utility getTextString:attributedString.string textFont:Font(JTTipTextFont) frameWidth:(App_Frame_Width-40) attributedString:attributedString];
    return CGSizeMake(textSize.width+28, textSize.height+6);
}

- (NSMutableAttributedString *)contenText:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = self.teamOwnerTipAttributedString;
    [attributedString addAttribute:NSFontAttributeName value:Font(JTTipTextFont) range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (NSArray *)contentLinks:(NIMMessage *)message
{
    return self.teamOwnerTipLinks;
}
@end
