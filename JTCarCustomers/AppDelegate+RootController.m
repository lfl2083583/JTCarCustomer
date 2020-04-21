//
//  AppDelegate+RootController.m
//  JTDirectSeeding
//
//  Created by apple on 2017/3/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "AppDelegate+RootController.h"
#import "MMDrawerController.h"
#import "JTCenterViewController.h"
#import "JTMainViewController.h"

@implementation AppDelegate (RootController)

- (void)initRootViewController
{
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [self.window makeKeyAndVisible];
    
    JTCenterViewController *leftVC = [[JTCenterViewController alloc] init];
    JTMainViewController *mainVC = [[JTMainViewController alloc] init];
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:mainVC leftDrawerViewController:leftVC];
    
    //4、设置打开/关闭抽屉的手势
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    //5、设置左右两边抽屉显示的多少
    drawerController.maximumLeftDrawerWidth = 258.0 * App_Frame_Width / 375; 
    self.window.rootViewController = drawerController;
}

- (void)themeConfiguration
{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, -10) forBarMetrics:UIBarMetricsDefault];
        UIImage *backButtonImage = [[UIImage imageNamed:@"nav_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [UINavigationBar appearance].backIndicatorImage = backButtonImage;
        [UINavigationBar appearance].backIndicatorTransitionMaskImage =backButtonImage;
    }
    else
    {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
        UIImage *image = [[UIImage imageNamed:@"nav_black"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: Font(18), NSForegroundColorAttributeName: BlackLeverColor6}];
    [[UINavigationBar appearance] setBarTintColor:WhiteColor];
    // item 图片颜色
    [[UINavigationBar appearance] setTintColor:BlackLeverColor5];
    // item 文字颜色
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: Font(14), NSForegroundColorAttributeName: BlackLeverColor3} forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:BlackLeverColor5, NSForegroundColorAttributeName, Font(14), NSFontAttributeName, nil] forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: BlackLeverColor3} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: BlueLeverColor1} forState:UIControlStateSelected];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)shortcutItemConfiguration
{
//    UIMutableApplicationShortcutItem *scanItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"shortcut.scan" localizedTitle:@"扫一扫" localizedSubtitle:nil icon: [UIApplicationShortcutIcon iconWithTemplateImageName:@""] userInfo:nil];
//    [[UIApplication sharedApplication] setShortcutItems:@[scanItem]];
}

#define LAST_RUN_VERSION_KEY        @"last_run_version_of_application"
- (BOOL)isNewVersion
{
    NSString *currentVersion = App_Version;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}

#define FRIST_LAUNCH_KEY             @"firstLaunch"
- (BOOL)isFirstInstallation
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FRIST_LAUNCH_KEY]) {
        return NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FRIST_LAUNCH_KEY];
        return YES;
    }
}
@end
