//
//  JTTeamRemoveViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamRemoveViewController.h"
#import "JTTeamRemoveAttachment.h"
#import "JTUserSimpleTableViewCell.h"
#import "JTGradientButton.h"
#import "JTButtonTableViewFooter.h"

@interface JTTeamRemoveViewController () <UITableViewDataSource>

@property (copy, nonatomic) JTTeamRemoveAttachment *attachment;
@property (strong, nonatomic) JTGradientButton *againBT;
@property (strong, nonatomic) JTButtonTableViewFooter *footer;
@property (strong, nonatomic) UILabel *promptLB;

@end

@implementation JTTeamRemoveViewController

- (instancetype)initWithMessage:(NIMMessage *)message
{
    self = [super init];
    if (self) {
        _message = message;
        _attachment = (JTTeamRemoveAttachment *)[(NIMCustomObject *)[message messageObject] attachment];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"移除群"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:70 sectionHeaderHeight:5 sectionFooterHeight:5];
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
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(NormalJoinTeamApi) parameters:@{@"invite": [JTUserInfo shareUserInfo].userID, @"join_type": @"5", @"group_id": self.attachment.teamId} placeholder:@"" success:^(id responseObject, ResponseState state) {
        
        [weakself.attachment setOperationType:1];
        [weakself.tableview setTableFooterView:weakself.promptLB];
        [[NIMSDK sharedSDK].conversationManager updateMessage:weakself.message forSession:weakself.message.session completion:^(NSError * _Nullable error) {
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? ((indexPath.row == 0) ? 80 : 60) : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
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
        if (indexPath.row == 1) {
            cell.textLabel.text = @"已将你移出群";
            cell.detailTextLabel.text = [Utility showTime:[self.attachment.removeTime doubleValue] showDetail:NO];
        }
        else
        {
            NSString *content = [NSString stringWithFormat:@"处理人 %@", self.attachment.userName];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
            NSRange range = [content rangeOfString:self.attachment.userName];
            [string addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
            cell.textLabel.attributedText = string;
        }
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
        [_againBT setTitle:@"再次申请" forState:UIControlStateNormal];
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
        _promptLB.text = @"已再次申请";
    }
    return _promptLB;
}
@end
