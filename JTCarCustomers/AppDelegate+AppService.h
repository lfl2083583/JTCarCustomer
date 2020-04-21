//
//  AppDelegate+AppService.h
//  JTDirectSeeding
//
//  Created by apple on 2017/3/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "AppDelegate.h"
#import "OpenInstallSDK.h"

@interface AppDelegate (AppService) <OpenInstallDelegate, NIMLoginManagerDelegate>

/**
 系统配置（网络启动，路由启动）
 */
- (void)systemConfigure;

/**
 版本检查
 */
- (void)versionDetection;

/**
 注册OpenInstall
 */
- (void)registerOpenInstall;

/**
 注册友盟统计
 */
- (void)umengTrack;

/**
 注册社交平台
 */
- (void)configUSharePlatforms;

/**
 注册消息推送
 */
- (void)registerAPNS;

/**
 注册网易IM
 */
- (void)configNIMSDK;

/**
 监听网易IM
 */
- (void)commonInitListenEvents;

/**
 注册百度OCR
 */
- (void)registerAipOcr;
@end
