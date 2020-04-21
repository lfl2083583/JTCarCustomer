//
//  JTMailListViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//


#import "JTMailListViewController.h"

#import "SwipeTableView.h"
#import "ZTSegmentedControl.h"
#import "JTMailTableView.h"

#import "JTMailListModel.h"
#import "JTUserNotificationCenter.h"

#import "JTSessionViewController.h"
#import "JTCardViewController.h"
#import "JTCreatTeamTipViewController.h"
#import "JTAddFriendsGroupContainerViewController.h"
#import "JTGlobalSearchViewController.h"

@interface JTMailListViewController () <SwipeTableViewDelegate, SwipeTableViewDataSource, UISearchBarDelegate, JTMailListDelegate, JTMailTableViewDelegate>

@property (nonatomic, strong) SwipeTableView *swipeTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) ZTSegmentedControl *segmentedControl;
@property (nonatomic, strong) ZTSegmentedControl *segmentedControl2;
@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, assign) NSInteger seletedIndex;

@end

@implementation JTMailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTUserInfoUpdatedNotification object:nil];
    
    [[JTMailListModel sharedCenter] addDelegate:self];
    
    [self.view addSubview:self.swipeTableView];
    [self.view addSubview:self.tipLB];
    [self.view setBackgroundColor:WhiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTTeamMembersUpdatedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (SwipeTableView *)swipeTableView
{
    if (!_swipeTableView) {
        _swipeTableView = [[SwipeTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-kStatusBarHeight-kTopBarHeight-kBottomBarHeight)];
        _swipeTableView.delegate = self;
        _swipeTableView.dataSource = self;
        _swipeTableView.swipeHeaderView = self.headerView;
        _swipeTableView.swipeHeaderBar = self.segmentedControl;
        _swipeTableView.shouldAdjustContentSize = YES;
        _swipeTableView.swipeHeaderTopInset = 0;
    }
    return _swipeTableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.swipeTableView.width, self.searchBar.height + self.segmentedControl2.height+10)];
        [_headerView addSubview:self.searchBar];
        [_headerView addSubview:self.segmentedControl2];
        _headerView.backgroundColor = BlackLeverColor1;
    }
    return _headerView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, self.swipeTableView.width, IOS11?56:44);
        _searchBar.delegate = self;
        _searchBar.backgroundColor = BlackLeverColor1;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}

- (ZTSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"好友", @"关注", @"粉丝", @"群聊"]];
        _segmentedControl.frame = CGRectMake(0, 0, self.swipeTableView.width, 44);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
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
        _segmentedControl.showHorizonLine = YES;
        __weak typeof(self) weakself = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            [weakself.swipeTableView scrollToItemAtIndex:index animated:YES];
        };
    }
    return _segmentedControl;
}

- (ZTSegmentedControl *)segmentedControl2
{
    if (!_segmentedControl2) {
        _segmentedControl2 = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"创建群聊", @"添加朋友/群"]];
        _segmentedControl2.frame = CGRectMake(0, self.searchBar.height, self.swipeTableView.width, 40);
        _segmentedControl2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl2.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl2.titleTextAttributes = @{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                  NSForegroundColorAttributeName : BlackLeverColor3,
                                                  };
        _segmentedControl2.selectionIndicatorHeight = 0.f;
        _segmentedControl2.backgroundColor = WhiteColor;
        _segmentedControl2.showVerticalLine = YES;
        _segmentedControl.touchEnabled = YES;
        __weak typeof(self) weakself = self;
        _segmentedControl2.indexClick = ^(NSInteger index) {
            if (index == 0) {
                [weakself.parentController.navigationController pushViewController:[[JTCreatTeamTipViewController alloc] init] animated:YES];
            } else {
                [weakself.parentController.navigationController pushViewController:[[JTAddFriendsGroupContainerViewController alloc] init] animated:YES];
            }
        };
    }
    return _segmentedControl2;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.hidden = YES;
    }
    return _tipLB;
}


#pragma mark SwipeTableViewDataSource
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView
{
    return 4;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view
{
    JTMailTableView *mailTableView = (JTMailTableView *)view;
    if (nil == mailTableView) {
        mailTableView = [[JTMailTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-kBottomBarHeight) style:UITableViewStylePlain];
        mailTableView.mailTableViewDelegate = self;
    }
    JTMailTableItem *item = [[JTMailTableItem alloc] init];
    switch (index) {
        case 0:
            item.dataArray = [JTMailListModel sharedCenter].friendMembers;
            item.mailType = JTMailTypeFriends;
            item.indexTitles = [JTMailListModel sharedCenter].friendTitles;
            break;
        case 1:
            item.dataArray = [JTMailListModel sharedCenter].focusMembers;
            item.mailType = JTMailTypeFocus;
            item.indexTitles = @[];
            break;
        case 2:
            item.dataArray = [JTMailListModel sharedCenter].fansMembers;
            item.mailType = JTMailTypeFans;
            item.indexTitles = @[];
            break;
        case 3:
            item.dataArray = [JTMailListModel sharedCenter].teamArray;
            item.mailType = JTMailTypeTeam;
            item.indexTitles = @[];
            break;
        default:
            break;
    }
    mailTableView.item = item;
    self.seletedIndex = index;
    return mailTableView;
}

#pragma mark SwipeTableViewDelegate
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    
    self.segmentedControl.selectedSegmentIndex = swipeView.currentItemIndex;
}

- (void)swipeTableViewDidScroll:(SwipeTableView *)swipeView {
    self.seletedIndex = swipeView.currentItemIndex;
}

#pragma mark JTMailTableViewDelegate
- (void)mailTableView:(UITableView *)tableView didSelectAtSession:(NIMSession *)session {
    if (session.sessionType == NIMSessionTypeP2P) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:session.sessionId];
        NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:session.sessionId]];
        JTCardViewController *cardVC = [[JTCardViewController alloc] initWithUserID:userID];
        cardVC.yunXinID = user.userId;
        [self.parentController.navigationController pushViewController:cardVC animated:YES];
    } else {
        JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
        [self.parentController.navigationController pushViewController:sessionVC animated:YES];
    }
}

#pragma mark JTMailListDelegate
- (void)mailListChange {
    [self.swipeTableView reloadData];
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.parentController.navigationController pushViewController:[[JTGlobalSearchViewController alloc] init] animated:YES];
    return NO;
}


- (void)setSeletedIndex:(NSInteger)seletedIndex {
    _seletedIndex = seletedIndex;
    switch (seletedIndex) {
        case 0:
        {
            self.tipLB.hidden = [JTMailListModel sharedCenter].friendMembers.count;
            self.tipLB.text = @"还没有好友~";
        }
            break;
        case 1:
        {
            self.tipLB.hidden = [JTMailListModel sharedCenter].focusMembers.count;
            self.tipLB.text = @"还没有关注的人~";
        }
            break;
        case 2:
        {
            self.tipLB.hidden = [JTMailListModel sharedCenter].fansMembers.count;
            self.tipLB.text = @"还没有粉丝~";
        }
            break;
        case 3:
        {
            self.tipLB.hidden = [JTMailListModel sharedCenter].teamList.count;
            self.tipLB.text = @"还没有群聊~";
        }
            break;
        default:
            break;
    }
}

@end

