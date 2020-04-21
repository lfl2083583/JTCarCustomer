//
//  JTMyLoveCarViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMyLoveCarViewController.h"
#import "UINavigationBar+Awesome.h"
#import "JTMyLoveCarHeaderView.h"
#import "ZTTableViewHeaderFooterView.h"
#import "JTCarManageViewController.h"
#import "JTMaintenanceLogViewController.h"
#import "JTMaintenanceManualViewController.h"

@interface JTMyLoveCarViewController () <UITableViewDataSource, JTMyLoveCarHeaderViewDelegate>

@property (nonatomic, strong) UILabel *titleLB;
@property (strong, nonatomic) JTMyLoveCarHeaderView *headerView;
@end

@implementation JTMyLoveCarViewController

- (instancetype)initWithCurrentIndex:(NSInteger)currentIndex
{
    self = [super init];
    if (self) {
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[JTUserInfo shareUserInfo].myCarList];
    [self setCurrentIndex:0];
    [self.tableview reloadData];
    [self.headerView reloadData:self.dataArray scrollToIndex:self.currentIndex];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar zt_setBlackLineHidden:YES];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: Font(14), NSForegroundColorAttributeName: WhiteColor} forState:UIControlStateNormal];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar zt_setBlackLineHidden:NO];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: Font(14), NSForegroundColorAttributeName: BlackLeverColor3} forState:UIControlStateNormal];
    [super viewWillDisappear:animated];
}

- (void)rightClick:(id)sender
{
    [self.navigationController pushViewController:[[JTCarManageViewController alloc] init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleLB;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理车型" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.leftBarButtonItem.tintColor = WhiteColor;
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeFullScreen rowHeight:60 sectionHeaderHeight:35 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setTableHeaderView:self.headerView];
    [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
    if (self.dataArray.count == 0) {
        footer.promptLB.textColor = BlackLeverColor3;
        footer.promptLB.font = Font(14);
        footer.promptLB.text = @"你还未添加爱车-暂时不可查看以下记录";
    }
    else
    {
        footer.promptLB.textColor = BlueLeverColor1;
        footer.promptLB.font = BoldFont(18);
        footer.promptLB.text = [(JTCarModel *)[self.dataArray objectAtIndex:self.currentIndex] model];
    }
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(16);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"消费记录";
        cell.textLabel.textColor = (self.dataArray.count == 0)?BlackLeverColor3:BlackLeverColor6;
        cell.imageView.image = (self.dataArray.count == 0)?[UIImage imageNamed:@"icon_unConsume"]:[UIImage imageNamed:@"icon_consume"];
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"保养记录";
        cell.textLabel.textColor = (self.dataArray.count == 0)?BlackLeverColor3:BlackLeverColor6;
        cell.imageView.image = (self.dataArray.count == 0)?[UIImage imageNamed:@"icon_unMaintain"]:[UIImage imageNamed:@"icon_maintain"];
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"保养手册";
        cell.textLabel.textColor = (self.dataArray.count == 0)?BlackLeverColor3:BlackLeverColor6;
        cell.imageView.image = (self.dataArray.count == 0)?[UIImage imageNamed:@"icon_unMaintainRecord"]:[UIImage imageNamed:@"icon_maintainRecord"];
    }
    else
    {
        cell.textLabel.text = @"到店检查记录";
        cell.textLabel.textColor = (self.dataArray.count == 0)?BlackLeverColor3:BlackLeverColor6;
        cell.imageView.image = (self.dataArray.count == 0)?[UIImage imageNamed:@"icon_unCheckRecord"]:[UIImage imageNamed:@"icon_checkRecord"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > self.currentIndex) {
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row == 1) {
            [self.navigationController pushViewController:[[JTMaintenanceLogViewController alloc] initWithCarModel:[self.dataArray objectAtIndex:self.currentIndex]] animated:YES];
        }
        else if (indexPath.row == 2) {
            [self.navigationController pushViewController:[[JTMaintenanceManualViewController alloc] initWithModel:[self.dataArray objectAtIndex:self.currentIndex]] animated:YES];
        }
        else
        {
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)myLoveCarHeaderView:(JTMyLoveCarHeaderView *)myLoveCarHeaderView didScrollToIndex:(NSInteger)currentIndex
{
    if (_currentIndex != currentIndex) {
        [self setCurrentIndex:currentIndex];
        [self.tableview reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.navigationController.navigationBar zt_setBackgroundColor:[BlueLeverColor1 colorWithAlphaComponent:MIN(1, scrollView.contentOffset.y / self.tableview.tableHeaderView.height)]];
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(18);
        _titleLB.textColor = WhiteColor;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = @"我的爱车";
        [_titleLB sizeToFit];
    }
    return _titleLB;
}

- (JTMyLoveCarHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTMyLoveCarHeaderView alloc] initWithMyDelegate:self];
    }
    return _headerView;
}

@end
