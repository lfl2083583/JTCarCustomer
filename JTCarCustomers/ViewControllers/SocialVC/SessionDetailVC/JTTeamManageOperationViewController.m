//
//  JTTeamManageOperationViewController.m
//  JTSocial
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTeamManageOperationViewController.h"
#import "JTTeamManageOperationTableViewCell.h"
#import "JTSwitchTableViewCell.h"
#import "CLAlertController.h"

@interface JTTeamManageOperationViewController () <UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, JTSwitchTableViewCellDelegate>
{
    NSIndexPath *__selectIndexPath;
}

@property (nonatomic, strong) NIMTeam *team;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchArr;

@property (nonatomic, strong) NSMutableArray *inviteuserArr;
@property (nonatomic, strong) NSMutableArray *removeuserArr;
@property (nonatomic, strong) NSMutableArray *banuserArr;
@property (nonatomic, strong) NSMutableArray *batchadduserArr;

@property (nonatomic, strong) NSMutableDictionary *beBanedDict;
@end

@implementation JTTeamManageOperationViewController

- (instancetype)initWithSession:(NIMSession *)session teamManageOperationType:(TeamManageOperationType)teamManageOperationType
{
    self = [super init];
    if (self) {
        _session = session;
        _teamManageOperationType = teamManageOperationType;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamMembersUpdatedNotification object:nil];
}

- (void)updateTeamConfig
{
    self.team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    [self.inviteuserArr removeAllObjects];
    [self.removeuserArr removeAllObjects];
    [self.banuserArr removeAllObjects];
    [self.batchadduserArr removeAllObjects];
    [self.beBanedDict removeAllObjects];
    
    if (self.team.serverCustomInfo && ![self.team.serverCustomInfo isBlankString])
    {
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[self.team.serverCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
        if (info && [info isKindOfClass:[NSDictionary class]]) {
            
            if ([info objectForKey:@"invite_user"] && [info[@"invite_user"] isKindOfClass:[NSArray class]]) {
                [self.inviteuserArr addObjectsFromArray:info[@"invite_user"]];
            }
            if ([info objectForKey:@"remove_user"] && [info[@"remove_user"] isKindOfClass:[NSArray class]]) {
                [self.removeuserArr addObjectsFromArray:info[@"remove_user"]];
            }
            if ([info objectForKey:@"ban_chat"] && [info[@"ban_chat"] isKindOfClass:[NSArray class]]) {
                [self.banuserArr addObjectsFromArray:info[@"ban_chat"]];
            }
            if ([info objectForKey:@"batch_follow"] && [info[@"batch_follow"] isKindOfClass:[NSArray class]]) {
                [self.batchadduserArr addObjectsFromArray:info[@"batch_follow"]];
            }
            if ([info objectForKey:@"ban"] && [info[@"ban"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *source in info[@"ban"]) {
                    [self.beBanedDict setObject:source[@"time"] forKey:source[@"uid"]];
                }
            }
        }
    }
    
    __weak typeof(self) weakself = self;
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError *error, NSArray *members) {
        [weakself.dataArray removeAllObjects];
        for (NIMTeamMember *member in members) {
            if ([weakself.team.owner isEqualToString:[JTUserInfo shareUserInfo].userID]) {
                if (![member.userId isEqualToString:[JTUserInfo shareUserInfo].userID]) {
                    [weakself.dataArray addObject:[weakself configItem:member]];
                }
            }
            else
            {
                if (![member.userId isEqualToString:weakself.team.owner] && ![weakself.banuserArr containsObject:@([member.userId integerValue])]) {
                    [weakself.dataArray addObject:[weakself configItem:member]];
                }
            }
        }
        [weakself.tableview reloadData];
    }];
}

- (NSDictionary *)configItem:(NIMTeamMember *)member
{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:member.userId];
    NSString *userID = [JTUserInfoHandle showUserId:user];
    return @{@"avatar": [NSString stringWithFormat:@"%@", user.userInfo.avatarUrl], @"name": [JTUserInfoHandle showNick:user member:member], @"userID": userID, @"yunxinID": user.userId};;
}

