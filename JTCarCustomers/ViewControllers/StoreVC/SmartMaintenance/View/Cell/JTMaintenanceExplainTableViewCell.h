//
//  JTMaintenanceExplainTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const maintenanceExplainIdentifier = @"JTJTMaintenanceExplainTableViewCell";

@interface JTMaintenanceExplainTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UIButton *rightBtn;

@end
