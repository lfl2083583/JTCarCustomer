//
//  JTCarModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarModel.h"

@implementation JTCarModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"carID"         : @"car_id",
             @"number"        : @"car_cards",
             @"brand"         : @"brand_name",
             @"model"         : @"series_name",
             @"name"          : @"spec_str",
             @"isAuth"        : @"is_auth",
             @"buyTime"       : @"buy_car_time",
             @"mileageStr"    : @"car_mileage",
             @"mileageNum"    : @"car_mileage_num",
             @"icon"          : @"car_ico",
             @"isDefault"     : @"is_default",
             };
}

@end
