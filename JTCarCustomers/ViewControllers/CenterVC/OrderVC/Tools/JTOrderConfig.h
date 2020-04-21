//
//  JTOrderConfig.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTOrderEnum.h"
#import <Foundation/Foundation.h>
#define kSectionTitle @"kSectionTitle"
#define kItems @"kItems"

@interface JTOrderConfig : NSObject

@property (nonatomic, assign) JTOrderType orderType;
@property (nonatomic, assign) JTOrderHandleStatus *handleStatus;

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) id order;

@end
