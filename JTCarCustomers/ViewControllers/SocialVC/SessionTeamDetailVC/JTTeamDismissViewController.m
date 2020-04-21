//
//  JTTeamDismissViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamDismissViewController.h"
#import "JTTeamDismissAttachment.h"
#import "JTUserSimpleTableViewCell.h"
#import "JTGradientButton.h"
#import "JTButtonTableViewFooter.h"

@interface JTTeamDismissViewController () <UITableViewDataSource>

@property (copy, nonatomic) JTTeamDismissAttachment *attachment;

@end

@implementation JTTeamDismissViewController

- (instancetype)initWithMessage:(NIMMessage *)message
{
    self = [super init];
    if (self) {
        _message = message;
        _attachment = (JTTeamDismissAttachment *)[(NIMCustomObject *)[message messageObject] attachment];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"解散群"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:70 sectionHeaderHeight:5 sectionFooterHeight:5];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTUserSimpleTableViewCell class] forCellReuseIdentifier:userSimpleCellIdentifier];
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
            cell.detailTextLabel.text = [Utility showTime:[self.attachment.dismissTime doubleValue] showDetail:NO];
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

@end
