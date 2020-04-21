//
//  ZTBulletManager.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZTBulletView;

@interface ZTBulletManager : NSObject

// 弹幕数据源
@property(nonatomic, strong) NSMutableArray *dataSources;
// 弹幕 bulletView 创建完成之后的回调，便于添加到指定的 superView 中
@property(nonatomic, copy) void (^generateViewBlock)(ZTBulletView *bulletView);

/**
 单例方法
 */
+ (instancetype)sharedInstance;

/**
 开始弹幕运动
 */
- (void)zt_startBulletsAction;

/**
 停止弹幕运动
 */
- (void)zt_stopAction;

- (void)zt_insertBulletView:(NSDictionary *)commentInfo;

@end
