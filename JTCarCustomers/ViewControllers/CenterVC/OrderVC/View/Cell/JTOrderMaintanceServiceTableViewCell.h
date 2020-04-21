//
//  JTOrderMaintanceServiceTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "HMSegmentedControl.h"
#import "JTOrderBaseTableViewCell.h"

static NSString *const orderMaintanceServiceIdentfier = @"JTOrderMaintanceServiceTableViewCell";

@interface JTOrderMaintanceServiceTableViewCell : JTOrderBaseTableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end
