//
//  JTActivityJoinViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTActivityJoinTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "JTJoinTeamViewController.h"
#import "JTSessionViewController.h"
#import "JTActivityJoinViewController.h"
#import "JTActivityDetailViewController.h"

@interface JTActivityJoinViewController () <UITableViewDataSource, JTActivityJoinTableViewCellDelegate>
@property (nonatomic, strong) UILabel *tipLB;

@end

@implementation JTActivityJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我参与的活动";
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self setShowTableRefreshFooter:YES];
    [self setShowTableRefreshHeader:YES];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.tableview registerClass:[JTActivityJoinTableViewCell class] forCellReuseIdentifier:activityJoinIdentifier];
    [self.view addSubview:self.tipLB];
    [self staticRefreshFirstTableListData];
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserActivityApi) parameters:@{@"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTActivityJoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityJoinIdentifier];
    [cell configActivityJoinTableViewCellWithSource:self.dataArray[indexPath.section] indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.section];
    return [tableView fd_heightForCellWithIdentifier:activityJoinIdentifier cacheByIndexPath:indexPath configuration:^(JTActivityJoinTableViewCell *cell) {
        [cell configActivityJoinTableViewCellWithSource:dictionary indexPath:indexPath];
    }];;
}

#pragma mark JTActivityJoinTableViewCellDelegate
#pragma mark 活动详情
- (void)activityJoinTableViewCellTapped:(NSIndexPath *)indexPath {
    NSDictionary *info = self.dataArray[indexPath.section];
    JTActivityDetailViewController *detailVC = [[JTActivityDetailViewController alloc] initWithActivityID:info[@"activity_id"]];
    detailVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    detailVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController pushViewController:detailVC animated:NO];
}

#pragma mark 加入活动群聊
- (void)joinActivityTeamSource:(id)source {
    int status = [source[@"status"] intValue];
    NSString *teamID = [NSString stringWithFormat:@"%@",source[@"group_id"]];
    if (status == 3) {
        __weak typeof(self)weakSelf = self;
        [[NIMSDK sharedSDK].teamManager fetchTeamInfo:teamID completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
            [weakSelf.navigationController pushViewController:[[JTJoinTeamViewController alloc] initWithTeam:team teamSource:JTTeamSourceFromActivity inviteID:nil] animated:YES];
        }];
        
    }
    else
    {
        NIMSession *session = [NIMSession session:teamID type:NIMSessionTypeTeam];
        JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
        if (self.tabBarController.selectedIndex == 0) {
            sessionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sessionVC animated:YES];
            UIViewController *root = self.navigationController.viewControllers[0];
            self.navigationController.viewControllers = @[root, sessionVC];
        }
        else
        {
            [self.tabBarController setSelectedIndex:0];
            [[self.tabBarController.selectedViewController topViewController] setHidesBottomBarWhenPushed:YES];
            [sessionVC setHidesBottomBarWhenPushed:YES];
            [self.tabBarController.selectedViewController pushViewController:sessionVC animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"暂时没有参加的活动~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

@end
