//
//  JTGroupTool.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTGroupTool : NSObject

@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *memberArray;

@property (copy, nonatomic) NSString *groupKey;
@property (copy, nonatomic) NSArray *originalArray;

- (instancetype)initWithGroupKey:(NSString *)groupKey originalArray:(NSArray *)originalArray;

@end
