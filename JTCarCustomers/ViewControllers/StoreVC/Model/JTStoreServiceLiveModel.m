//
//  JTStoreServiceLiveModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceLiveModel.h"

@implementation JTStoreServiceLiveModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"coverUrlString"   : @"pic_url",
             @"liveStatus"       : @"live_status"
             };
}

@end
