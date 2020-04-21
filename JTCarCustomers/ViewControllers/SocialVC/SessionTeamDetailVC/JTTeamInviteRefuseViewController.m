//
//  JTTeamInviteRefuseViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamInviteRefuseViewController.h"
#import "JTTeamInviteRefuseAttachment.h"
#import "JTUserSimpleTableViewCell.h"
#import "JTGradientButton.h"
#import "JTButtonTableViewFooter.h"

@interface JTTeamInviteRefuseViewController () <UITableViewDataSource>

@property (copy, nonatomic) JTTeamInviteRefuseAttachment *attachment;
@property (strong, nonatomic) JTGradientButton *againBT;
@property (strong, nonatomic) JTButtonTableViewFooter *footer;
@property (strong, nonatomic) UILabel *promptLB;

@end

@implementation JTTeamInviteRefuseViewController

- (instancetype)initWithMessage:(NIMMessage *)message
{
    self = [super init];
    if (self) {
        _message = message;
        _attachment = (JTTeamInviteRefuseAttachment *)[(NIMCustomObject *)[message messageObject] attachment];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"拒绝邀请"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:70 sectionHeaderHeight:5 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTUserSimpleTableViewCell class] forCellReuseIdentifier:userSimpleCellIdentifier];
    [self.tableview setTableFooterView:self.footer];
    if (self.attachment.operationType == 0) {
        self.tableview.tableFooterView = self.footer;
    }
    else
    {
        self.tableview.tableFooterView = self.promptLB;
    }
}

- (void)againlick:(id)sender
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(InviteUserApi) parameters:@{@"uids": self.attachment.userId, @"group_id": self.attachment.teamId} placeholder:@"" success:^(id responseObject, ResponseState state) {
        
        [weakself.attachment setOperationType:1];
        [weakself.tableview setTableFooterView:weakself.promptLB];
        [[NIMSDK sharedSDK].conversationManager updateMessage:weakself.message forSession:weakself.message.session completion:^(NSError * _Nullable error) {
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? 80 : 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JTUserSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userSimpleCellIdentifier];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(16);
            cell.textLabel.textColor = BlackLeverColor5;
            cell.detailTextLabel.font = Font(12);
            cell.detailTextLabel.textColor = BlackLeverColor3;
        }
        cell.textLabel.text = @"拒绝加入群聊";
        cell.detailTextLabel.text = [Utility showTime:[self.attachment.inviteRefuseTime doubleValue] showDetail:NO];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (JTGradientButton *)againBT
{
    if (!_againBT) {
        _againBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        [_againBT setTitle:@"再次邀请" forState:UIControlStateNormal];
        [_againBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_againBT.titleLabel setFont:Font(16)];
        [_againBT addTarget:self action:@selector(againlick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againBT;
}

- (JTButtonTableViewFooter *)footer
{
    if (!_footer) {
        _footer = [[JTButtonTableViewFooter alloc] init];
        _footer.buttons = @[self.againBT];
        _footer.column = 1;
    }
    return _footer;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] init];
        _promptLB.textAlignment = NSTextAlignmentCenter;
        _promptLB.font = Font(16);
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.numberOfLines = 0;
        _promptLB.frame = CGRectMake(0, 0, App_Frame_Width, 50);
        _promptLB.text = @"已再次邀请";
    }
    return _promptLB;
}


@end
