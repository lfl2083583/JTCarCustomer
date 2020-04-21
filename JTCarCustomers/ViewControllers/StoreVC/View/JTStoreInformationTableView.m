//
//  JTStoreInformationTableView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreInformationTableView.h"
#import "JTStoreCoverTableViewCell.h"
#import "JTImageTableViewCell.h"

@interface JTStoreInformationTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation JTStoreInformationTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[JTStoreCoverTableViewCell class] forCellReuseIdentifier:storeCoverIndentifier];
        [self registerClass:[JTImageTableViewCell class] forCellReuseIdentifier:imageTableIndentifier];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = BlackLeverColor1;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = self;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.tableFooterView = [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0.01f : 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : MAX(self.model.engineers.count, 1) + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? 106 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JTStoreCoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCoverIndentifier];
        cell.coverImages = self.model.coverImages;
        return cell;
    }
    else
    {
        if (!self.model.engineers.count || indexPath.row < 2) {
            static NSString *cellIdentifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.textLabel.font = Font(16);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.imageView.image = nil;
            cell.textLabel.textColor = BlackLeverColor6;
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"icon_hotlinel"];
                NSString *string = [NSString stringWithFormat:@"商家电话：%@", self.model.phone];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                [attributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:[string rangeOfString:self.model.phone]];
                cell.textLabel.attributedText = attributedString;
            }
            else if (indexPath.row == 1)
            {
                cell.textLabel.text = (self.model.engineers.count>0)?[NSString stringWithFormat:@"门店技师(%ld)", self.model.engineers.count]:@"门店技师";
            }
            else
            {
                cell.textLabel.textColor = BlackLeverColor3;
                cell.textLabel.text = @"暂未上传技师信息~";
            }
            return cell;
        }
        else
        {
            JTImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageTableIndentifier];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.model.phone message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        __weak typeof(self) weakself = self;
        [alertController addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", weakself.model.phone]]];
        }]];
        [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setModel:(JTStoreInformationModel *)model
{
    _model = model;
    [self reloadData];
}
@end
