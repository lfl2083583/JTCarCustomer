//
//  JTPushNotificationProcessingCenter.m
//  JTSocial
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTPushNotificationProcessingCenter.h"

@implementation JTPushNotificationProcessingCenter

+ (instancetype)sharedCenter
{
    static JTPushNotificationProcessingCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTPushNotificationProcessingCenter alloc] init];
    });
    return instance;
}

- (void)receiveMessages:(NSDictionary *)messages isClick:(BOOL)isClick
{
}
@end
