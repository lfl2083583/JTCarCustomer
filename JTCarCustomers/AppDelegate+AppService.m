//
//  AppDelegate+AppService.m
//  JTDirectSeeding
//
//  Created by apple on 2017/3/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "JTCustomAttachmentDecoder.h"
#import "JTConfigDelegate.h"
#import "JTIMNotificationCenter.h"
#import "JTUserNotificationCenter.h"
#import "JTMailListModel.h"
#import "JTInputExpressionManager.h"
#import "JTPushNotificationProcessingCenter.h"
#import "MMDrawerController.h"

static char versionInfoSuccessKey;
static char versionInfoFailureKey;
static char configDelegateKey;

NSString *JTIMNotificationLogout = @"JTIMNotificationLogout";

@interface AppDelegate ()

@property (copy, nonatomic) void (^versionInfoSuccess)(NSDictionary *sourceDic);

@property (copy, nonatomic) void (^versionInfoFailure)(void);

@property (strong, nonatomic) JTConfigDelegate *configDelegate;

@end

@implementation AppDelegate (AppService)

- (void)systemConfigure
{
    [HttpRequestTool sharedInstance];
    [[JTSocialRouterUtil sharedCenter] registerRouterWithScheme];
}

- (void (^)(NSDictionary *sourceDic))versionInfoSuccess
{
    return objc_getAssociatedObject(self, &versionInfoSuccessKey);
}

- (void)setVersionInfoSuccess:(void (^)(NSDictionary *))versionInfoSuccess
{
    objc_setAssociatedObject(self, &versionInfoSuccessKey, versionInfoSuccess, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))versionInfoFailure
{
    return objc_getAssociatedObject(self, &versionInfoFailureKey);
}

- (void)setVersionInfoFailure:(void (^)(void))versionInfoFailure
{
    objc_setAssociatedObject(self, &versionInfoFailureKey, versionInfoFailure, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)versionDetection
{
    __block NSInteger maxCount = 3;
    __weak typeof(self) weakself = self;
    self.versionInfoSuccess = ^(NSDictionary *sourceDic) {
        NSDictionary *status = [sourceDic objectForKey:@"data"];
        NSInteger updateType = [[status objectForKey:@"updateType"] integerValue];
        if (updateType == 0) {
            if (![JTUserInfo shareUserInfo].isAppleAccount && ![JTUserInfo shareUserInfo].isAdoptReview_Local) {
                [JTUserInfo shareUserInfo].isAdoptReview_Local = YES;
                [[JTUserInfo shareUserInfo] save];
                [[NSNotificationCenter defaultCenter] postNotificationName:kViewControllerShouldReloadNotification object:nil];
            }
        }
        else if (updateType == 1 || updateType == 2) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ignoreVersion"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ignoreVersion"] isEqualToString:[status objectForKey:@"versionCode"]]) {
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:[status objectForKey:@"description"] preferredStyle:UIAlertControllerStyleAlert];
                if (updateType != 2) {
                    [alertController addAction:[UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                        [[NSUserDefaults standardUserDefaults] setObject:[status objectForKey:@"versionCode"] forKey:@"ignoreVersion"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }]];
                }
                [alertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[status objectForKey:@"url"]]];
                    exit(0);
                }]];
                [weakself.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            }
        }
    };
    self.versionInfoFailure = ^{
        maxCount --;
        if (maxCount > 0 && [weakself respondsToSelector:@selector(requestServieVersionInfo:failure:)]) {
            [weakself requestServieVersionInfo:weakself.versionInfoSuccess failure:weakself.versionInfoFailure];
        }
    };
    [self requestServieVersionInfo:weakself.versionInfoSuccess failure:weakself.versionInfoFailure];
}

- (void)requestServieVersionInfo:(void (^)(NSDictionary *sourceDic))success
                         failure:(void (^)(void))failure
{
//    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SystemUpdateApi) parameters:@{@"source": CHANNEL_ID} success:^(id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure();
//        }
//    }];
}

- (void)registerOpenInstall
{
    [OpenInstallSDK setAppKey:OpenInstallKey withDelegate:self];
}

- (void)umengTrack
{
    [MobClick setLogEnabled:NO];
    [UMAnalyticsConfig sharedInstance].appKey = USHARE_APPKEY;
    [UMAnalyticsConfig sharedInstance].channelId = CHANNEL_ID;
    [MobClick setAppVersion:App_Version];
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChatHandler_AppId appSecret:WeChatHandler_appSecret redirectURL:kShareUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQHander_AppId appSecret:QQHander_appkey redirectURL:kShareUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaHandler_AppId  appSecret:SinaHandler_appKey redirectURL:kShareUrl];
}

- (void)registerAPNS
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil]];
}

