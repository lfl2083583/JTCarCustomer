//
//  JTTeamSelectViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMailListModel.h"
#import "JTForwardPopupView.h"
#import "JTTeamTableViewCell.h"
#import "UIView+Spring.h"
#import "JTTeamSelectViewController.h"

@interface JTTeamSelectViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, assign) BOOL isSearching;

@end

@implementation JTTeamSelectViewController

- (instancetype)initWithConfig:(id<JTContactConfig>)config {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _config = config;
    }
    return self;
}

- (void)leftClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择群聊";
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:70];
    [self.tableview setDataSource:self];
    [self.tableview setTableHeaderView:self.searchBar];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTTeamTableViewCell class] forCellReuseIdentifier:teamCellIndentifer];
    [self.dataArray addObjectsFromArray:[NIMSDK sharedSDK].teamManager.allMyTeams];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCellIndentifer];
    NIMTeam *team = self.dataArray[indexPath.row];
    [cell configTeamCellWithTeam:team];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    NIMTeam *team = self.dataArray[indexPath.row];
    NSDictionary *progem;
    JTSelectType seletedType;
    if (self.config.selectType == JTContactSelectTypeRepeatMessage) {
        progem = @{@"message" : self.config.source, @"team" : team};
        seletedType = JTSelectTypeRepeatMessage;
    }
    else if (self.config.selectType == JTContactSelectTypeShareInfomation)
    {
        progem = @{@"infomation" : self.config.source, @"team" : team};
        seletedType = JTSelectTypeShareInfomation;
    }
    else if (self.config.selectType == JTContactSelectTypeShareActivity)
    {
        progem = @{@"activity" : self.config.source, @"team" : team};
        seletedType = JTSelectTypeShareActivity;
    }
    else if (self.config.selectType == JTContactSelectTypeShareTeam)
    {
        progem = @{@"teamcard" : self.config.source, @"team" : team};
        seletedType = JTSelectTypeShareTeam;
    }
    else if (self.config.selectType == JTContactSelectTypeShareStore)
    {
        progem = @{@"store" : self.config.source, @"team" : team};
        seletedType = JTSelectTypeShareStore;
    }
    else
    {
        progem = @{};
        seletedType = JTSelectTypeRepeatMessage;
    }
    JTForwardPopupView *shareView = [[JTForwardPopupView alloc] initWithSource:progem selectType:seletedType sessionType:NIMSessionTypeTeam];
    shareView.callBack = ^(NSString *content, JTPopupActionType actionType) {
        if (actionType == JTPopupActionTypeDefault && weakSelf.callBack) {
            weakSelf.callBack(@[team.teamId], content);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [[Utility mainWindow] presentView:shareView animated:YES completion:nil];
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //[self handleSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        self.isSearching = NO;
        [self.tableview reloadData];
    }
    else
    {
        self.isSearching = YES;
    }
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width, kTopBarHeight);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundColor = WhiteColor;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

@end
