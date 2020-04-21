//
//  JTOrderPriceTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderBaseTableViewCell.h"

static NSString *const orderPriceIdentfier = @"JTOrderPriceTableViewCell";

@interface JTOrderPriceTableViewCell : JTOrderBaseTableViewCell

@property (nonatomic, strong) UILabel *goodsPrice;
@property (nonatomic, strong) UILabel *subgoodsPrice;
@property (nonatomic, strong) UILabel *manhousPrice;
@property (nonatomic, strong) UILabel *submanhousPrice;
@property (nonatomic, strong) UILabel *vipDiscount;
@property (nonatomic, strong) UILabel *subvipDiscount;
@property (nonatomic, strong) UILabel *totalDiscount;
@property (nonatomic, strong) UILabel *subtotalDiscount;
@property (nonatomic, strong) UIView *dashView;
@property (nonatomic, strong) UILabel *totalPrice;

@end
