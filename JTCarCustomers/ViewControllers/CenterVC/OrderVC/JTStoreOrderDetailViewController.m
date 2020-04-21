//
//  JTStoreOrderDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTOrderConfig.h"
#import "JTOrderStatusView.h"
#import "JTOrderSectionHeadView.h"
#import "JTOrderMaintanceSectionHeadView.h"
#import "JTOrderGoodsTableViewCell.h"
#import "JTOrderLiveTableViewCell.h"
#import "JTOrderPriceTableViewCell.h"
#import "JTOrderServiceTableViewCell.h"
#import "JTOrderMerchantTableViewCell.h"

#import "JTOrderMaintanceServiceTableViewCell.h"
#import "JTOrderExtensionTableViewCell.h"
#import "JTStoreOrderDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface JTStoreOrderDetailViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTOrderStatusView *tableHeadView;
@property (nonatomic, strong) JTOrderConfig *orderConfig;

@end

@implementation JTStoreOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setTableHeaderView:self.tableHeadView];
    
    [self.tableview registerClass:[JTOrderServiceTableViewCell class] forCellReuseIdentifier:orderServiceIdentifier];
    [self.tableview registerClass:[JTOrderMerchantTableViewCell class] forCellReuseIdentifier:orderMerchantIdentifier];
    [self.tableview registerClass:[JTOrderExtensionTableViewCell class] forCellReuseIdentifier:orderExtensionIdentifier];
    [self.tableview registerClass:[JTOrderLiveTableViewCell class] forCellReuseIdentifier:orderLiveIdentifier];
    [self.tableview registerClass:[JTOrderMaintanceServiceTableViewCell class] forCellReuseIdentifier:orderMaintanceServiceIdentfier];
    [self.tableview registerClass:[JTOrderGoodsTableViewCell class] forCellReuseIdentifier:orderGoodsIdentifier];
    [self.tableview registerClass:[JTOrderPriceTableViewCell class] forCellReuseIdentifier:orderPriceIdentfier];
    [self.tableview registerClass:[JTOrderSectionHeadView class ] forHeaderFooterViewReuseIdentifier:orderSectionHeadIdentifier];
    [self.tableview registerClass:[JTOrderMaintanceSectionHeadView class] forHeaderFooterViewReuseIdentifier:orderMaintanceSectionHeadIdentifier];
    
    self.orderConfig.orderType = JTOrderTypeLiftTrailer;
    self.orderConfig.order = @{};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JTOrderExtensionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderExtensionIdentifier];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        JTOrderMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderMerchantIdentifier];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        JTOrderLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderLiveIdentifier];
        return cell;
    }
    else if (indexPath.section == 3)
    {
        JTOrderMaintanceServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderMaintanceServiceIdentfier];
        return cell;
    }
    else
    {
        if (indexPath.row == 0) {
            JTOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderGoodsIdentifier];
            return cell;
        }
        else
        {
            JTOrderPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderPriceIdentfier];
            return cell;
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 4)?2:1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 103;
    }
    else if (indexPath.section == 1)
    {
        return 70;
    }
    else if (indexPath.section == 2)
    {
        return [tableView fd_heightForCellWithIdentifier:orderLiveIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            
        }];
    }
    else if (indexPath.section == 3)
    {
        return [tableView fd_heightForCellWithIdentifier:orderMaintanceServiceIdentfier cacheByIndexPath:indexPath configuration:^(id cell) {
            
        }];
    }
    else
    {
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:orderGoodsIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
                
            }];
        } else {
            return [tableView fd_heightForCellWithIdentifier:orderPriceIdentfier cacheByIndexPath:indexPath configuration:^(id cell) {
                
            }];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        return 40;
    }
    else
    {
        return 10;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        JTOrderMaintanceSectionHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:orderMaintanceSectionHeadIdentifier];
       
        [view.titleLB setText:@"大保养"];
        [view.statusLB setText:@"已完工"];
        return view;
    }
    return nil;
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
