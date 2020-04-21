//
//  JTMaintenanceManualHeaderView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTMaintenanceManualHeaderView : UIView

@property (copy, nonatomic) JTCarModel *model;

- (instancetype)initWithModel:(JTCarModel *)model;

@end
