//
//  JTOrderListViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
typedef NS_ENUM(NSUInteger, JTOrderListType) {
    
    JTOrderListTypeAll           = 0, // 全部的订单
    JTOrderListTypeInProgress    = 1, // 进行中的订单
    JTOrderListTypeComplete      = 2, // 已完成的订单
    JTOrderListTypeCancel        = 3, // 已取消的订单
};


@interface JTOrderListViewController : BaseRefreshViewController

@property (nonatomic, weak) UIViewController *parentController;
@property (nonatomic, assign) JTOrderListType orderListType;

- (instancetype)initWithOrderListType:(JTOrderListType)orderListType parentController:(UIViewController *)parentController;

@end
