//
//  JTTeamInfoViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMessageMaker.h"
#import "JTShareTool.h"
#import "JTWordItem.h"
#import "JTContactConfig.h"
#import "JTNavigationBar.h"
#import "JTTeamInfoTableHeadView.h"
#import "JTTeamDescribeTableViewCell.h"
#import "JTTeamMembersTableViewCell.h"
#import "JTTeamAttributesTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "JTCardViewController.h"
#import "JTJoinTeamViewController.h"
#import "JTTeamQRViewController.h"
#import "JTTeamInfoViewController.h"
#import "JTSessionViewController.h"
#import "JTTeamSelectViewController.h"
#import "JTContracSelectViewController.h"
#import "JTTeamMembersViewController.h"
#import "JTTeamInfoEditeViewController.h"
#import "JTTeamMemberListViewController.h"
#import "JTBaseNavigationController.h"

@interface JTTeamInfoViewController () <UITableViewDataSource, JTTeamMembersTableViewCellDelegate, JTNavigationBarDelegate, JTNavigationBarDelegate, JTTeamInfoViewDelegate>

@property (nonatomic, strong) JTTeamInfoTableHeadView *tableHeadView;
@property (nonatomic, strong) JTTeamInfoTableFootView *tableFootView;
@property (nonatomic, strong) JTTeamInfoNavigationBar *nagationBar;

@property (nonatomic, strong) NSMutableArray *propertyArray;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, assign) BOOL isTeamMember;

@end

@implementation JTTeamInfoViewController

- (void)dealloc {
    CCLOG(@"JTTeamInfoViewController释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamMembersUpdatedNotification object:nil];
}

- (instancetype)initWithTeam:(NIMTeam *)team teamSource:(JTTeamSource)teamSource {
    self = [self initWithTeam:team];
    if (self) {
        _teamSource = teamSource;
    }
    return self;
}

- (instancetype)initWithTeam:(NIMTeam *)team {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _team = team;
        _session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
        _isTeamMember = [[NIMSDK sharedSDK].teamManager isMyTeam:team.teamId];
        _teamSource = JTTeamSourceFromNormal;
        [self updateTeamConfig];
    }
    return self;
}

- (void)updateTeamConfig
{
    self.powerModel.team = self.team;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeFullScreen rowHeight:60 sectionHeaderHeight:10 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = self.tableHeadView;
    if (![[NIMSDK sharedSDK].teamManager isMyTeam:self.team.teamId]) {
        self.tableview.tableFooterView = self.tableFootView;
    }
    [self.tableview registerClass:[JTTeamMembersTableViewCell class] forCellReuseIdentifier:membersIdentifier];
    [self.tableview registerClass:[JTTeamDescribeTableViewCell class] forCellReuseIdentifier:discribCellIdentifier];
    [self.tableview registerClass:[JTTeamAttributesTableViewCell class] forCellReuseIdentifier:attributeCellIdentifier];
    self.tableHeadView.team = self.team;
    [self.view addSubview:self.nagationBar];
    [self requestTeamInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamMembersUpdatedNotification object:nil];
}

