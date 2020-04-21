//
//  JTMessageFunsViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMessageFunsViewController.h"
#import "JTSessionFunsTableViewCell.h"
#import "JTSessionViewController.h"
#import "JTCardViewController.h"

#define messageLimit  20

@interface JTMessageFunsViewController () <UITableViewDataSource, JTSessionFunsTableViewCellDelegate>

@property (strong, nonatomic) UILabel *promptLB;

@end

@implementation JTMessageFunsViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}

- (void)rightClick:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要清空所有关注通知吗？" preferredStyle:UIAlertControllerStyleAlert];
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
    [self.navigationItem setTitle:@"关注通知"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:70 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTSessionFunsTableViewCell class] forCellReuseIdentifier:sessionFunsIdentifier];
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
    JTSessionFunsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessionFunsIdentifier];
    cell.attachment = (JTFunsAttachment *)[(NIMCustomObject *)[[self.dataArray objectAtIndex:indexPath.row] messageObject] attachment];
    cell.delegate = self;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTFunsAttachment *attachment = (JTFunsAttachment *)[(NIMCustomObject *)[[self.dataArray objectAtIndex:indexPath.row] messageObject] attachment];
    [self.navigationController pushViewController:[[JTSessionViewController alloc] initWithSession:[NIMSession session:attachment.yunxinId type:NIMSessionTypeP2P]] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sessionFunsTableViewCell:(JTSessionFunsTableViewCell *)sessionFunsTableViewCell clickInAvatarAtUserID:(NSString *)userID
{
    [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:userID] animated:YES];
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
