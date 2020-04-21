//
//  JTMaintenanceLogViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTMaintenanceLogViewController : BaseRefreshViewController

@property (nonatomic, strong) JTCarModel *carModel;

- (instancetype)initWithCarModel:(JTCarModel *)carModel;

@end
