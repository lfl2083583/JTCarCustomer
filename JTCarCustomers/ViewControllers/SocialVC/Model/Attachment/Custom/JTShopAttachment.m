//
//  JTShopAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTShopAttachment.h"

@implementation JTShopAttachment

- (instancetype)initWithShopId:(NSString *)shopId
                      coverUrl:(NSString *)coverUrl
                          name:(NSString *)name
                         score:(NSString *)score
                          time:(NSString *)time
                       address:(NSString *)address
{
    self = [super init];
    if (self) {
        _shopId = shopId;
        _coverUrl = coverUrl;
        _name = name;
        _score = score;
        _time = time;
        _address = address;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeShop ),
                           CMData : @{ CMCustomShopID : self.shopId?self.shopId : @"",
                                       CMCustomShopCoverUrl : self.coverUrl?self.coverUrl : @"",
                                       CMCustomShopName : self.name?self.name : @"",
                                       CMCustomShopScore : self.score?self.score : @"",
                                       CMCustomShopTime : self.time?self.time : @"",
                                       CMCustomShopAddress : self.address?self.address : @"",
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
    CGFloat width = JTBubbleMaxWidth - 30.0;
    CGFloat height = width * 9.0 / 16.0;
    return CGSizeMake(JTBubbleMaxWidth, height + 85);
}

- (NSString *)contentBubbleImage:(NIMMessage *)message
{
    return message.isOutgoingMsg ? @"icon_sender_node_white_normal " : @"icon_receiver_node_normal";
}
@end
