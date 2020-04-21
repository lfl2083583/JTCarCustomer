//
//  JTOrderContainerViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTSegmentedControl.h"
#import "JTOrderListViewController.h"
#import "JTOrderContainerViewController.h"

@interface JTOrderContainerViewController () <FJSlidingControllerDataSource>

@property (nonatomic, strong) JTOrderListViewController *vc1;
@property (nonatomic, strong) JTOrderListViewController *vc2;
@property (nonatomic, strong) JTOrderListViewController *vc3;
@property (nonatomic, strong) JTOrderListViewController *vc4;

@property (nonatomic, strong) ZTSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation JTOrderContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    // Do any additional setup after loading the view.
}

- (void)setupComponent {
    
    [self.navigationItem setTitle:@"我的订单"];
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.segmentedControl];
    __weak typeof(self)weakSelf = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf selectedIndex:index];
    };
    self.datasouce = self;
    self.vc1 = [[JTOrderListViewController alloc] initWithOrderListType:JTOrderListTypeAll parentController:self];
    self.vc2 = [[JTOrderListViewController alloc] initWithOrderListType:JTOrderListTypeInProgress parentController:self];
    self.vc3 = [[JTOrderListViewController alloc] initWithOrderListType:JTOrderListTypeComplete parentController:self];
    self.vc4 = [[JTOrderListViewController alloc] initWithOrderListType:JTOrderListTypeCancel parentController:self];

    self.controllers = @[self.vc1, self.vc2, self.vc3, self.vc4];
    self.isDisableScroll = YES;
    [self reloadData];
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

- (ZTSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"全部", @" 进行中", @"已完成", @"已取消"]];
        _segmentedControl.frame = CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, kTopBarHeight);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : Font(16),
                                                  NSForegroundColorAttributeName : BlackLeverColor6,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : Font(16),
                                                          NSForegroundColorAttributeName : BlueLeverColor1,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlueLeverColor1;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.showHorizonLine = YES;
    }
    return _segmentedControl;
}

@end
