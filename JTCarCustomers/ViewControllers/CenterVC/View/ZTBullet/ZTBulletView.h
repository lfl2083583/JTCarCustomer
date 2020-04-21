//
//  ZTBulletView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Start,  // 开始(马上进入屏幕)
    Enter,  // 完全进入屏幕
    Exit,   // 完全离开屏幕
} ZTBulletStatus;

@interface ZTBulletView : UIView

// 弹幕轨道
@property(nonatomic, assign) int trajectory;

// 弹幕对应状态:
// 1. 开始
// 2. 完全进入屏幕(需要创建新的弹幕追加在后面进行补位)
// 3. 完全离开屏幕(需要移除释放资源)
// 的block回调
@property(nonatomic, copy) void(^moveStatusBlock)(ZTBulletStatus status);

/**
 初始化弹幕

 @param commentInfo 弹幕内容
 @return 弹幕视图
 */
- (instancetype)initWithComment:(NSDictionary *)commentInfo;

/**
 开始动画
 */
- (void)zt_startAnimation;

/**
 结束动画
 */
- (void)zt_stopAnimation;

@end
