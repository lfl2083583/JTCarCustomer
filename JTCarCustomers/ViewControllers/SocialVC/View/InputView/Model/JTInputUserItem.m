//
//  JTInputUserItem.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputUserItem.h"

@implementation JTInputUserItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"name"         : @"name",
             @"yunxinID"     : @"yunxinID",
             @"range"        : @"range",
             };
}

@end
