//
//  JTMoneyBonusReturnAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMoneyBonusReturnAttachment.h"

@implementation JTMoneyBonusReturnAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeMoneyBonusReturn ),
                           CMData : @{ CMMoneyBonusReturnBonusId : self.bonusId?self.bonusId : @"",
                                       CMMoneyBonusReturnTitle : self.title?self.title : @"",
                                       CMMoneyBonusReturnMoney : self.money?self.money : @"",
                                       CMMoneyBonusReturnReason : self.reason?self.reason : @"",
                                       CMMoneyBonusReturnTime : self.time?self.time : @"",
                                       CMMoneyBonusReturnRemarks : self.remarks?self.remarks : @""
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
    CGFloat contentWidth = JTBubbleMaxWidth-28-65;
    CGSize reasonValueSize = [Utility getTextString:self.reason textFont:Font(14) frameWidth:contentWidth attributedString:nil];
    CGSize theMoneyTimeValueSize = [Utility getTextString:self.time textFont:Font(14) frameWidth:contentWidth attributedString:nil];
    CGSize remarksValueSize = [Utility getTextString:self.remarks textFont:Font(14) frameWidth:contentWidth attributedString:nil];
    
    CGFloat height = MAX(reasonValueSize.height, 15) + MAX(theMoneyTimeValueSize.height, 15) + MAX(remarksValueSize.height, 15) + 180;
    return CGSizeMake(JTBubbleMaxWidth, height);
}

@end
