//
//  JTInputUserCache.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTInputUserItem.h"

#define JTInputStartChar  @"@"
#define JTInputEndChar    @"\u2004"

@interface JTInputUserCache : NSObject

@property (nonatomic, strong) NSMutableArray *items;

- (NSArray *)getYunXinIDArray:(NSString *)text;

- (void)clean;

- (void)addItem:(JTInputUserItem *)item;

- (void)addItems:(NSArray *)items;

- (JTInputUserItem *)objectInName:(NSString *)name;

- (JTInputUserItem *)removeObjectAtName:(NSString *)name;

@end
