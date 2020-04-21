//
//  JTMessageCommentViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#define messageLimit  20
#import "JTSessionCommentActivityTableViewCell.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "JTMessageCommentViewController.h"
#import "JTCardViewController.h"
#import "JTActivityDetailViewController.h"
#import "JTCarLifeDetailViewController.h"

@interface JTMessageCommentViewController () <UITableViewDataSource, JTSessionCommentActivityTableViewCellDelegate>

@property (nonatomic, strong) UILabel *promptLB;

@end

@implementation JTMessageCommentViewController

- (instancetype)initWithSession:(NIMSession *)session {
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (void)rightClick:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认要清空所有评论通知吗？" preferredStyle:UIAlertControllerStyleAlert];
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
    [self.navigationItem setTitle:@"评论通知"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTSessionCommentActivityTableViewCell class] forCellReuseIdentifier:sessionCommentActivityIdentifer];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTSessionCommentActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessionCommentActivityIdentifer];
    cell.attachment = [(NIMCustomObject *)[[self.dataArray objectAtIndex:indexPath.section] messageObject] attachment];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakself = self;
    CGFloat height = [tableView fd_heightForCellWithIdentifier:sessionCommentActivityIdentifer cacheByIndexPath:indexPath configuration:^(JTSessionCommentActivityTableViewCell *cell) {
        cell.attachment = (JTCommentActivityAttachment *)[(NIMCustomObject *)[[weakself.dataArray objectAtIndex:indexPath.section] messageObject] attachment];
    }];
    return height > 80?height:80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark JTSessionCommentActivityTableViewCellDelegate
- (void)sessionCommentActivityTableViewCellAvatarClick:(NSIndexPath *)indexPath {
    id attachment = [(NIMCustomObject *)[[self.dataArray objectAtIndex:indexPath.section] messageObject] attachment];
    if ([attachment isKindOfClass:[JTCommentActivityAttachment class]]) {
        JTCommentActivityAttachment *commentAttachment = attachment;
        [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:commentAttachment.userID] animated:YES];
    } else if ([attachment isKindOfClass:[JTCommentInformationAttachment class]]) {
        JTCommentInformationAttachment *commentAttachment = attachment;
        [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:commentAttachment.userID] animated:YES];
    }
}

- (void)sessionCommentActivityTableViewCellContentClick:(NSIndexPath *)indexPath {
    id attachment = [(NIMCustomObject *)[[self.dataArray objectAtIndex:indexPath.section] messageObject] attachment];
    if ([attachment isKindOfClass:[JTCommentActivityAttachment class]]) {
        JTCommentActivityAttachment *commentAttachment = attachment;
        [self.navigationController pushViewController:[[JTActivityDetailViewController alloc] initWithActivityID:commentAttachment.activityID showComment:YES] animated:YES];
    } else if ([attachment isKindOfClass:[JTCommentInformationAttachment class]]) {
        JTCommentInformationAttachment *commentAttachment = attachment;
        [self.navigationController pushViewController:[[JTCarLifeDetailViewController alloc] initWeburl:commentAttachment.informationUrl navtitle:@"详情"] animated:YES];
    }
}

- (void)sessionCommentActivityTableViewCellCoverClick:(NSIndexPath *)indexPath {
    id attachment = [(NIMCustomObject *)[[self.dataArray objectAtIndex:indexPath.section] messageObject] attachment];
    if ([attachment isKindOfClass:[JTCommentActivityAttachment class]]) {
        JTCommentActivityAttachment *commentAttachment = attachment;
        [self.navigationController pushViewController:[[JTActivityDetailViewController alloc] initWithActivityID:commentAttachment.activityID] animated:YES];
    } else if ([attachment isKindOfClass:[JTCommentInformationAttachment class]]) {
        JTCommentInformationAttachment *commentAttachment = attachment;
        [self.navigationController pushViewController:[[JTCarLifeDetailViewController alloc] initWeburl:commentAttachment.informationUrl navtitle:@"详情"] animated:YES];
    }
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
