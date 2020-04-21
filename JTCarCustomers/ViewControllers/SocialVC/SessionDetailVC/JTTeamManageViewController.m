//
//  JTTeamManageViewController.m
//  JTSocial
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTeamManageViewController.h"
#import "JTTeamJoinModeViewController.h"
#import "JTTeamManageOperationViewController.h"
#import "JTContracSelectViewController.h"
#import "JTBaseNavigationController.h"

@interface JTTeamManageViewController () <UITableViewDataSource>

@end

@implementation JTTeamManageViewController

- (instancetype)initWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
        _powerModel = powerModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"群管理"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = Font(16);
        cell.textLabel.textColor = BlackLeverColor5;
        cell.detailTextLabel.font = Font(14);
        cell.detailTextLabel.textColor = BlackLeverColor3;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"加群设置";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"成员权限设置";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"群主权限转让";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"禁言";
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = @"一键关注群成员";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemTitle = [[tableView cellForRowAtIndexPath:indexPath] textLabel].text;
    if ([itemTitle isEqualToString:@"加群设置"]) {
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:[[JTTeamJoinModeViewController alloc] initWithSession:self.session powerModel:self.powerModel] animated:YES];
    }
    else if ([itemTitle isEqualToString:@"成员权限设置"]) {
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:[[JTTeamManageOperationViewController alloc] initWithSession:self.session teamManageOperationType:TeamManageOperationTypePower] animated:YES];
    }
    else if ([itemTitle isEqualToString:@"群主权限转让"]) {
        __weak typeof(self) weakself = self;
        [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError *error, NSArray *members)
         {
             if (!error)
             {
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type == 1"];
                 NSArray *array = [members filteredArrayUsingPredicate:predicate];
                 NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:members];
                 [mutableArray removeObjectsInArray:array];
                 JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
                 config.contactSelectType = JTContactSelectTypeSingle;
                 config.needMutiSelected = NO;
                 config.members = mutableArray;
                 config.teamId = weakself.session.sessionId;
                 JTContracSelectViewController *contracSelectVC = [[JTContracSelectViewController alloc] initWithConfig:config];
                 contracSelectVC.finshBlock = ^(NSArray *yunxinIDs, NSArray *userIDs) {
                     NSString *name = [JTUserInfoHandle showNick:[yunxinIDs firstObject] inSession:weakself.session];
                     NSString *title = [NSString stringWithFormat:@"你确定要将群主转让给%@", name];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel                                                                 handler:^(UIAlertAction * action) {
                     }]];
                     [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
                         [[HUDTool shareHUDTool] showHint:@"请稍等..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
                         [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(MakeOverGroupApi) parameters:@{@"group_id": weakself.session.sessionId, @"owner": [userIDs firstObject]} success:^(id responseObject, ResponseState state) {
                             [[HUDTool shareHUDTool] showHint:@"转让成功"];
                             [weakself.navigationController popViewControllerAnimated:YES];
                         } failure:^(NSError *error) {
                         }];
                     }]];
                     [weakself presentViewController:alertController animated:YES completion:nil];
                 };
                 JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:contracSelectVC];
                 [[Utility currentViewController] presentViewController:navigationController animated:YES completion:nil];
             }
         }];
    }
    else if ([itemTitle isEqualToString:@"禁言"]) {
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:[[JTTeamManageOperationViewController alloc] initWithSession:self.session teamManageOperationType:TeamManageOperationTypeBan] animated:YES];

    }
    else if ([itemTitle isEqualToString:@"一键关注群成员"]) {
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
