//
//  JTBonusAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBonusAttachment.h"

@implementation JTBonusAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeBonus ),
                           CMData : @{ CMBonusFromID : self.fromId?self.fromId : @"",
                                       CMBonusFromYXAccID : self.from_yxAccId?self.from_yxAccId : @"",
                                       CMBonusID : self.bonusId?self.bonusId : @"",
                                       CMBonusContent : self.content?self.content : @"",
                                       CMBonusMoney : self.money?self.money : @"",
                                       CMBonusCount : self.count?self.count : @"",
                                       CMBonusType : @(self.type),
                                       CMBonusCreateDate : self.createDate?self.createDate : @"",
                                       CMBonusGrabbed : @(self.isGrabbed),
                                       CMBonusOverTime : @(self.isOverTime),
                                       CMBonusOverGrab : @(self.isOverGrab)
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

- (BOOL)isSender
{
    return [self.fromId isEqualToString:[JTUserInfo shareUserInfo].userID];
}

- (CGSize)contentSize:(NIMMessage *)message
{
    return CGSizeMake(JTBubbleMaxWidth, 82);
}

- (NSString *)contentBubbleImage:(NIMMessage *)message
{
    BOOL isClicking = (self.isGrabbed || self.isOverTime || self.isOverGrab);
    return message.isOutgoingMsg ? (isClicking ? @"icon_sender_bonus_node_select" : @"icon_sender_bonus_node_normal") : (isClicking ? @"icon_receiver_bonus_node_select" : @"icon_receiver_bonus_node_normal");
}

@end
