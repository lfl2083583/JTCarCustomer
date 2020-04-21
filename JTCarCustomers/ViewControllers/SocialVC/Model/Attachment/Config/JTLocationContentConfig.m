//
//  JTLocationContentConfig.m
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTLocationContentConfig.h"

@implementation JTLocationContentConfig

- (CGSize)contentSize:(NIMMessage *)message
{
    CGFloat height = App_Frame_Width*.6f;
    CGFloat width = height*.4f+30.f;
    return CGSizeMake(height+5, width);
}

- (NSString *)contentBubbleImage:(NIMMessage *)message
{
    return message.isOutgoingMsg ? @"icon_sender_node_white_normal " : @"icon_receiver_node_normal";
}
@end
