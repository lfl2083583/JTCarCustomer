//
//  JTContractSearchResultViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/29.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamTableViewCell.h"
#import "JTUserTableViewCell.h"

#import "JTCardViewController.h"
#import "JTTeamInfoViewController.h"
#import "JTContractSearchResultViewController.h"

@interface JTContractSearchResultViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *tipLB;

@end

@implementation JTContractSearchResultViewController

- (instancetype)initWithSearchType:(JTContractSearchType)searchType keywords:(NSString *)keywords {
    self = [super init];
    if (self) {
        self.searchType = searchType;
        self.keywords = keywords;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kTopBarHeight+kStatusBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) rowHeight:70 sectionHeaderHeight:10 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerClass:[JTUserTableViewCell class] forCellReuseIdentifier:userTableViewIndentifier];
    [self.tableview registerClass:[JTTeamTableViewCell class] forCellReuseIdentifier:teamCellIndentifer];
    self.searchBar.text = self.keywords;
    [self.view addSubview:self.tipLB];
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchType == JTContractSearchTypeUser) {
        JTUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userTableViewIndentifier];
        [cell configUserCellWithUserInfo:self.dataArray[indexPath.row]];
        return cell;
    } else {
        JTTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCellIndentifer];
        [cell configTeamCellWithTeamInfo:self.dataArray[indexPath.row]];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    if (self.searchType == JTContractSearchTypeUser) {
        NSString *userID = [NSString stringWithFormat:@"%@",dictionary[@"uid"]];
        [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:userID] animated:YES];
    } else {
        NSString *teamID = [NSString stringWithFormat:@"%@",dictionary[@"group_id"]];
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:teamID];
        if (team) {
            [self.navigationController pushViewController:[[JTTeamInfoViewController alloc] initWithTeam:team] animated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    __weak typeof (self)weakSelf = self;
    [self.searchBar resignFirstResponder];
    NSString *requestUrl = (self.searchType == JTContractSearchTypeUser)?SearchUserApi:SearchTeamApi;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(requestUrl) parameters:@{@"keyword" : searchBar.text} success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        [weakSelf.dataArray removeAllObjects];
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        [weakSelf.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width, kTopBarHeight);
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = (self.searchType == JTContractSearchTypeUser)?@"手机号码/爱车号":@"输入群组关键词或群号";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundImage = [UIImage graphicsImageWithColor:WhiteColor rect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopBarHeight)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(20, kTopBarHeight+kStatusBarHeight+79, App_Frame_Width-40, 20)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.text = @"找不到结果~";
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.hidden = YES;
    }
    return _tipLB;
}
@end
