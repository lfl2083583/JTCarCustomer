//
//  JTTeamMemberListViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTUserTableViewCell.h"
#import "JTCardViewController.h"
#import "JTTeamMembersViewController.h"
#import "JTTeamMemberListViewController.h"

@interface JTTeamMemberListViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) JTTeamMembersHeadView *headView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation JTTeamMemberListViewController

- (void)dealloc {
    CCLOG(@"JTTeamMemberListViewController销毁了");
}

- (instancetype)initWithTeam:(NIMTeam *)team {
    self = [super init];
    if (self) {
        self.team = team;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight+70, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-70) rowHeight:70 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview registerClass:[JTUserTableViewCell class] forCellReuseIdentifier:userTableViewIndentifier];
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview.dataSource = self;
    self.showTableRefreshFooter = YES;
    self.showTableRefreshHeader = YES;
    self.tableview.tableHeaderView = self.searchBar;
    [self.view addSubview:self.tipLB];
    [self.tableview.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetGroupMemberApi) parameters:@{@"group_id" : self.team.teamId, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        if (responseObject[@"page"][@"total"]) {
            weakSelf.headView.bottomLB.text = [NSString stringWithFormat:@"共%@人",responseObject[@"page"][@"total"]];
        }
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
    JTUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userTableViewIndentifier];
    [cell configUserCellWithUserInfo:self.isSearch?self.searchResults[indexPath.row]:self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.isSearch?self.searchResults.count:self.dataArray.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = self.isSearch?self.searchResults[indexPath.row]:self.dataArray[indexPath.row];
    NSString *uid = dictionary[@"uid"];
    [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:uid teamID:self.team.teamId] animated:YES];
    
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        self.isSearch = NO;
        self.tipLB.hidden = YES;
        [self.tableview reloadData];
    }
    else
    {
        self.isSearch = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    __weak typeof(self)weakSelf = self;
    [self.searchResults removeAllObjects];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj[@"nick_name"];
        if ([str rangeOfString:searchBar.text].location != NSNotFound) {
            [weakSelf.searchResults addObject:obj];
        }
        
    }];
    [self.tableview reloadData];
    [searchBar resignFirstResponder];
    self.tipLB.hidden = self.searchResults.count;
}


- (JTTeamMembersHeadView *)headView {
    if (!_headView) {
        _headView = [[JTTeamMembersHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 70)];
    }
    return _headView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, self.tableview.width, IOS11?56:44);
        _searchBar.delegate = self;
        _searchBar.backgroundColor = BlackLeverColor1;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}

- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"找不到结果~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

@end
