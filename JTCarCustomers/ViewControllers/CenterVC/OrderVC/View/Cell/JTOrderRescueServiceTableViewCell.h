//
//  JTOrderRescueServiceTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderBaseTableViewCell.h"

static NSString *const orderRescueServiceIdentifier = @"JTOrderRescueServiceTableViewCell";

@interface JTOrderRescueServiceTableViewCell : JTOrderBaseTableViewCell

@property (nonatomic, strong) UILabel *addressLB;
@property (nonatomic, strong) UILabel *serviceLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *addressContentLB;
@property (nonatomic, strong) UILabel *serviceContentLB;
@property (nonatomic, strong) UILabel *timeContentLB;

@end