- (void)requestTeamInfo {
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GroupInfoApi) parameters:@{@"group_id":self.team.teamId} success:^(id responseObject, ResponseState state) {
        if (responseObject[@"distance"] && [responseObject[@"distance"] isKindOfClass:[NSDictionary class]]) {
            weakSelf.tableHeadView.distance  = responseObject[@"distance"];
        }
        if (responseObject[@"property"] && [responseObject[@"property"] isKindOfClass:[NSArray class]]) {
            [weakSelf.propertyArray removeAllObjects];
            [weakSelf.propertyArray addObjectsFromArray:responseObject[@"property"]];
        }
        if (responseObject[@"member_list"] && [responseObject[@"member_list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.members removeAllObjects];
            [weakSelf.members addObjectsFromArray:responseObject[@"member_list"]];
        }
        if (responseObject[@"invite"]) {
            weakSelf.powerModel.joinTeamType = [responseObject[@"invite"] integerValue];
        }
        [weakSelf setupComponent];
        [weakSelf.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupComponent {
    JTWordItem *item1 = [self creatItemWithCellIndentify:membersIdentifier];
    JTWordItem *item2 = [self creatItemWithCellIndentify:discribCellIdentifier];
    JTWordItem *item3 = [self creatItemWithCellIndentify:attributeCellIdentifier];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:@[item1]];
    if (self.isTeamMember) {
        [self.dataArray addObject:item2];
    } else if (self.members.count) {
       [self.dataArray addObject:item2];
    }
    if (self.propertyArray.count) {
        [self.dataArray addObject:item3];
    }
}

- (JTWordItem *)creatItemWithCellIndentify:(NSString *)indentify {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.tagID = indentify;
    return item;
}

#pragma mark NSNotification
- (void)updateTableViewNotification:(NSNotification *)notification
{
    self.team = [[NIMSDK sharedSDK].teamManager teamById:self.team.teamId];
    [self updateTeamConfig];
    self.tableHeadView.team = self.team;
    [self requestTeamInfo];
    [self.tableview reloadData];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.section];
    if ([item.tagID isEqualToString:membersIdentifier])
    {
        JTTeamMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:membersIdentifier];
        if (_isTeamMember)
        {
            [cell configMembersWithSession:self.session powerModel:self.powerModel delegate:self];
        }
        else
        {
            [cell configMembersWithSession:self.session teamMembers:self.members isVisitor:YES delegate:self];
        }
        return cell;
    }
    else if ([item.tagID isEqualToString:discribCellIdentifier])
    {
        JTTeamDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:discribCellIdentifier];
        [cell configTableViewCellTitle:@"群介绍" subtitle:self.team.intro];
        return cell;
    }
    else
    {
        JTTeamAttributesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attributeCellIdentifier];
        cell.propertys = self.propertyArray;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 2?0.01:10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.section];
    if ([item.tagID isEqualToString:membersIdentifier]) {
        CGFloat height;
        if (_isTeamMember) {
           height =  [JTTeamMembersTableViewCell getCellHeightWithSession:self.session powerModel:self.powerModel isVisitor:NO teamMembersCount:0];
        } else {
           height =  [JTTeamMembersTableViewCell getCellHeightWithSession:self.session powerModel:self.powerModel isVisitor:YES teamMembersCount:self.members.count];
        }
        return height;
    }
    else if ([item.tagID isEqualToString:discribCellIdentifier])
    {
        __weak typeof(self)weakSelf = self;
        return [tableView fd_heightForCellWithIdentifier:discribCellIdentifier cacheByIndexPath:indexPath configuration:^(JTTeamDescribeTableViewCell *cell) {
            [cell configTableViewCellTitle:@"群介绍" subtitle:weakSelf.team.intro];
        }];
    }
    else
    {
        return 143;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.section];
    if ([item.tagID isEqualToString:membersIdentifier] && self.isTeamMember) {
        [self.navigationController pushViewController:[[JTTeamMembersViewController alloc] initWithTeam:self.team] animated:YES];
    }
    else if ([item.tagID isEqualToString:membersIdentifier] && !self.isTeamMember)
    {
        [self.navigationController pushViewController:[[JTTeamMemberListViewController alloc] initWithTeam:self.team] animated:YES];
    }
}

#pragma mark JTTeamMembersTableViewCellDelegate
- (void)teamDetailMembersCell:(id)membersCell clickTeamUserID:(NSString *)userID {
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userID];
    NSString *uid = [JTUserInfoHandle showUserId:user];
    [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:uid teamID:self.team.teamId] animated:YES];
}

