//
//  JTDataBaseConfig.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JTDataBaseConfig <NSObject>

@optional

/**
 创建表

 @return return value description
 */
- (NSString *)createSQLite;
/**
 插入数据
 
 @return return value description
 */
- (NSString *)insertSQLite;
/**
 删除数据
 
 @return return value description
 */
- (NSString *)deleteSQLite;
/**
 更新数据
 
 @return return value description
 */
- (NSString *)updateSQLite;
/**
 搜索数据
 
 @return return value description
 */
- (NSString *)searchSQLite;
@end
