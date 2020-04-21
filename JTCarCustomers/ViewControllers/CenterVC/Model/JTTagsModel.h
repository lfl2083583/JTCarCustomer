//
//  JTTagsModel.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTTagsModel : NSObject

@property (nonatomic, strong) NSMutableArray *characters;
@property (nonatomic, strong) NSMutableArray *cars;
@property (nonatomic, strong) NSMutableArray *musics;
@property (nonatomic, strong) NSMutableArray *films;
@property (nonatomic, strong) NSMutableArray *professions;
@property (nonatomic, strong) NSMutableArray *sports;
@property (nonatomic, strong) NSMutableArray *industrys;
@property (nonatomic, strong) NSMutableArray *commons;

@property (nonatomic, strong) NSArray *userTags;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *sign;


- (NSArray *)buidItemArrayWith:(JTUserInfo *)userInfo;

+ (CGFloat)clculateRowHeight:(NSArray *)labels;

@end
