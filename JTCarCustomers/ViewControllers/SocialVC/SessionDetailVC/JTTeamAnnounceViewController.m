//
//  JTTeamAnnounceViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTTeamAnnounceViewController.h"
#import "JTTeamAnnounceEditViewController.h"
#import "JTTeamAnnounceDetailViewController.h"

@interface JTTeamAnnounceViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JTTeamAnnounceTableHeadView *tableHeadView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;

@end

@implementation JTTeamAnnounceViewController

- (instancetype)initWithTeam:(NIMTeam *)team {
    self = [super init];
    if (self) {
        _team = team;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableHeadView];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kTopBarHeight+kStatusBarHeight+self.tableHeadView.height, App_Frame_Width, APP_Frame_Height-kTopBarHeight-kStatusBarHeight-self.tableHeadView.height) rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview registerClass:[JTTeamAnnounceTableViewCell class] forCellReuseIdentifier:teamAnnounceIndentify];
    [self.tableview setDataSource:self];
    [self setShowTableRefreshFooter:YES];
    [self setShowTableRefreshHeader:YES];
    [self.view addSubview:self.tipLB];
    if ([self.team.owner isEqualToString:[JTUserInfo shareUserInfo].userYXAccount]) {
        self.navigationItem.rightBarButtonItem = self.rightBarItem;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self staticRefreshFirstTableListData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)rightBtnClick:(UIButton *)sender {
    JTTeamAnnounceEditViewController *announceVC = [[JTTeamAnnounceEditViewController alloc] initWithNibName:@"JTTeamAnnounceEditViewController" bundle:nil];
    announceVC.team = self.team;
    [self.navigationController pushViewController:announceVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTTeamAnnounceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamAnnounceIndentify];
    [cell configCellWithAnnounce:self.dataArray[indexPath.section]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[JTTeamAnnounceDetailViewController alloc] initWithTeamAnnounce:self.dataArray[indexPath.section] team:self.team] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:teamAnnounceIndentify cacheByIndexPath:indexPath configuration:^(JTTeamAnnounceTableViewCell *cell) {
        [cell configCellWithAnnounce:weakSelf.dataArray[indexPath.section]];
    }];
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(AnnounceListApi) parameters:@{@"group_id" : self.team.teamId, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
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

- (JTTeamAnnounceTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTTeamAnnounceTableHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 50)];
    }
    return _tableHeadView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        _rightBtn.titleLabel.font = Font(14);
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightBtn setTitle:@"编辑公告" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake((App_Frame_Width-120)/2.0, (APP_Frame_Height-20)/2.0, 120, 20)];
        _tipLB.font = Font(14);
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"暂时没有群公告~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

- (UIBarButtonItem *)rightBarItem {
    if (!_rightBarItem) {
        _rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    }
    return _rightBarItem;
}
@end
