//
//  JTTeamDetailViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTWordItem.h"
#import "JTSwitchTableViewCell.h"
#import "JTMemberInfoTableViewCell.h"
#import "JTTeamMembersTableViewCell.h"

#import "JTCardViewController.h"
#import "JTTeamInfoViewController.h"
#import "JTBaseNavigationController.h"
#import "JTTeamDetailViewController.h"
#import "JTContracSelectViewController.h"
#import "JTTeamAnnounceViewController.h"
#import "JTTeamMembersViewController.h"
#import "JTTeamNikeNameViewController.h"
#import "JTTeamManageViewController.h"
#import "JTTeamManageOperationViewController.h"
#import "JTMessageSearchViewController.h"

static NSString *normalIdentifier = @"UITableViewCell";

@interface JTTeamDetailViewController () <UITableViewDataSource, JTTeamMembersTableViewCellDelegate, JTSwitchTableViewCellDelegate>

@end

@implementation JTTeamDetailViewController

- (void)dealloc {
    CCLOG(@"JTTeamDetailViewController释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamMembersUpdatedNotification object:nil];
}

- (instancetype)initWithSession:(NIMSession *)session {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
        self.powerModel.team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天设置"];
    [self setupComponent];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview registerClass:[JTSwitchTableViewCell class] forCellReuseIdentifier:switchIdentifier];
    [self.tableview registerClass:[JTTeamMembersTableViewCell class] forCellReuseIdentifier:membersIdentifier];
    [self.tableview registerClass:[JTMemberInfoTableViewCell class] forCellReuseIdentifier:infoIdentifier];
    [self.tableview setDataSource:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamMembersUpdatedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupComponent {
    JTWordItem *item1  = [self creatWordItem:@"" indentify:infoIdentifier];
    JTWordItem *item2  = [self creatWordItem:@"群聊成员" indentify:membersIdentifier];
    JTWordItem *item3  = [self creatWordItem:@"我的群名片" indentify:normalIdentifier];
    JTWordItem *item4  = [self creatWordItem:@"群公告" indentify:normalIdentifier];
    JTWordItem *item5  = [self creatWordItem:@"消息免打扰" indentify:switchIdentifier];
    JTWordItem *item6  = [self creatWordItem:@"置顶聊天" indentify:switchIdentifier];
    JTWordItem *item7  = [self creatWordItem:@"显示成员昵称" indentify:switchIdentifier];
    JTWordItem *item8  = [self creatWordItem:@"查找聊天记录" indentify:normalIdentifier];
    JTWordItem *item9  = [self creatWordItem:@"管理群" indentify:normalIdentifier];
    JTWordItem *item10 = [self creatWordItem:@"邀请群成员" indentify:normalIdentifier];
    JTWordItem *item11 = [self creatWordItem:@"移出群成员" indentify:normalIdentifier];
    JTWordItem *item12 = [self creatWordItem:@"禁言" indentify:normalIdentifier];
    JTWordItem *item13 = [self creatWordItem:@"一键添加关注" indentify:normalIdentifier];
    JTWordItem *item15 = [self creatWordItem:self.powerModel.isGroupMain?@"解散本群":@"删除并退出" indentify:normalIdentifier];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:@[@[item1], @[item2], @[item3], @[item4, item5, item6], @[item7, item8]]];
    NSMutableArray *array = [NSMutableArray array];
    if (self.powerModel.isGroupMain)
    {
        [array addObject:item9];
    }
    else
    {
        if (self.powerModel.isInvitePower) {
            [array addObject:item10];
        }
        if (self.powerModel.isRemovePower) {
            [array addObject:item11];
        }
        if (self.powerModel.isBanPower) {
            [array addObject:item12];
        }
        if (self.powerModel.isOneEnterAddPower) {
            [array addObject:item13];
        }
    }
    if (array.count) {
        [self.dataArray addObject:array];
    }
    [self.dataArray addObject:@[item15]];
}

- (JTWordItem *)creatWordItem:(NSString *)title indentify:(NSString *)indentify {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.tagID = indentify;
    return item;
}

- (void)updateTableViewNotification:(NSNotification *)notification
{
    if ([[NIMSDK sharedSDK].teamManager isMyTeam:self.session.sessionId]) {
        self.powerModel.team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        [self setupComponent];
        [self.tableview reloadData];
    } else {
        [[HUDTool shareHUDTool] showHint:@"你已被踢出群聊" yOffset:0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    NSString *indentify = item.tagID;
    if ([indentify isEqualToString:infoIdentifier])
    {
        JTMemberInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
        [cell configMemberInfoCell:self.powerModel.team];
        return cell;
    }
    else if ([indentify isEqualToString:membersIdentifier])
    {
        JTTeamMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:membersIdentifier];
        [cell configMembersWithSession:self.session powerModel:self.powerModel delegate:self];
        return cell;
    }
    else if ([indentify isEqualToString:switchIdentifier])
    {
        JTSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchIdentifier];
        cell.textLabel.text = item.title;
        cell.indexPath = indexPath;
        cell.delegate = self;
        if ([item.title isEqualToString:@"消息免打扰"]) {
            cell.sw.on = ([[NIMSDK sharedSDK].teamManager notifyStateForNewMsg:self.session.sessionId] != NIMTeamNotifyStateAll);
        }
        else if ([item.title isEqualToString:@"置顶聊天"])
        {
            cell.sw.on = [[JTUserInfo shareUserInfo].sessionTops containsObject:self.session.sessionId];
        }
        else if ([item.title isEqualToString:@"显示成员昵称"])
        {
           cell.sw.on = self.powerModel.isShowGroupNickName;
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
            cell.textLabel.font = Font(16);
            cell.detailTextLabel.font = Font(16);
            cell.detailTextLabel.textColor = BlackLeverColor3;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        }
        BOOL flag = [item.title isEqualToString:@"解散本群"] || [item.title isEqualToString:@"删除并退出"];
        cell.textLabel.textAlignment = flag?NSTextAlignmentCenter:NSTextAlignmentLeft;
        cell.accessoryType = flag?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = flag?BlueLeverColor1:BlackLeverColor5;
        cell.textLabel.text = item.title;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else if (indexPath.section == 1) {
        return [JTTeamMembersTableViewCell getCellHeightWithSession:self.session powerModel:self.powerModel isVisitor:NO teamMembersCount:0];
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    NSString *indentify = item.tagID;
    if ([indentify isEqualToString:normalIdentifier])
    {
        if ([item.title isEqualToString:@"解散本群"] || [item.title isEqualToString:@"删除并退出"])
        {
            [self quitTeam];
        }
        else if ([item.title isEqualToString:@"群公告"])
        {
            [self.navigationController pushViewController:[[JTTeamAnnounceViewController alloc] initWithTeam:self.powerModel.team] animated:YES];
        }
        else if ([item.title isEqualToString:@"我的群名片"])
        {
            [self.navigationController pushViewController:[[JTTeamNikeNameViewController alloc] initWithSession:self.session userNick:self.powerModel.myTeamMember.nickname?self.powerModel.myTeamMember.nickname:[JTUserInfo shareUserInfo].userName] animated:YES];
        }
        else if ([item.title isEqualToString:@"查找聊天记录"])
        {
            [self.navigationController pushViewController:[[JTMessageSearchViewController alloc] initWithSession:self.session] animated:YES];
        }
        else if ([item.title isEqualToString:@"管理群"])
        {
            [self.navigationController pushViewController:[[JTTeamManageViewController alloc] initWithSession:self.session powerModel:self.powerModel] animated:YES];
        }
        else if ([item.title isEqualToString:@"邀请群成员"])
        {
            [self teamDetailMembersCell:nil clickTeamOperation:JTTeamOperationTypeAdd];
        }
        else if ([item.title isEqualToString:@"移出群成员"])
        {
            [self teamDetailMembersCell:nil clickTeamOperation:JTTeamOperationTypeDel];
        }
        else if ([item.title isEqualToString:@"禁言"])
        {
            [self.navigationController pushViewController:[[JTTeamManageOperationViewController alloc] initWithSession:self.session teamManageOperationType:TeamManageOperationTypeBan] animated:YES];
        }
        else if ([item.title isEqualToString:@"一键添加关注"])
        {
            __weak typeof(self) weakself = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"一键关注群成员" message:@"确定后将会关注所有群成员" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel                                                                 handler:^(UIAlertAction * action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
                
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(BatchFollowApi) parameters:@{@"group_id": weakself.session.sessionId} success:^(id responseObject, ResponseState state) {
                    [[HUDTool shareHUDTool] showHint:@"已发送"];
                } failure:^(NSError *error) {
                }];
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];            
        }
    }
    else if ([indentify isEqualToString:infoIdentifier])
    {
        [self.navigationController pushViewController:[[JTTeamInfoViewController alloc] initWithTeam:self.powerModel.team] animated:YES];
    }
    else if ([indentify isEqualToString:membersIdentifier])
    {
        [self.navigationController pushViewController:[[JTTeamMembersViewController alloc] initWithTeam:self.powerModel.team] animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == self.dataArray.count-1)?10:0;
}

#pragma mark JTTeamMembersTableViewCellDelegate
- (void)teamDetailMembersCell:(id)membersCell clickTeamUserID:(NSString *)userID {
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userID];
    NSString *uid = [JTUserInfoHandle showUserId:user];
    [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:uid teamID:self.powerModel.team.teamId] animated:YES];
}

- (void)teamDetailMembersCell:(id)membersCell clickTeamOperation:(JTTeamOperationType)operation {
    if (self.powerModel.joinTeamType == 0) {
        [[HUDTool shareHUDTool] showHint:@"群主不允许任何人加入群" yOffset:0];
        return;
    }
    if (!membersCell) {
        __weak typeof(self)weakSelf = self;
        [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            [weakSelf operationTeam:operation teamMembers:members];
        }];
    } else {
        [self operationTeam:operation teamMembers:[membersCell members]];
    }
}

