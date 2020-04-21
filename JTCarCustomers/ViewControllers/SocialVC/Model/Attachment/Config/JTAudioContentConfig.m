//
//  JTAudioContentConfig.m
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTAudioContentConfig.h"

@implementation JTAudioContentConfig

- (CGSize)contentSize:(NIMMessage *)message
{
    NIMAudioObject *audioContent = (NIMAudioObject *)[message messageObject];
    NSAssert([audioContent isKindOfClass:[NIMAudioObject class]], @"message should be audio");
    
    CGFloat value = 2*atan((audioContent.duration/1000.0-1)/10.0)/M_PI;
    NSInteger audioContentMinWidth = 60;
    NSInteger audioContentMaxWidth = (App_Frame_Width - 170);
    NSInteger audioContentHeight   = 40;
    CGFloat width = (audioContentMaxWidth - audioContentMinWidth) * value + 60;
    return CGSizeMake(MAX(width, 80), audioContentHeight);
}

@end
