//
//  JTMaintenanceRemindTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const maintenanceRemindIdentifier = @"JTMaintenanceRemindTableViewCell";

@protocol JTMaintenanceRemindTableViewCellDelegate <NSObject>

- (void)smartMaintenancePlan;

@end

@interface JTMaintenanceRemindTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *lastMaintenanceLB;
@property (nonatomic, strong) UILabel *nextMaintenanceLB;
@property (nonatomic, strong) UILabel *remainLB;
@property (nonatomic, strong) UILabel *suggestTitleLB;
@property (nonatomic, strong) UILabel *suggestContentLB;
@property (nonatomic, strong) UIButton *smartMaintenanceBtn;
@property (nonatomic, strong) UIView *horizontalView;

@property (nonatomic, strong) id remindData;

@property (nonatomic, weak) id<JTMaintenanceRemindTableViewCellDelegate>delegate;

@end
