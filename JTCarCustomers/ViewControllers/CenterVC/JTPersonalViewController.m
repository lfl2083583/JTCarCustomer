//
//  JTPersonalViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTPersonalViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTRealCertificationViewController.h"
#import "JTTeamMembersViewController.h"
#import "JTAliCertificationViewController.h"

@interface JTPersonalViewController () <UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;

@end

@implementation JTPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kTopBarHeight+kStatusBarHeight+40, App_Frame_Width, APP_Frame_Height-kTopBarHeight-kStatusBarHeight-40) rowHeight:60 sectionHeaderHeight:0 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self setupComponent];
    [self.tableview reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)setupComponent{
    NSString *realTitle;
    if ([JTUserInfo shareUserInfo].userAuthStatus == JTRealCertificationStatusUnAuth) {
        realTitle = @"未认证";
    } else if ([JTUserInfo shareUserInfo].userAuthStatus == JTRealCertificationStatusApproved) {
        realTitle = @"认证中";
    } else if ([JTUserInfo shareUserInfo].userAuthStatus == JTRealCertificationStatusAudit) {
        realTitle = @"审核中";
    } else {
        realTitle = @"认证失败";
    }
    JTWordItem *realCertificationItem = [self createItemWithTitle:@"实名认证" subtitle:realTitle];
    JTWordItem *sesameCertificationItem = [self createItemWithTitle:@"芝麻认证" subtitle:@"未认证"];
    self.dataArray = [NSMutableArray arrayWithArray:@[realCertificationItem, sesameCertificationItem]];
    
}

- (JTWordItem *)createItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.subTitle = subtitle;
    item.titleFont = Font(16);
    item.titleColor = BlackLeverColor5;
    item.subTitleFont = Font(16);
    item.subTitleColor = BlackLeverColor3;
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JTWordItem *item = self.dataArray[indexPath.row];
    static NSString *Indentify = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Indentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Indentify];
        cell.textLabel.font = item.titleFont;
        cell.textLabel.textColor = item.titleColor;
        cell.detailTextLabel.textColor = item.subTitleColor;
        cell.detailTextLabel.font = item.subTitleFont;
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(53, 60 - 0.5, App_Frame_Width - 53, 0.5)];
        bottomView.backgroundColor = BlackLeverColor2;
        [cell.contentView addSubview:bottomView];
    }
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.row];
    if ([item.title isEqualToString:@"实名认证"])
    {
        [self.navigationController pushViewController:[[JTRealCertificationViewController alloc] initWithRealCertificationStatus:[JTUserInfo shareUserInfo].userAuthStatus] animated:YES];
    }
    else if ([item.title isEqualToString:@"芝麻认证"])
    {
        [self.navigationController pushViewController:[[JTAliCertificationViewController alloc] init] animated:YES];
    }
        
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 40)];
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, App_Frame_Width-15, 40)];
        titleLB.font = Font(24);
        titleLB.text = @"身份认证中心";
        [_headView addSubview:titleLB];
    }
    return _headView;
}

@end

