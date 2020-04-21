//
//  JTStoreCommentScoreModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreCommentScoreModel.h"

@implementation JTStoreCommentScoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"environment"  : @"environment",
             @"skill"        : @"skill",
             @"service"      : @"service",
             @"score"        : @"score"
             };
}

@end
