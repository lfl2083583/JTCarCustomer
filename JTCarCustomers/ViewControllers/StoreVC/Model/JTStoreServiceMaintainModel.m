//
//  JTStoreServiceMaintainModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceMaintainModel.h"

@implementation JTStoreServiceMaintainModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"storeSeviceModels": [JTStoreSeviceModel class]
             };
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"maintainID"       : @"c_id",
             @"name"             : @"name",
             @"storeSeviceModels": @"service",
             @"total"            : @"total"
             };
}


@end
