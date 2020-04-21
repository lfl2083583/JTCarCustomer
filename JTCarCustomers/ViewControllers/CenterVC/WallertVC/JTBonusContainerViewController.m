//
//  JTBonusContainerViewController.m
//  JTCarCustomers
//
//  Created by liufulin on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTSegmentedControl.h"
#import "JTBonusSendViewController.h"
#import "JTBonusObtainViewController.h"
#import "JTBonusContainerViewController.h"

@interface JTBonusContainerViewController () <FJSlidingControllerDataSource>

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) ZTSegmentedControl *segmentedControl;
@property (nonatomic, strong) JTBonusObtainViewController *vc1;
@property (nonatomic, strong) JTBonusSendViewController *vc2;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation JTBonusContainerViewController

- (ZTSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"收到的红包", @"发出的红包"]];
        _segmentedControl.frame = CGRectMake(0, CGRectGetMaxY(self.titleLB.frame), 220, 40);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                  NSForegroundColorAttributeName : BlackLeverColor5,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                          NSForegroundColorAttributeName : BlueLeverColor1,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlueLeverColor1;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.backgroundColor = WhiteColor;
        __weak typeof(self) weakself = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            [weakself selectedIndex:index];
        };
    }
    return _segmentedControl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.titleLB];
    [self.view addSubview:self.segmentedControl];
    [self setupComponent];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)setupComponent{
    self.datasouce = self;
    self.vc1 = [[JTBonusObtainViewController alloc] init];
    self.vc1.parentController = self;
    self.vc2 = [[JTBonusSendViewController alloc] init];
    self.vc2.parentController = self;
    self.controllers = @[self.vc1, self.vc2];
    self.isDisableScroll = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FJSlidingControllerDataSource
- (NSInteger)numberOfPageInFJSlidingController:(FJSlidingController *)fjSlidingController {
    return self.controllers.count;
}

- (UIViewController *)fjSlidingController:(FJSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index {
    return self.controllers[index];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, kStatusBarHeight+kTopBarHeight, App_Frame_Width-30, 40)];
        _titleLB.font = Font(24);
        _titleLB.text = @"我的红包";
    }
    return _titleLB;
}

@end
