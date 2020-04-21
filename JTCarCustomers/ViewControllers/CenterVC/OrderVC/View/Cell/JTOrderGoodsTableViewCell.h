//
//  JTOrderGoodsTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderBaseTableViewCell.h"

static NSString *const orderGoodsIdentifier = @"JTOrderGoodsTableViewCell";

@interface JTOrderGoodsTableViewCell : JTOrderBaseTableViewCell

@property (nonatomic, strong) UIImageView *contentImgeView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *detailLB;
@property (nonatomic, strong) UILabel *priceLB;
@property (nonatomic, strong) UILabel *goodsNumLB;

@end
