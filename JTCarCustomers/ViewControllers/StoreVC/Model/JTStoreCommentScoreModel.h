//
//  JTStoreCommentScoreModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTStoreCommentScoreModel : NSObject

@property (copy, nonatomic) NSString *environment;      // 环境评分
@property (copy, nonatomic) NSString *skill;            // 技术评分
@property (copy, nonatomic) NSString *service;          // 服务评分
@property (copy, nonatomic) NSString *score;            // 商家评分

@end
