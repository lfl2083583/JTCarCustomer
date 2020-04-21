//
//  JTGarageDynamicContainerViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTSegmentedControl.h"
#import "JTGarageViewController.h"
#import "JTDynamicViewController.h"
#import "JTGarageDynamicContainerViewController.h"

@interface JTGarageDynamicContainerViewController () <FJSlidingControllerDataSource>

@property (nonatomic, strong) ZTSegmentedControl *segmentedControl;
@property (nonatomic, strong) JTGarageViewController *vc1;
@property (nonatomic, strong) JTDynamicViewController *vc2;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation JTGarageDynamicContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
}

- (void)setupComponent
{
    [self.view addSubview:self.segmentedControl];
    __weak typeof(self) weakself = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        [weakself selectedIndex:index];
    };
    self.datasouce = self;
    self.vc1 = [[JTGarageViewController alloc] init];
    self.vc1.parentController = self;
    //__weak typeof(self)weakself = self;
    self.vc1.block = ^{
        [weakself.delegate callBack];
    };
    self.vc2 = [[JTDynamicViewController alloc] init];
    self.vc2.parentController = self;
    self.controllers = @[self.vc1, self.vc2];
    self.isDisableScroll = NO;
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
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"车库", @"动态"]];
        _segmentedControl.frame = CGRectMake(0, 0, App_Frame_Width, kTopBarHeight);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:18.0f],
                                                  NSForegroundColorAttributeName : BlackLeverColor6,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : [UIFont systemFontOfSize:18.0f],
                                                          NSForegroundColorAttributeName : BlueLeverColor1,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlueLeverColor1;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.showHorizonLine = YES;
    }
    return _segmentedControl;
}


@end
