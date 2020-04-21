//
//  JTMessageTeamViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMessageTeamViewController.h"
#import "JTSessionTeamTableViewCell.h"

#import "JTTeamInviteViewController.h"
#import "JTTeamInviteRefuseViewController.h"
#import "JTTeamApplyViewController.h"
#import "JTTeamApplyRefuseViewController.h"
#import "JTTeamRemoveViewController.h"
#import "JTTeamDismissViewController.h"

#define messageLimit  20

@interface JTMessageTeamViewController () <UITableViewDataSource>

@property (strong, nonatomic) UILabel *promptLB;

@end

@implementation JTMessageTeamViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.dataArray.count > 0) {
        [self.tableview reloadData];
    }
    [super viewWillAppear:animated];
}

- (void)rightClick:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要清空所有群通知吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }]];
    __weak typeof(self) weakself = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"全部清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakself cleaner];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.promptLB];
    [self.navigationItem setTitle:@"群通知"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:80 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTSessionTeamTableViewCell class] forCellReuseIdentifier:sessionTeamIdentifier];
    [self setShowTableRefreshFooter:YES];
    [self staticRefreshFirstTableListData];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)]];
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
}

- (void)getListData:(void (^)(void))requestComplete
{
    NIMMessage *currentMessage = (self.dataArray && self.dataArray.count > 0) ? self.dataArray.lastObject : nil;
    NSArray *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:self.session
                                                                            message:currentMessage
                                                                              limit:messageLimit];
    [self.dataArray addObjectsFromArray:messages.reverseObjectEnumerator.allObjects];
    
    [super getListData:requestComplete];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSessionTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessionTeamIdentifier];
    cell.attachment = [(NIMCustomObject *)[[self.dataArray objectAtIndex:indexPath.row] messageObject] attachment];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMMessage *message = [self.dataArray objectAtIndex:indexPath.row];
    id<NIMCustomAttachment> attachment = [(NIMCustomObject *)[message messageObject] attachment];
    if ([attachment isKindOfClass:[JTTeamInviteAttachment class]]) {
        [self.navigationController pushViewController:[[JTTeamInviteViewController alloc] initWithMessage:message] animated:YES];
    }
    else if ([attachment isKindOfClass:[JTTeamInviteRefuseAttachment class]]) {
        [self.navigationController pushViewController:[[JTTeamInviteRefuseViewController alloc] initWithMessage:message] animated:YES];
    }
    else if ([attachment isKindOfClass:[JTTeamApplyAttachment class]]) {
        [self.navigationController pushViewController:[[JTTeamApplyViewController alloc] initWithMessage:message] animated:YES];
    }
    else if ([attachment isKindOfClass:[JTTeamApplyRefuseAttachment class]]) {
        [self.navigationController pushViewController:[[JTTeamApplyRefuseViewController alloc] initWithMessage:message] animated:YES];
    }
    else if ([attachment isKindOfClass:[JTTeamRemoveAttachment class]]) {
        [self.navigationController pushViewController:[[JTTeamRemoveViewController alloc] initWithMessage:message] animated:YES];
    }
    else if ([attachment isKindOfClass:[JTTeamDismissAttachment class]]) {
        [self.navigationController pushViewController:[[JTTeamDismissViewController alloc] initWithMessage:message] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView setEditing:NO animated:YES];
        [[NIMSDK sharedSDK].conversationManager deleteMessage:[self.dataArray objectAtIndex:indexPath.row]];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if (self.dataArray.count == 0) {
            [self staticRefreshFirstTableListData];
            if (self.dataArray.count == 0) {
                [self cleaner];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)cleaner
{
    NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
    option.removeSession = YES;
    option.removeTable = YES;
    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:self.session option:option];
    [[HUDTool shareHUDTool] showHint:@"已清空"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCleanSessionMessageNotification object:nil];
    [self.dataArray removeAllObjects];
    [self.tableview reloadData];
    [self.tableview setHidden:YES];
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] init];
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.font = Font(16);
        _promptLB.textAlignment = NSTextAlignmentCenter;
        _promptLB.text = @"暂无通知~";
        _promptLB.frame = CGRectMake(0, 200, App_Frame_Width, 20);
    }
    return _promptLB;
}
@end
