//
//  JTSmartMaintenanceTableHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

@protocol JTSmartMaintenanceDelegate <NSObject>

@optional
- (void)feeDetailExplain;
- (void)chooseMaintenanceStore;
- (void)chooseLoveCar;

@end

@interface JTSmartMaintenanceTableHeadView : UIView

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ZTCirlceImageView *carIcon;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *modelLB;
@property (nonatomic, strong) UILabel *travelLB;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, weak) id<JTSmartMaintenanceDelegate>delegate;

@end

@interface JTSmartMaintenanceFootView : UIView

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *explainBtn;
@property (nonatomic, strong) UIButton *chooseStoreBtn;
@property (nonatomic, strong) UILabel *estimatedCostLB;
@property (nonatomic, strong) UILabel *manhourCostLB;

@property (nonatomic, weak) id<JTSmartMaintenanceDelegate>delegate;

@end

static NSString *smartMaintenanceSectionIdentifier = @"smartMaintenanceSectionIdentifier";

@interface JTSmartMaintenanceSectionHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *horizonView;
@property (nonatomic, strong) UILabel *titleLB;

@end