#pragma mark JTSwitchTableViewCellDelegate
- (void)switchTableViewCell:(id)switchTableViewCell didChangeRowAtIndexPath:(NSIndexPath *)indexPath atValue:(BOOL)value {
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    if ([item.title isEqualToString:@"消息免打扰"]) {
        __weak typeof(self) weakself = self;
        [[NIMSDK sharedSDK].teamManager updateNotifyState:!value?NIMTeamNotifyStateAll:NIMTeamNotifyStateNone inTeam:self.session.sessionId completion:^(NSError *error) {
            if (error) {
                [[HUDTool shareHUDTool] showHint:@"设置失败"];
                [[(JTSwitchTableViewCell *)[weakself.tableview cellForRowAtIndexPath:indexPath] sw] setOn:!value];
            }
            else
            {
                [[HUDTool shareHUDTool] showHint:@"设置成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kJTUpdateNotifyForNewMsgNotification object:nil];
            }
        }];
    }
    else if ([item.title isEqualToString:@"置顶聊天"])
    {
        if (value) {
            if (![[JTUserInfo shareUserInfo].sessionTops containsObject:self.session.sessionId]) {
                [[JTUserInfo shareUserInfo].sessionTops addObject:self.session.sessionId];
            }
        }
        else
        {
            if ([[JTUserInfo shareUserInfo].sessionTops containsObject:self.session.sessionId]) {
                [[JTUserInfo shareUserInfo].sessionTops removeObject:self.session.sessionId];
            }
        }
        [[JTUserInfo shareUserInfo] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTUpdateSessionTopNotification object:nil];
    }
    else if ([item.title isEqualToString:@"显示成员昵称"])
    {
        NSMutableDictionary *custom = [NSMutableDictionary dictionary];
        if (self.powerModel.myTeamMember.customInfo && ![self.powerModel.myTeamMember.customInfo isBlankString]) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[self.powerModel.myTeamMember.customInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
            if (info && [info isKindOfClass:[NSDictionary class]]) {
                [custom addEntriesFromDictionary:info];
            }
        }
        [custom setObject:@(value) forKey:@"isShowNickName"];
        __weak typeof(self) weakself = self;
        [[[NIMSDK sharedSDK] teamManager] updateMyCustomInfo:[custom mj_JSONString]
                                                      inTeam:[self.powerModel.team teamId]
                                                  completion:^(NSError * _Nullable error) {
                                                      if (error) {
                                                          [[HUDTool shareHUDTool] showHint:@"修改失败"];
                                                          [[(JTSwitchTableViewCell *)[weakself.tableview cellForRowAtIndexPath:indexPath] sw] setOn:!value];
                                                      }
                                                      else
                                                      {
                                                          weakself.powerModel.isShowGroupNickName = value;
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:kJTUpdateSessionShowNickNameNotification object:nil];
                                                      }
                                                  }];
    }
}