- (void)configNIMSDK
{
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDK sharedSDK] registerWithAppID:kNIMAppKey
                                  cerName:kNIMCerName];
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[JTCustomAttachmentDecoder new]];
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([JTUserInfo shareUserInfo].isLogin)
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:[JTUserInfo shareUserInfo].userYXAccount
                                               token:[JTUserInfo shareUserInfo].userYXToken];
    }
}

- (JTConfigDelegate *)configDelegate
{
    return objc_getAssociatedObject(self, &configDelegateKey);
}

- (void)setConfigDelegate:(JTConfigDelegate *)configDelegate
{
    objc_setAssociatedObject(self, &configDelegateKey, configDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:JTIMNotificationLogout
                                               object:nil];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [self setConfigDelegate:[[JTConfigDelegate alloc] init]];
    [[NIMSDKConfig sharedConfig] setDelegate:self.configDelegate];
    [[JTIMNotificationCenter sharedCenter] start];
    [[JTUserNotificationCenter sharedCenter] start];
    [[JTMailListModel sharedCenter] start];
    [[JTInputExpressionManager sharedManager] setup];
}

- (void)registerAipOcr
{
    [[AipOcrService shardService] authWithAK:AipOcr_Appkey andSK:AipOcr_AppSecret];
}

/**
 上传设备token
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

/**
 处理收到的APNS消息，向服务器上报收到APNS消息
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[JTPushNotificationProcessingCenter sharedCenter] receiveMessages:userInfo isClick:YES];
}

/**
 ios7 收到通知 前台收到通知
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[JTPushNotificationProcessingCenter sharedCenter] receiveMessages:userInfo isClick:NO];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 90000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if (![[UMSocialManager defaultManager] handleOpenURL:url]) {
        if (![[JTSocialRouterUtil sharedCenter] handleOpenURL:url]) {
            if (![OpenInstallSDK handLinkURL:url]) {
                return NO;
            }
        }
    }
    return YES;
}

#endif
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if (![[UMSocialManager defaultManager] handleOpenURL:url]) {
        if (![[JTSocialRouterUtil sharedCenter] handleOpenURL:url]) {
            if (![OpenInstallSDK handLinkURL:url]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (![[UMSocialManager defaultManager] handleOpenURL:url]) {
        if (![[JTSocialRouterUtil sharedCenter] handleOpenURL:url]) {
            if (![OpenInstallSDK handLinkURL:url]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
API_AVAILABLE(ios(9.0)){
    if ([shortcutItem.type isEqualToString:@"shortcut.scan"]) {
        
    }
}

- (void)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler
{
    [OpenInstallSDK continueUserActivity:userActivity];
}

#pragma mark NIMLoginManagerDelegate
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:JTIMNotificationLogout object:nil];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"安全提示" message:@"您的账号在别的设备登录。如果这不是你的操作，你的账号已经泄露。可联系客服冻结溜车圈账号。" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }]];
        [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
        
    }];
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK) {
        [self syncNIMUserInfo:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy]];
    }
}

- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    __block NSString *message = [NSString stringWithFormat:@"系统错误: %zd", error.code];
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:JTIMNotificationLogout object:nil];
        [Utility showAlertMessage:message];
    }];
}

- (void)syncNIMUserInfo:(NSArray *)recentSessions
{
    if (recentSessions.count > 0) {
        NSMutableArray *userIdArray = [NSMutableArray array];
        for (NSInteger index = 0; index < recentSessions.count; index ++) {
            [userIdArray addObject:[(NIMSession *)[recentSessions[index] session] sessionId]];
        }
        if (userIdArray > 0) {
            [[NIMSDK sharedSDK].userManager fetchUserInfos:userIdArray
                                                completion:^(NSArray *users, NSError *error) {
                                                }];
        }
    }
}

- (void)logout:(NSNotification *)notification
{
    [[JTUserInfo shareUserInfo] clear];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChangeNotification object:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)getInstallParamsFromOpenInstall:(NSDictionary *)params withError:(NSError *)error
{
//    if ([JTSocialStautsUtil sharedCenter].isFirstInstallation) {
//        if (!error && params) {
//            [JTUserInfo shareUserInfo].inviteCodeNumber = params[@"icode"];
//            [[JTUserInfo shareUserInfo] save];
//        }
//    }
}

- (void)getWakeUpParamsFromOpenInstall:(NSDictionary *)params withError:(NSError *)error
{
//    if (!error && params) {
//        if ([params objectForKey:@"roomid"]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?roomID=%@", kJTCarCustomersScheme, JTPlatformWatchLive, params[@"roomid"]]]];
//        }
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    if ([JTUserInfo shareUserInfo].isLogin) {
        MMDrawerController *drawerController = (MMDrawerController *)[self.window rootViewController];
        UITabBarController *tabVC = (UITabBarController *)[drawerController centerViewController];
        NSInteger unreadCount = 0;
        for (UINavigationController *nav in tabVC.viewControllers) {
            unreadCount += [nav.tabBarItem.badgeValue integerValue];
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unreadCount];
    }
    else
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

@end
