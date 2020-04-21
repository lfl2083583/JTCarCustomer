//
//  JTAddFriendsGroupViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTAddTeamViewController.h"
#import "JTAddFriendsViewController.h"
#import "JTAddFriendsGroupContainerViewController.h"
#import "ZTSegmentedControl.h"

@interface JTAddFriendsGroupContainerViewController () <FJSlidingControllerDataSource>

@property (strong, nonatomic) ZTSegmentedControl *segmentedControl;

@property (strong, nonatomic) JTAddTeamViewController *addGroupVc;
@property (strong, nonatomic) JTAddFriendsViewController *addFriendsVc;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation JTAddFriendsGroupContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加好友";
    self.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.segmentedControl];
    [self setupComponent];
    [self reloadData];
}

- (void)setupComponent{
    self.datasouce = self;
    self.addFriendsVc = [[JTAddFriendsViewController alloc] init];
    self.addFriendsVc.parentController = self;
    self.addGroupVc = [[JTAddTeamViewController alloc] init];
    self.addGroupVc.parentController = self;
    self.controllers = @[self.addFriendsVc, self.addGroupVc];
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

- (ZTSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"找人", @"找群"]];
        _segmentedControl.frame = CGRectMake(0, kStatusBarHeight + kTopBarHeight, App_Frame_Width, kTopBarHeight);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:16.0],
                                                  NSForegroundColorAttributeName : BlackLeverColor6,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : [UIFont systemFontOfSize:16.0],
                                                          NSForegroundColorAttributeName : BlueLeverColor1,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlueLeverColor1;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.showHorizonLine = YES;
        __weak typeof (self)weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            CCLOG(@"%ld",index);
            [weakSelf selectedIndex:index];
        }];
    }
    return _segmentedControl;
}


@end
