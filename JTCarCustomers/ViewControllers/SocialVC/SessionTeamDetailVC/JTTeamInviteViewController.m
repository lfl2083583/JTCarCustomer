//
//  JTTeamInviteViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamInviteViewController.h"
#import "JTTeamInviteAttachment.h"
#import "JTUserSimpleTableViewCell.h"
#import "JTGradientButton.h"
#import "JTButtonTableViewFooter.h"

@interface JTTeamInviteViewController () <UITableViewDataSource>

@property (copy, nonatomic) JTTeamInviteAttachment *attachment;
@property (strong, nonatomic) UIButton *refuseBT;
@property (strong, nonatomic) JTGradientButton *agreeBT;
@property (strong, nonatomic) JTButtonTableViewFooter *footer;
@property (strong, nonatomic) UILabel *promptLB;
@end

@implementation JTTeamInviteViewController

- (instancetype)initWithMessage:(NIMMessage *)message
{
    self = [super init];
    if (self) {
        _message = message;
        _attachment = (JTTeamInviteAttachment *)[(NIMCustomObject *)[message messageObject] attachment];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"加群邀请"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:70 sectionHeaderHeight:5 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTUserSimpleTableViewCell class] forCellReuseIdentifier:userSimpleCellIdentifier];
    if (self.attachment.operationType == 0) {
        self.tableview.tableFooterView = self.footer;
    }
    else
    {
        self.tableview.tableFooterView = self.promptLB;
        self.promptLB.text = [NSString stringWithFormat:@"已%@该邀请", (self.attachment.operationType == 1) ? @"同意" : @"拒绝"];
    }
}

- (void)refuseClick:(id)sender
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserOperateInviteApi) parameters:@{@"type": @"0", @"invite": self.attachment.inviteId, @"join_type": self.attachment.joinType, @"group_id": self.attachment.teamId} placeholder:@"" success:^(id responseObject, ResponseState state) {

        [weakself.attachment setOperationType:2];
        [weakself.tableview setTableFooterView:weakself.promptLB];
        [weakself.promptLB setText:@"已拒绝该邀请"];
        [[NIMSDK sharedSDK].conversationManager updateMessage:weakself.message forSession:weakself.message.session completion:^(NSError * _Nullable error) {
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)agreeClick:(id)sender
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserOperateInviteApi) parameters:@{@"type": @"1", @"invite": self.attachment.inviteId, @"join_type": self.attachment.joinType, @"group_id": self.attachment.teamId} placeholder:@"" success:^(id responseObject, ResponseState state) {
        
        [weakself.attachment setOperationType:1];
        [weakself.tableview setTableFooterView:weakself.promptLB];
        [weakself.promptLB setText:@"已同意该邀请"];
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
        NSString *content = [NSString stringWithFormat:@"邀请你加入群组 %@", self.attachment.teamName];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
        NSRange range = [content rangeOfString:self.attachment.teamName];
        [string addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
        cell.textLabel.attributedText = string;
        cell.detailTextLabel.text = [Utility showTime:[self.attachment.inviteTime doubleValue] showDetail:NO];
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

- (UIButton *)refuseBT
{
    if (!_refuseBT) {
        _refuseBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refuseBT setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_refuseBT.titleLabel setFont:Font(16)];
        [_refuseBT.layer setCornerRadius:22.5];
        [_refuseBT.layer setBorderWidth:.5];
        [_refuseBT.layer setBorderColor:BlackLeverColor3.CGColor];
        [_refuseBT addTarget:self action:@selector(refuseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refuseBT;
}

- (JTGradientButton *)agreeBT
{
    if (!_agreeBT) {
        _agreeBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        [_agreeBT setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_agreeBT.titleLabel setFont:Font(16)];
        [_agreeBT addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBT;
}

- (JTButtonTableViewFooter *)footer
{
    if (!_footer) {
        _footer = [[JTButtonTableViewFooter alloc] init];
        _footer.buttons = @[self.refuseBT, self.agreeBT];
        _footer.column = 2;
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
    }
    return _promptLB;
}

@end
