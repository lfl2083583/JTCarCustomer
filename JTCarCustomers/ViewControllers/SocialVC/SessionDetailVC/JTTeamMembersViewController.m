//
//  JTTeamMembersViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamPowerModel.h"
#import "JTUserInfoHandle.h"
#import "JTContactConfig.h"
#import "JTUserTableViewCell.h"
#import "JTCardViewController.h"
#import "JTTeamMembersViewController.h"
#import "JTBaseNavigationController.h"
#import "JTContracSelectViewController.h"

@implementation JTTeamMembersHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLB];
        [self addSubview:self.bottomLB];
    }
    return self;
}

- (UILabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.width-44, 40)];
        _leftLB.font = Font(24);
        _leftLB.text = @"查看群成员";
    }
    return _leftLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.leftLB.frame)+5, self.width-44, 20)];
        _bottomLB.font = Font(14);
        _bottomLB.textColor = BlackLeverColor3;
    }
    return _bottomLB;
}

@end

@interface JTTeamMembersViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) JTTeamMembersHeadView *headView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, strong) JTContactTeamMemberConfig *teamConfig;
@property (nonatomic, strong) JTTeamPowerModel *powerModel;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) NSMutableArray *owners;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) BOOL isSearch;

@end

@implementation JTTeamMembersViewController

- (void)dealloc {
    CCLOG(@"JTTeamMembersViewController释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamMembersUpdatedNotification object:nil];
}

- (instancetype)initWithTeam:(NIMTeam *)team {
    self = [super init];
    if (self) {
        self.team = team;
        self.powerModel.team = team;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight+70, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-70) rowHeight:70 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview registerClass:[JTUserTableViewCell class] forCellReuseIdentifier:userTableViewIndentifier];
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = self.searchBar;
    self.tableview.sectionIndexColor = BlackLeverColor3;
    [self.view addSubview:self.tipLB];
    
    [self setupRightBarButton];
    [self fetchTeamMembersDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamMembersUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)fetchTeamMembersDatas {
    __weak typeof(self)weakSelf = self;
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.team.teamId completion:^(NSError *error, NSArray *members) {
        
        [weakSelf.members removeAllObjects];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.owners removeAllObjects];
        [weakSelf.members addObjectsFromArray:members];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type == 1"];
        NSArray *array = [weakSelf.members filteredArrayUsingPredicate:predicate];
        if (array.count) {
            id object = array.firstObject;
            [weakSelf.members removeObject:object];
            [weakSelf.owners addObject:object];
        }
        weakSelf.teamConfig.members = weakSelf.members;
        [weakSelf.dataArray addObjectsFromArray:members];
        weakSelf.headView.bottomLB.text = [NSString stringWithFormat:@"共%ld人",members.count];
        [weakSelf.tableview reloadData];
    }];
}

