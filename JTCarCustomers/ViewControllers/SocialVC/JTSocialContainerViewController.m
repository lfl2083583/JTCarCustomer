//
//  JTSocialContainerViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSocialContainerViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HMSegmentedControl.h"
#import "JTSessionListViewController.h"
#import "JTMailListViewController.h"
#import "ZTCirlceImageView.h"
#import "JTGradientButton.h"
#import "UIBarButtonItem+WZLBadge.h"
#import "JTMessageAssistantViewController.h"

@interface JTSocialContainerViewController () <FJSlidingControllerDataSource>

@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) JTSessionListViewController *vc1;
@property (strong, nonatomic) JTMailListViewController *vc2;
@property (strong, nonatomic) ZTCirlceImageView *avatarBT;
@property (strong, nonatomic) JTGradientButton *loginBT;
@property (strong, nonatomic) UILabel *promptLB;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation JTSocialContainerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updataUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.hidesBottomBarWhenPushed) {
        self.hidesBottomBarWhenPushed = NO;
    }
    [super viewWillDisappear:animated];
}

- (void)leftClick
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self.view endEditing:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
    }
}

- (void)rightClick:(id)sender
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self.navigationController pushViewController:[[JTMessageAssistantViewController alloc] init] animated:YES];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
    }
}

- (void)loginClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChangeNotification:) name:kLoginStatusChangeNotification object:nil];
    [self reloadData];
    [self updataUI];
}

- (void)setupComponent
{
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.avatarBT];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_remind"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem.badgeCenterOffset = CGPointMake(-8, 0);
    self.navigationItem.titleView = self.segmentedControl;
    __weak typeof(self) weakself = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        if ([JTUserInfo shareUserInfo].isLogin) {
            [weakself selectedIndex:index];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
            [weakself.segmentedControl setSelectedSegmentIndex:0];
        }
    };
    self.datasouce = self;
    self.vc1 = [[JTSessionListViewController alloc] init];
    self.vc1.parentController = self;
    self.vc2 = [[JTMailListViewController alloc] init];
    self.vc2.parentController = self;
    self.controllers = @[self.vc1, self.vc2];
    self.isDisableScroll = YES;
    
//    [self.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:100 animationType:WBadgeAnimTypeNone];
}

- (void)loginStatusChangeNotification:(NSNotification *)notification
{
    [self updataUI];
}

- (void)updataUI
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self.avatarBT setAvatarByUrlString:[[JTUserInfo shareUserInfo].userAvatar avatarHandleWithSquare:self.avatarBT.height*2] defaultImage:DefaultSmallAvatar];
        [self.pageController.view setHidden:NO];
        [self.loginBT removeFromSuperview];
        [self.promptLB removeFromSuperview];
    }
    else
    {
        [self.avatarBT setImage:DefaultSmallAvatar];
        [self.pageController.view setHidden:YES];
        [self.view addSubview:self.loginBT];
        [self.view addSubview:self.promptLB];
    }
}

#pragma mark FJSlidingControllerDataSource
- (NSInteger)numberOfPageInFJSlidingController:(FJSlidingController *)fjSlidingController {
    return self.controllers.count;
}

- (UIViewController *)fjSlidingController:(FJSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index {
    return self.controllers[index];
}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"消息", @"通讯录"]];
        _segmentedControl.frame = CGRectMake(0, 20, 200, kTopBarHeight);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : Font(18),
                                                  NSForegroundColorAttributeName : BlackLeverColor6,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : Font(18),
                                                          NSForegroundColorAttributeName : BlueLeverColor1,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlueLeverColor1;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
    }
    return _segmentedControl;
}

- (ZTCirlceImageView *)avatarBT
{
    if (!_avatarBT) {
        _avatarBT = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _avatarBT.userInteractionEnabled = YES;
        [_avatarBT addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarBT;
}

- (JTGradientButton *)loginBT
{
    if (!_loginBT) {
        _loginBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        [_loginBT setTitle:@"去登录" forState:UIControlStateNormal];
        [_loginBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_loginBT.titleLabel setFont:Font(16)];
        [_loginBT addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        [_loginBT setFrame:CGRectMake((App_Frame_Width-120)/2, 250, 120, 45)];
    }
    return _loginBT;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] init];
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.font = Font(14);
        _promptLB.textAlignment = NSTextAlignmentCenter;
        _promptLB.text = @"快来加入溜车圈，结识更多志同道合的朋友~";
        _promptLB.frame = CGRectMake(0, CGRectGetMaxY(self.loginBT.frame)+20, App_Frame_Width, 20);
    }
    return _promptLB;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