- (void)updateTableViewNotification:(NSNotification *)notification
{
    [self updateTeamConfig];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.teamManageOperationType == TeamManageOperationTypePower) {
        self.navigationItem.title = @"群权限";
    }
    else
    {
        self.navigationItem.title = @"禁言";
    }
    [self createTalbeView:UITableViewStylePlain rowHeight:60];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTTeamManageOperationTableViewCell class] forCellReuseIdentifier:teamManageOperationIdentifier];
    [self.tableview registerClass:[JTSwitchTableViewCell class] forCellReuseIdentifier:switchIdentifier];
    [self.tableview setTableHeaderView:self.searchController.searchBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamMembersUpdatedNotification object:nil];
    [self updateTeamConfig];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.searchController.active)?self.searchArr.count:self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + ((__selectIndexPath && __selectIndexPath.section == section) ? 4 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0)?60:44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *source = [(self.searchController.active)?self.searchArr:self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {

        JTTeamManageOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamManageOperationIdentifier];
        [cell.avatar setAvatarByUrlString:[source[@"avatar"] avatarHandleWithSquare:80] defaultImage:DefaultSmallAvatar];
        [cell.topLabel setText:source[@"name"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.teamManageOperationType == TeamManageOperationTypePower) {
            cell.teamBanShowPromptType = TeamBanShowPromptTypeArrow;
        }
        else
        {
            if ([self.beBanedDict objectForKey:source[@"userID"]] && [[self.beBanedDict objectForKey:source[@"userID"]] integerValue] > [[NSDate date] timeIntervalSince1970]) {
                cell.terminalTime = [[self.beBanedDict objectForKey:source[@"userID"]] integerValue];
            }
            else
            {
                cell.teamBanShowPromptType = TeamBanShowPromptTypeNormal;
            }
        }
        return cell;
    }
    else
    {
        JTSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchIdentifier];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.backgroundColor = BlackLeverColor1;
        if (indexPath.row == 1) {
            cell.textLabel.text = @"邀请群成员";
            cell.sw.on = [self.inviteuserArr containsObject:source[@"userID"]];
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"移除群成员";
            cell.sw.on = [self.removeuserArr containsObject:source[@"userID"]];
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"禁言";
            cell.sw.on = [self.banuserArr containsObject:source[@"userID"]];
        }
        else if (indexPath.row == 4) {
            cell.textLabel.text = @"一键添加好友";
            cell.sw.on = [self.batchadduserArr containsObject:source[@"userID"]];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.teamManageOperationType == TeamManageOperationTypePower) {
            if (__selectIndexPath && __selectIndexPath.section == indexPath.section) {
                __selectIndexPath = nil;
            }
            else
            {
                __selectIndexPath = indexPath;
            }
            [self.tableview reloadData];
        }
        else
        {
            NSDictionary *source = [(self.searchController.active)?self.searchArr:self.dataArray objectAtIndex:indexPath.section];
            if ([self.beBanedDict objectForKey:source[@"userID"]] && [[self.beBanedDict objectForKey:source[@"userID"]] integerValue] > [[NSDate date] timeIntervalSince1970]) {

                CLAlertController *alertMore = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
                __weak typeof(self) weakself = self;
                [alertMore addAction:[CLAlertModel actionWithTitle:@"取消禁言" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {

                    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GroupBatChatApi) parameters:@{@"group_id": weakself.session.sessionId, @"ban_time": @"0", @"ban_uid": source[@"userID"], @"type": @"0"} success:^(id responseObject, ResponseState state) {
                        [[HUDTool shareHUDTool] showHint:@"取消禁言成功"];
                    } failure:^(NSError *error) {
                    }];
                }]];
                [alertMore addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
                }]];
                [self presentToViewController:alertMore completion:nil];
            }
            else
            {
                __weak typeof(self) weakself = self;
                CLAlertController *alert = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
                [alert addAction:[CLAlertModel actionWithTitle:@"10分钟" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                    [weakself requestBanUserID:source[@"userID"] banMinute:@"10"];
                }]];
                [alert addAction:[CLAlertModel actionWithTitle:@"30分钟" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                    [weakself requestBanUserID:source[@"userID"] banMinute:@"30"];
                }]];
                [alert addAction:[CLAlertModel actionWithTitle:@"1小时" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                    [weakself requestBanUserID:source[@"userID"] banMinute:@"60"];
                }]];
                [alert addAction:[CLAlertModel actionWithTitle:@"一天" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                    [weakself requestBanUserID:source[@"userID"] banMinute:@"1440"];
                }]];
                [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
                }]];
                [self presentToViewController:alert completion:nil];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestBanUserID:(NSString *)userID banMinute:(NSString *)banMinute
{
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GroupBatChatApi) parameters:@{@"group_id": self.session.sessionId, @"ban_time": banMinute, @"ban_uid": userID, @"type": @"1"} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"禁言设置成功" yOffset:0];
    } failure:^(NSError *error) {
    }];
}

