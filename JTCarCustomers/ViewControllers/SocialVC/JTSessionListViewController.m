//
//  JTSessionListViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionListViewController.h"
#import "JTSessionListTableViewCell.h"
#import "JTMessageMoneyViewController.h"
#import "JTMessageFunsViewController.h"
#import "JTMessageTeamViewController.h"
#import "JTSessionViewController.h"
#import "JTTalentListViewController.h"
#import "JTMessageCommentViewController.h"
#import "JTGlobalSearchViewController.h"

@interface JTSessionListViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *talentBT;
@property (nonatomic, strong) UILabel *promptLB;

@end

@implementation JTSessionListViewController

- (void)reloadUI:(BOOL)isReloadTableView
{
    [self.tableview setHidden:!self.recentSessions.count];
    [self.promptLB setHidden:self.recentSessions.count];
    [super reloadUI:isReloadTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.promptLB];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-kBottomBarHeight) rowHeight:65 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setTableHeaderView:self.searchBar];
    [self.tableview registerClass:[JTSessionListTableViewCell class] forCellReuseIdentifier:sessionListIdentifier];
    [self.view addSubview:self.talentBT];
}

- (void)talentClick:(id)sender {
   [self.parentController.navigationController pushViewController:[[JTTalentListViewController alloc] init] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recentSessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSessionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessionListIdentifier];
    [cell configWithSessionListTableViewCell:self.recentSessions[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
        option.removeSession = YES;
        option.removeTable = YES;
        [[[NIMSDK sharedSDK] conversationManager] deleteAllmessagesInSession:recentSession.session option:option];
    }];
    NSString *itemTitle = [[JTUserInfo shareUserInfo].sessionTops containsObject:recentSession.session.sessionId]?@"取消置顶":@"置顶";
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:itemTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        BOOL isTop = [[JTUserInfo shareUserInfo].sessionTops containsObject:recentSession.session.sessionId];
        if (isTop) {
            [[JTUserInfo shareUserInfo].sessionTops removeObject:recentSession.session.sessionId];
        }
        else
        {
            [[JTUserInfo shareUserInfo].sessionTops addObject:recentSession.session.sessionId];
        }
        [[JTUserInfo shareUserInfo] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTUpdateSessionTopNotification object:nil];
    }];
    topRowAction.backgroundColor = UIColorFromRGB(0xc7c7c7);
    return @[deleteRowAction, topRowAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMSession *session = (NIMSession *)[self.recentSessions[indexPath.row] session];
    if ([session.sessionId isEqualToString:kJTNomeyID]) {
        [self.parentController.navigationController pushViewController:[[JTMessageMoneyViewController alloc] initWithSession:session] animated:YES];
    }
    else if ([session.sessionId isEqualToString:kJTNormalID]) {
        [self.parentController.navigationController pushViewController:[[JTMessageFunsViewController alloc] initWithSession:session] animated:YES];
    }
    else if ([session.sessionId isEqualToString:kJTTeamID]) {
        [self.parentController.navigationController pushViewController:[[JTMessageTeamViewController alloc] initWithSession:session] animated:YES];
    }
    else if ([session.sessionId isEqualToString:kJTActivityID]) {
        [self.parentController.navigationController pushViewController:[[JTMessageCommentViewController alloc] initWithSession:session] animated:YES];
    }
    else {
        [self.parentController.navigationController pushViewController:[[JTSessionViewController alloc] initWithSession:session] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.parentController.navigationController pushViewController:[[JTGlobalSearchViewController alloc] init] animated:YES];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, self.tableview.width, IOS11?56:44);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = BlackLeverColor1;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}

- (UIButton *)talentBT
{
    if (!_talentBT) {
        _talentBT = [[UIButton alloc] init];
        [_talentBT setImage:[UIImage imageNamed:@"session_talent_icon"] forState:UIControlStateNormal];
        _talentBT.frame = CGRectMake(self.tableview.width-54, kStatusBarHeight+kTopBarHeight+_searchBar.height+48, 42, 42);
        [_talentBT addTarget:self action:@selector(talentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _talentBT;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] init];
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.font = Font(16);
        _promptLB.textAlignment = NSTextAlignmentCenter;
        _promptLB.text = @"还没有会话，在通讯录中找个人聊聊天";
        _promptLB.frame = CGRectMake(0, 200, App_Frame_Width, 20);
    }
    return _promptLB;
}

@end
