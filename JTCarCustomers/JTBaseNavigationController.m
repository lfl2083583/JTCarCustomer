//
//  JTBaseNavigationController.m
//  JTSocial
//
//  Created by apple on 2017/7/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTBaseNavigationController.h"
#import "UIViewController+MMDrawerController.h"
#import "JTLoginViewController.h"
#import "JTBindingPhoneViewController.h"
#import "JTBindingAndLoginViewController.h"
#import "JTCardViewController.h"
#import "JTTeamInfoViewController.h"
#import "JTBonusDetailViewController.h"
#import "JTMapMarkViewController.h"
#import "JTContractSearchResultViewController.h"
#import "JTFaultSearchViewController.h"
#import "JTActivityDetailViewController.h"
#import "JTGlobalSearchViewController.h"
#import "JTCategoriesSearchViewController.h"
#import "JTMessageSearchViewController.h"
#import "JTCarLifeViewController.h"
#import "JTCollectionSearchViewController.h"

@interface JTBaseNavigationController () <UINavigationControllerDelegate>

@end

@implementation JTBaseNavigationController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChangeNotification:) name:kLoginStatusChangeNotification object:nil];
}

- (void)loginStatusChangeNotification:(NSNotification *)notification
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:(self.viewControllers.count == 1 && [JTUserInfo shareUserInfo].isLogin) ? MMOpenDrawerGestureModeBezelPanningCenterView : MMOpenDrawerGestureModeNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isShowMyController = ([viewController isKindOfClass:[JTLoginViewController class]] ||
                               [viewController isKindOfClass:[JTBindingPhoneViewController class]] ||
                               [viewController isKindOfClass:[JTBindingAndLoginViewController class]] ||
                               [viewController isKindOfClass:[JTCardViewController class]] ||
                               [viewController isKindOfClass:[JTTeamInfoViewController class]] ||
                               [viewController isKindOfClass:[JTBonusDetailViewController class]] ||
                               [viewController isKindOfClass:[JTMapMarkViewController class]] ||
                               [viewController isKindOfClass:[JTContractSearchResultViewController class]] ||
                               [viewController isKindOfClass:[JTFaultSearchViewController class]] ||
                               [viewController isKindOfClass:[JTActivityDetailViewController class]] ||
                               [viewController isKindOfClass:[JTGlobalSearchViewController class]] ||
                               [viewController isKindOfClass:[JTCategoriesSearchViewController class]] ||
                               [viewController isKindOfClass:[JTMessageSearchViewController class]] ||
                               [viewController isKindOfClass:[JTCarLifeViewController class]] ||
                               [viewController isKindOfClass:[JTCollectionSearchViewController class]]
                               );
    
    [navigationController setNavigationBarHidden:isShowMyController animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //设置打开或关闭抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:(navigationController.viewControllers.count == 1 && [JTUserInfo shareUserInfo].isLogin) ? MMOpenDrawerGestureModeBezelPanningCenterView : MMOpenDrawerGestureModeNone];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