- (void)teamDetailMembersCell:(id)membersCell clickTeamOperation:(JTTeamOperationType)operation {
    if (self.powerModel.joinTeamType == 0) {
        [[HUDTool shareHUDTool] showHint:@"群主不允许任何人加入群" yOffset:0];
        return;
    }
    if (operation == JTTeamOperationTypeAdd) {
        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeAddTeamMember;
        config.needMutiSelected = YES;
        NSMutableArray *memberIDs = [NSMutableArray array];
        for (NIMTeamMember *member in [membersCell members]) {
            [memberIDs addObject:member.userId];
        }
        config.alreadySelectedMemberId = memberIDs;
        config.teamId = self.team.teamId;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    } else if (operation == JTTeamOperationTypeDel) {
        JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeDeleteTeamMember;
        config.needMutiSelected = YES;
        config.members = [membersCell members];
        NSMutableArray *memberIDs = [NSMutableArray arrayWithObject:self.powerModel.ownerID];
        if (!self.powerModel.isGroupMain && ![self.team.serverCustomInfo isBlankString]) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[self.team.serverCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
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
        config.teamId = self.team.teamId;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark UIScrollViewDeleagte
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (scrollView == self.tableview) {
        if(offsetY < 0) {
            CGFloat totalOffset = App_Frame_Width + fabs(offsetY);
            CGFloat f = totalOffset / App_Frame_Width;
            self.tableHeadView.coverImgeView.frame = CGRectMake(-(width*f-width) / 2.0, offsetY, width * f, totalOffset);
        }
    }
}

#pragma mark JTNavigationBarDelegate
-(void)navigationBarToLeft:(id)navigationBar {
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)navigationBarToRight:(id)navigationBar {
    __weak typeof(self) weakself = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"分享该群" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself shareTeam];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself complainTeam];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark JTTeamInfoViewDelegate
- (void)teamInfoViewEditeTeamInfo {
    [self.navigationController pushViewController:[[JTTeamInfoEditeViewController alloc] initWithTeam:self.team loctionInfo:nil] animated:YES];
}

- (void)teamInfoViewQRCode {
    [self.navigationController pushViewController:[[JTTeamQRViewController alloc] initWithTeam:self.team] animated:YES];
}


- (void)teamInfoViewApplyJoin {
    if (self.powerModel.joinTeamType == 0) {
        [[HUDTool shareHUDTool] showHint:@"群主不允许任何人加入群" yOffset:0];
    }
    else if (self.powerModel.joinTeamType == 1)
    {
        NSMutableDictionary *progrem = [NSMutableDictionary dictionary];
        [progrem setValue:self.team.teamId forKey:@"group_id"];
        [progrem setValue:@(self.teamSource) forKey:@"join_type"];
        if (self.inviteID && [self.inviteID isKindOfClass:[NSString class]]) {
            [progrem setValue:self.inviteID forKey:@"invite"];
        }
        __weak typeof(self)weakSelf = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(NormalJoinTeamApi) parameters:progrem success:^(id responseObject, ResponseState state) {
            CCLOG(@"%@",responseObject);
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                BOOL isJoin = [responseObject[@"is_member"] boolValue];
                if (isJoin) {
                    NIMSession *session = [NIMSession session:self.session.sessionId type:NIMSessionTypeTeam];
                    JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
                    if (weakSelf.tabBarController.selectedIndex == 0) {
                        sessionVC.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:sessionVC animated:YES];
                        UIViewController *root = weakSelf.navigationController.viewControllers[0];
                        weakSelf.navigationController.viewControllers = @[root, sessionVC];
                    }
                    else
                    {
                        [weakSelf.tabBarController setSelectedIndex:0];
                        [[weakSelf.tabBarController.selectedViewController topViewController] setHidesBottomBarWhenPushed:YES];
                        [sessionVC setHidesBottomBarWhenPushed:YES];
                        [weakSelf.tabBarController.selectedViewController pushViewController:sessionVC animated:YES];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        [self.navigationController pushViewController:[[JTJoinTeamViewController alloc] initWithTeam:self.team teamSource:JTTeamSourceFromActivity inviteID:nil] animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareTeam {
    __weak typeof(self)weakSelf = self;
    NIMMessage *groupMessage = [JTMessageMaker messageWithGroup:self.team.teamId name:self.team.teamName icon:self.team.avatarUrl];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"分享到群聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeShareTeam;
        config.needMutiSelected = NO;
        config.source = groupMessage;
        JTTeamSelectViewController *teamListVC = [[JTTeamSelectViewController alloc] initWithConfig:config];
        teamListVC.callBack = ^(NSArray *teamIDs, NSString *content) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:groupMessage toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
            if (content && [content isKindOfClass:[NSString class]] && content.length) {
                NIMMessage *message = [JTMessageMaker messageWithText:content];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil];
            }
        };
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:teamListVC];
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"分享到好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeShareTeam;
        config.needMutiSelected = NO;
        config.source = groupMessage;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        userListVC.callBack = ^(NSArray *yunxinIDs, NSArray *userIDs, NSString *content) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:groupMessage toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
            if (content && [content isKindOfClass:[NSString class]] && content.length) {
                NIMMessage *message = [JTMessageMaker messageWithText:content];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil];
            }
        };
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [weakSelf presentViewController:navigationController animated:YES completion:nil];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)complainTeam {
    __weak typeof(self) weakself = self;
    NSArray *titles = @[@"政治谣言", @"内容违规", @"昵称、签名内容违规", @"广告", @"色情传播", @"非法传销"];
    UIAlertController *alertMore = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *title in titles) {
        [alertMore addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserComplaintsApi) parameters:@{@"object_type" : @"2", @"object" : weakself.team.teamId, @"content" : action.title, @"type" : @"1"} success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"投诉成功，官方会在3个工作日核实处理" yOffset:0];
            } failure:^(NSError *error) {
                
            }];
        }]];
    }
    [alertMore addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertMore animated:YES completion:nil];
}

- (JTTeamInfoTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTTeamInfoTableHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Width)];
        _tableHeadView.delegate = self;
    }
    return _tableHeadView;
}

- (JTTeamInfoNavigationBar *)nagationBar {
    if (!_nagationBar) {
        _nagationBar = [[JTTeamInfoNavigationBar alloc] init];
        _nagationBar.frame = CGRectMake(0, kStatusBarHeight, App_Frame_Width, kTopBarHeight);
        _nagationBar.leftBT.hidden = NO;
        _nagationBar.rightBT.hidden = NO;
        _nagationBar.delegate = self;
    }
    return _nagationBar;
}

- (JTTeamInfoTableFootView *)tableFootView {
    if (!_tableFootView) {
        _tableFootView = [[JTTeamInfoTableFootView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 80)];
        _tableFootView.delegate = self;
    }
    return _tableFootView;
}

- (JTTeamPowerModel *)powerModel
{
    if (!_powerModel) {
        _powerModel = [[JTTeamPowerModel alloc] init];
    }
    return _powerModel;
}

- (NSMutableArray *)propertyArray {
    if (!_propertyArray) {
        _propertyArray = [NSMutableArray array];
    }
    return _propertyArray;
}

- (NSMutableArray *)members {
    if (!_members) {
        _members = [NSMutableArray array];
    }
    return _members;
}

@end
