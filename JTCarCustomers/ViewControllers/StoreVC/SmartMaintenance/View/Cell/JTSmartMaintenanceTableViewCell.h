//
//  JTSmartMaintenanceTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const smartMaintenanceIdentifier = @"JTSmartMaintenanceTableViewCell";

@interface JTSmartMaintenanceTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *checkBox;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *discribLB;
@property (nonatomic, strong) UILabel *commodityFeeLB;
@property (nonatomic, strong) UILabel *manhourFeeLB;
@property (nonatomic, strong) UIView *horizonView;

@property (nonatomic, strong) id maintenance;

@end