- (void)rightBarItemClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *inviteAction = [UIAlertAction actionWithTitle:@"邀请好友加群" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.powerModel.joinTeamType == 0) {
            [[HUDTool shareHUDTool] showHint:@"群主不允许任何人加入群" yOffset:0];
            return;
        }
        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeAddTeamMember;
        config.needMutiSelected = YES;
        NSMutableArray *memberIDs = [NSMutableArray array];
        for (NIMTeamMember *member in weakSelf.dataArray) {
            [memberIDs addObject:member.userId];
        }
        config.alreadySelectedMemberId = memberIDs;
        config.teamId = weakSelf.team.teamId;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }];
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"移除群成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeDeleteTeamMember;
        config.needMutiSelected = YES;
        config.members = weakSelf.dataArray;
        NSMutableArray *memberIDs = [NSMutableArray arrayWithObject:weakSelf.team.owner];
        if (![weakSelf.team.owner isEqualToString:[JTUserInfo shareUserInfo].userYXAccount] && ![self.team.serverCustomInfo isBlankString]) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[weakSelf.team.serverCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
            if (info && [info isKindOfClass:[NSDictionary class]]) {
                if ([info objectForKey:@"invite_user"] && [info[@"invite_user"] isKindOfClass:[NSArray class]]) {
                    [memberIDs addObjectsFromArray:info[@"invite_user"]];
                }
                if ([info objectForKey:@"remove_user"] && [info[@"remove_user"] isKindOfClass:[NSArray class]]) {
                    [memberIDs addObjectsFromArray:info[@"remove_user"]];
                }
            }
        }
        config.alreadySelectedMemberId = memberIDs;
        config.teamId = weakSelf.team.teamId;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }];
    if (self.powerModel.isInvitePower) {
        [alertVC addAction:inviteAction];
    }
    if (self.powerModel.isRemovePower) {
        [alertVC addAction:removeAction];
    }
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userTableViewIndentifier];
    NIMUser *user;
    if (self.isSearch)
    {
        NSDictionary *source = self.searchResults[indexPath.row];
        user = [[NIMSDK sharedSDK].userManager userInfo:source[@"yunxinID"]];
        [cell configCellWithNIMUser:user isTeamOwner:NO];
    }
    else
    {
        BOOL isOwner;
        if (indexPath.section == 0) {
            NIMTeamMember *member = self.owners[indexPath.row];
            user = [[NIMSDK sharedSDK].userManager userInfo:member.userId];
            isOwner = YES;
        }
        else
        {
            NSArray *array = self.teamConfig.groupMember[indexPath.section-1];
            NSDictionary *source = array[indexPath.row];
            user = [[NIMSDK sharedSDK].userManager userInfo:source[@"yunxinID"]];
            isOwner = NO;
        }
        [cell configCellWithNIMUser:user isTeamOwner:isOwner];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        return self.searchResults.count;
    }
    else
    {
        if (section == 0) {
            return self.owners.count;
        }
        else
        {
            NSArray *array = self.teamConfig.groupMember[section-1];
            return array.count;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return 1;
    }
    else
    {
        return self.owners.count+self.teamConfig.groupMember.count;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return @[];
    }
    else
    {
       return self.teamConfig.groupTitle;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isSearch) {
        return 0;
    }
    else
    {
        return section == 0?10:0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearch) {
        return 0;
    }
    else
    {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NIMUser *user;
    if (self.isSearch) {
        NSDictionary *source = self.searchResults[indexPath.row];
        user = [[NIMSDK sharedSDK].userManager userInfo:source[@"yunxinID"]];
    }
    else
    {
        if (indexPath.section == 0) {
            NIMTeamMember *member = self.owners[indexPath.row];
            user = [[NIMSDK sharedSDK].userManager userInfo:member.userId];
        }
        else
        {
            NSArray *array = self.teamConfig.groupMember[indexPath.section-1];
            NSDictionary *source = array[indexPath.row];
            user = [[NIMSDK sharedSDK].userManager userInfo:source[@"yunxinID"]];
            CCLOG(@"%@",user.ext);
        }
    }
    
    [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:[JTUserInfoHandle showUserId:user] teamID:self.team.teamId] animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 10)];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, App_Frame_Width - 11, 10)];
    leftLabel.font = Font(14);
    leftLabel.textColor = BlackLeverColor3;
    [sectionHead addSubview:leftLabel];
    leftLabel.text = (section == 0)?@"":self.teamConfig.groupTitle[section-1];
    sectionHead.backgroundColor = WhiteColor;
    return sectionHead;
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
    NSMutableArray *array = [NSMutableArray array];
    [self.teamConfig.groupMember enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchBar.text];
        [array addObjectsFromArray:[obj filteredArrayUsingPredicate:predicate]];
    }];
    self.searchResults = [NSMutableArray arrayWithArray:array];
    [self.tableview reloadData];
    [searchBar resignFirstResponder];
    self.tipLB.hidden = self.searchResults.count;
}

#pragma mark NSNotification
- (void)updateTableViewNotification:(NSNotification *)notification
{
    self.powerModel.team = [[NIMSDK sharedSDK].teamManager teamById:self.team.teamId];
    [self setupRightBarButton];
    [self fetchTeamMembersDatas];
}

- (void)setupRightBarButton {
    if (self.powerModel.isGroupMain) {
        self.powerModel.isInvitePower = YES;
        self.powerModel.isRemovePower = YES;
    }
    if (self.powerModel.isInvitePower+self.powerModel.isRemovePower) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (JTTeamMembersHeadView *)headView {
    if (!_headView) {
        _headView = [[JTTeamMembersHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 70)];
    }
    return _headView;
}

- (NSMutableArray *)members {
    if (!_members) {
        _members = [NSMutableArray array];
    }
    return _members;
}

- (NSMutableArray *)owners {
    if (!_owners) {
        _owners = [NSMutableArray array];
    }
    return _owners;
}

- (NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

- (JTContactTeamMemberConfig *)teamConfig {
    if (!_teamConfig) {
        _teamConfig = [[JTContactTeamMemberConfig alloc] init];
        _teamConfig.showAllMember = YES;
    }
    return _teamConfig;
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

- (JTTeamPowerModel *)powerModel {
    if (!_powerModel) {
        _powerModel = [[JTTeamPowerModel alloc] init];
    }
    return _powerModel;
}

@end
