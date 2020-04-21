//
//  JTStoreInformationModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreInformationModel.h"

@implementation JTEngineerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"engineerID"  : @"staff_id",
             @"name"        : @"name",
             @"avatar"      : @"head_img",
             };
}

@end

@implementation JTStoreInformationModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"engineers"         : [JTEngineerModel class]
             };
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"coverImages"       : @"ambient",
             @"phone"             : @"phone",
             @"engineers"         : @"engineer",
             };
}

@end
