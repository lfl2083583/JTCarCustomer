//
//  JTStoreModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreModel.h"

@implementation JTStoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"storeID"       : @"store_id",
             @"logo"          : @"logo",
             @"name"          : @"store_name",
             @"type"          : @"type",
             @"color"         : @"color",
             @"score"         : @"score",
             @"distance"      : @"distance",
             @"address"       : @"address",
             @"latitude"      : @"latitude",
             @"longitude"     : @"longitude",
             @"labels"        : @"label",
             @"is_favorite"   : @"is_favorite",
             @"time"          : @"time",
             @"h5Url"         : @"h5_url"
             };
}

@end
