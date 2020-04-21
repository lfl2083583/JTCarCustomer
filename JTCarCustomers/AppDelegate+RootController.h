//
//  AppDelegate+RootController.h
//  JTDirectSeeding
//
//  Created by apple on 2017/3/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootController)

/**
 *  设置根视图
 */
- (void)initRootViewController;
/**
 *  设置主题
 */
- (void)themeConfiguration;
/**
 *  设置3DTouch快捷入口
 */
- (void)shortcutItemConfiguration;
/**
 *  是否是新版本
 */
- (BOOL)isNewVersion;
/**
 是否第一次安装

 @return YES.是 NO.不是
 */
- (BOOL)isFirstInstallation;
@end
