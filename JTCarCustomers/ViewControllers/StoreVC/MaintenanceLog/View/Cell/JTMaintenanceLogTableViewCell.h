//
//  JTMaintenanceLogTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const maintenanceLogIdentifier = @"JTMaintenanceLogTableViewCell";

@interface JTMaintenanceLogTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *cicleView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *subtitleLB;
@property (nonatomic, strong) UILabel *resourceLB;

@property (nonatomic, strong) id item;

@end
