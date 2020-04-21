//
//  JTRescueOrderDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTOrderConfig.h"
#import "JTOrderStatusView.h"
#import "JTOrderSectionHeadView.h"
#import "JTOrderServiceTableViewCell.h"

#import "JTRescueOrderDetailViewController.h"

@interface JTRescueOrderDetailViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTOrderStatusView *tableHeadView;
@property (nonatomic, strong) JTOrderConfig *orderConfig;

@end

@implementation JTRescueOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:50 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setTableHeaderView:self.tableHeadView];
   
    [self.tableview registerClass:[JTOrderServiceTableViewCell class] forCellReuseIdentifier:orderServiceIdentifier];
    [self.tableview registerClass:[JTOrderSectionHeadView class ] forHeaderFooterViewReuseIdentifier:orderSectionHeadIdentifier];
    
    self.orderConfig.orderType = JTOrderTypeLiftTrailer;
    self.orderConfig.order = @{};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != self.orderConfig.itemArray.count) {
        JTOrderServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderServiceIdentifier];
        NSDictionary *dictionary = [self.orderConfig.itemArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:kItems];
        JTWordItem *item = [array objectAtIndex:indexPath.row];
        [cell setUserInteractionEnabled:NO];
        [cell.titleLB setText:item.title];
        [cell.subtitleLB setText:item.subTitle];
        [cell.titleLB setFont:item.titleFont];
        [cell.subtitleLB setFont:item.titleFont];
        return cell;
    }
    else
    {
        static NSString *const normalIdentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
            cell.textLabel.font = Font(14);
            cell.textLabel.textColor = BlackLeverColor5;
        }
        NSString *title = @"金额 ￥55.32 已优惠0元";
        NSString *rangeStr = @"￥55.32";
        [cell.textLabel setText:title];
        [Utility richTextLabel:cell.textLabel fontNumber:Font(17) andRange:[title rangeOfString:rangeStr] andColor:RedLeverColor1];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != self.orderConfig.itemArray.count) {
        NSDictionary *dictionary = [self.orderConfig.itemArray objectAtIndex:section];
        NSArray *array = [dictionary objectForKey:kItems];
        return array.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderConfig.itemArray.count+1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != self.orderConfig.itemArray.count) {
        JTOrderSectionHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:orderSectionHeadIdentifier];
        NSDictionary *dictionary = [self.orderConfig.itemArray objectAtIndex:section];
        [view.titleLB setText:[dictionary objectForKey:kSectionTitle]];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != self.orderConfig.itemArray.count) {
        NSDictionary *dictionary = [self.orderConfig.itemArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:kItems];
        JTWordItem *item = [array objectAtIndex:indexPath.row];
        return item.cellHeight;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section != self.orderConfig.itemArray.count)?50:10;
}

- (JTOrderStatusView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTOrderStatusView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, 116)];
    }
    return _tableHeadView;
}

- (JTOrderConfig *)orderConfig {
    if (!_orderConfig) {
        _orderConfig = [[JTOrderConfig alloc] init];
    }
    return _orderConfig;
}

@end
