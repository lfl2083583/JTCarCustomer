//
//  JTReserveFlowViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTReserveFlowDetailTableViewCell.h"
#import "JTReserveFlowViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface JTReserveFlowViewController () <UITableViewDataSource>

@end

@implementation JTReserveFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约流程";
    [self setupComponent];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:30 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setBackgroundColor:WhiteColor];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTReserveFlowDetailTableViewCell class] forCellReuseIdentifier:reserveFlowDetailIdentifer];

}

- (void)setupComponent {
    self.dataArray = [NSMutableArray arrayWithArray:@[@{@"icon" : @"icon_project_seleted", @"title" : @"选择服务项目", @"subtitle" : @"选择项目会适配出您爱车车型的保养商品"},
                                                      @{@"icon" : @"icon_mendian_seleted", @"title" : @"选择门店", @"subtitle" : @"溜车旗下有多家自营店与连锁店，门店选择会使服务更精确"},
                                                      @{@"icon" : @"icon_master_seleted", @"title" : @"选择护理师傅", @"subtitle" : @"在门店选后的基础上，选择护理师傅，溜车为您推荐比较优质并服务到位的师"},
                                                      @{@"icon" : @"icon_time_seleted", @"title" : @"生成预约订单", @"subtitle" : @"生成预约订单后，如果有其他情况，无法实现预约，支持在个人中心取消预约"},
                                                      @{@"icon" : @"icon_submitlist_seleted", @"title" : @"实体店内进行确认订单付款", @"subtitle" : @"由您选择的师傅接待您，为您确认预约订单内的服务项目"},]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTReserveFlowDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reserveFlowDetailIdentifer];
    [self configReserveFlowDetailTableViewCell:cell indexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:reserveFlowDetailIdentifer cacheByIndexPath:indexPath configuration:^(JTReserveFlowDetailTableViewCell *cell) {
        [weakSelf configReserveFlowDetailTableViewCell:cell indexPath:indexPath];
    }];
}

- (void)configReserveFlowDetailTableViewCell:(JTReserveFlowDetailTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    cell.iconView.image = [UIImage imageNamed:[dictionary objectForKey:@"icon"]];
    cell.titleLB.text = [dictionary objectForKey:@"title"];
    cell.subtitleLB.text = [dictionary objectForKey:@"subtitle"];
    cell.flowView.hidden = (indexPath.row == self.dataArray.count-1);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
