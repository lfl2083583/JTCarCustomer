//
//  JTStoreSeviceClassModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreSeviceClassModel.h"

@implementation JTStoreSeviceClassModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"classID"      : @"c_id",
             @"className"    : @"c_name",
             };
}

@end
