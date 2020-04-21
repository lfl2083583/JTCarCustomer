//
//  JTMaintenanceExplainViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTSmartMaintenanceTableHeadView.h"
#import "JTMaintenanceExplainTableViewCell.h"
#import "JTMaintenanceExplainViewController.h"

@interface JTMaintenanceExplainViewController () <UITableViewDataSource>

@end

@implementation JTMaintenanceExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"保养项目说明";
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:60 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTMaintenanceExplainTableViewCell class] forCellReuseIdentifier:maintenanceExplainIdentifier];
    [self.tableview registerClass:[JTSmartMaintenanceSectionHeadView class] forHeaderFooterViewReuseIdentifier:smartMaintenanceSectionIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTMaintenanceExplainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:maintenanceExplainIdentifier];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        JTSmartMaintenanceSectionHeadView *sectionHead = [tableView dequeueReusableHeaderFooterViewWithIdentifier:smartMaintenanceSectionIdentifier];
        if (!sectionHead) {
            sectionHead = [[JTSmartMaintenanceSectionHeadView alloc] initWithReuseIdentifier:smartMaintenanceSectionIdentifier];
        }
        sectionHead.titleLB.text = @"空调系统养护（0/1）";
        return sectionHead;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section != 0?36:0.01;
}


@end
