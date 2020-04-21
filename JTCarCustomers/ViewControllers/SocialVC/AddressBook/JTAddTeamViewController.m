//
//  JTAddGroupViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "HMSegmentedControl.h"

#import "JTAddTeamViewController.h"
#import "JTNearbyTeamViewController.h"
#import "JTRecommendTeamViewController.h"
#import "JTContractSearchResultViewController.h"


@interface JTAddTeamViewController () <UISearchBarDelegate,FJSlidingControllerDataSource>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) JTNearbyTeamViewController *nearbyTeamVc;
@property (nonatomic, strong) JTRecommendTeamViewController *recommendTeamVc;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation JTAddTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.segmentedControl];
    
    [self setupComponent];
    [self reloadData];
}

- (void)setupComponent{
    self.datasouce = self;
    self.nearbyTeamVc = [[JTNearbyTeamViewController alloc] init];
    self.nearbyTeamVc.parentController = self.parentController;
    self.recommendTeamVc = [[JTRecommendTeamViewController alloc] init];
    self.recommendTeamVc.parentController = self.parentController;
    self.controllers = @[self.nearbyTeamVc, self.recommendTeamVc];
    self.isDisableScroll = YES;
}

#pragma mark FJSlidingControllerDataSource
- (NSInteger)numberOfPageInFJSlidingController:(FJSlidingController *)fjSlidingController {
    return self.controllers.count;
}

- (UIViewController *)fjSlidingController:(FJSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index {
    return self.controllers[index];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.parentController.navigationController pushViewController:[[JTContractSearchResultViewController alloc] initWithSearchType:JTContractSearchTypeTeam keywords:searchBar.text] animated:YES];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kTopBarHeight, [UIScreen mainScreen].bounds.size.width, IOS11?56:44);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入群组关键词或群号";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundImage = [UIImage graphicsImageWithColor:BlackLeverColor1 rect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IOS11?56:44)];
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"附近的群组", @"推荐的群"]];
        _segmentedControl.frame = CGRectMake(0, kTopBarHeight+(IOS11?56:44), App_Frame_Width, kTopBarHeight);
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
        _segmentedControl.selectionIndicatorColor = WhiteColor;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.backgroundColor = WhiteColor;
        __weak typeof(self) weakself = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            [weakself selectedIndex:index];
        };
    }
    return _segmentedControl;
}

@end
