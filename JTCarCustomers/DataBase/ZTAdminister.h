//
//  ZTAdminister.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTDataBase.h"

@interface ZTAdminister : NSObject

/**
 插入数据

 @param model 数据模型
 */
+ (void)sqlite_insert:(id<JTDataBaseConfig>)model;

/**
 批量插入数据

 @param modelArray 数据模型数组
 */
+ (void)sqlite_batchInsert:(NSArray *)modelArray;

/**
 删除数据
 
 @param model 数据模型
 */
+ (void)sqlite_delete:(id<JTDataBaseConfig>)model;

/**
 修改数据
 
 @param model 数据模型
 */
+ (void)sqlite_update:(id<JTDataBaseConfig>)model;

/**
 查找数据

 @param model 数据模型
 @return 查到到的数据
 */
+ (id)sqlite_search:(id<JTDataBaseConfig>)model;

/**
 清除表数据

 @param tableName 表名
 */
+ (void)sqlite_truncate:(NSString *)tableName;
@end
