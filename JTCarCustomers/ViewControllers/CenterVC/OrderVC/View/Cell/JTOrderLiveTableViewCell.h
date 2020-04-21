//
//  JTOrderLiveTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderBaseTableViewCell.h"

static NSString *const orderLiveIdentifier = @"JTOrderLiveTableViewCell";

@interface JTOrderLiveTableViewCell : JTOrderBaseTableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIButton *playBtn;

@end