- (void)operationTeam:(JTTeamOperationType)operation teamMembers:(NSArray *)teamMembers {
    if (operation == JTTeamOperationTypeAdd)
    {
        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeAddTeamMember;
        config.needMutiSelected = YES;
        NSMutableArray *memberIDs = [NSMutableArray array];
        for (NIMTeamMember *member in teamMembers) {
            [memberIDs addObject:member.userId];
        }
        config.alreadySelectedMemberId = memberIDs;
        config.teamId = self.powerModel.team.teamId;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else if (operation == JTTeamOperationTypeDel)
    {
        JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeDeleteTeamMember;
        config.needMutiSelected = YES;
        config.members = teamMembers;
        NSMutableArray *memberIDs = [NSMutableArray arrayWithObject:self.powerModel.ownerID];
        if (!self.powerModel.isGroupMain && ![self.powerModel.team.serverCustomInfo isBlankString]) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[self.powerModel.team.serverCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
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
        config.teamId = self.powerModel.team.teamId;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}


- (void)quitTeam {
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.powerModel.isGroupMain?@"解散群聊":@"退出群聊" message:self.powerModel.isGroupMain?@"删除并退出后，将不再接收此群聊信息":@"退出后不会通知群聊中其他成员，且不会再接收此群聊消息" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *host = weakself.powerModel.isGroupMain?kBase_url(BreakTeamApi):kBase_url(QuitTeamApi);
        [[HttpRequestTool sharedInstance] postWithURLString:host parameters:@{@"group_id": weakself.session.sessionId} success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:weakself.powerModel.isGroupMain?@"解散群聊成功":@"退出群聊成功"];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [[HUDTool shareHUDTool] showHint:weakself.powerModel.isGroupMain?@"解散群聊失败":@"退出群聊失败"];
        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (JTTeamPowerModel *)powerModel
{
    if (!_powerModel) {
        _powerModel = [[JTTeamPowerModel alloc] init];
    }
    return _powerModel;
}

@end
