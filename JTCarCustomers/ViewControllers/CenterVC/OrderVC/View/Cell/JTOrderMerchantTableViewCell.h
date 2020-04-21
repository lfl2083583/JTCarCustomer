//
//  JTOrderMerchantTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderBaseTableViewCell.h"

static NSString *const orderMerchantIdentifier = @"JTOrderMerchantTableViewCell";

@interface JTOrderMerchantTableViewCell : JTOrderBaseTableViewCell

@property (nonatomic, strong) UILabel *merchantName;
@property (nonatomic, strong) UILabel *merchantAddress;
@property (nonatomic, strong) UILabel *merchantDistance;
@property (nonatomic, strong) UIButton *merchantNav;

@end