- (void)switchTableViewCell:(id)switchTableViewCell didChangeRowAtIndexPath:(NSIndexPath *)indexPath atValue:(BOOL)value
{
    NSDictionary *source = [(self.searchController.active)?self.searchArr:self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 1) {
        if (!value && [self.inviteuserArr containsObject:source[@"userID"]]) {
            [self.inviteuserArr removeObject:source[@"userID"]];
        }
        else
        {
            [self.inviteuserArr addObject:source[@"userID"]];
        }
    }
    else if (indexPath.row == 2) {
        if (!value && [self.removeuserArr containsObject:source[@"userID"]]) {
            [self.removeuserArr removeObject:source[@"userID"]];
        }
        else
        {
            [self.removeuserArr addObject:source[@"userID"]];
        }
    }
    else if (indexPath.row == 3) {
        if (!value && [self.banuserArr containsObject:source[@"userID"]]) {
            [self.banuserArr removeObject:source[@"userID"]];
        }
        else
        {
            [self.banuserArr addObject:source[@"userID"]];
        }
    }
    else if (indexPath.row == 4) {
        if (!value && [self.batchadduserArr containsObject:source[@"userID"]]) {
            [self.batchadduserArr removeObject:source[@"userID"]];
        }
        else
        {
            [self.batchadduserArr addObject:source[@"userID"]];
        }
    }

    NSString *inviteuser   = [self.inviteuserArr containsObject:source[@"userID"]]?@"1":@"0";
    NSString *removeuser   = [self.removeuserArr containsObject:source[@"userID"]]?@"1":@"0";
    NSString *banuser      = [self.banuserArr containsObject:source[@"userID"]]?@"1":@"0";
    NSString *batchadduser = [self.batchadduserArr containsObject:source[@"userID"]]?@"1":@"0";

    NSDictionary *parameters = @{@"group_id": self.session.sessionId,
                                 @"invite_user": inviteuser,
                                 @"remove_user": removeuser,
                                 @"ban_chat": banuser,
                                 @"batch_follow": batchadduser,
                                 @"fid": source[@"userID"],
                             };

    [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SetGroupPermissionsApi) parameters:parameters success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"设置成功"];
    } failure:^(NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.delegate = self;
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IOS11?56:44);
        _searchController.dimsBackgroundDuringPresentation = NO;
    }
    return _searchController;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    __selectIndexPath = nil;
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    __selectIndexPath = nil;
    NSLog(@"%f",self.view.frame.origin.y);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchController.searchBar.text];
    [self.searchArr removeAllObjects];
    [self.searchArr addObjectsFromArray:[[self.dataArray filteredArrayUsingPredicate:searchPredicate] mutableCopy]];
    [self.tableview reloadData];
}

- (NSMutableArray *)searchArr
{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

- (NSMutableArray *)inviteuserArr
{
    if (!_inviteuserArr) {
        _inviteuserArr = [NSMutableArray array];
    }
    return _inviteuserArr;
}

- (NSMutableArray *)removeuserArr
{
    if (!_removeuserArr) {
        _removeuserArr = [NSMutableArray array];
    }
    return _removeuserArr;
}

- (NSMutableArray *)banuserArr
{
    if (!_banuserArr) {
        _banuserArr = [NSMutableArray array];
    }
    return _banuserArr;
}

- (NSMutableArray *)batchadduserArr
{
    if (!_batchadduserArr) {
        _batchadduserArr = [NSMutableArray array];
    }
    return _batchadduserArr;
}

- (NSMutableDictionary *)beBanedDict
{
    if (!_beBanedDict) {
        _beBanedDict = [NSMutableDictionary dictionary];
    }
    return _beBanedDict;
}
@end
