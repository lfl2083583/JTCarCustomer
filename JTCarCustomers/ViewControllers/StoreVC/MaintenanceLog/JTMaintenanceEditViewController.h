//
//  JTMaintenanceEditViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTMaintenanceEditViewController : BaseRefreshViewController

@property (nonatomic, strong) id maintenanceDatas;
@property (nonatomic, strong) JTCarModel *carModel;

- (instancetype)initWithCarModel:(JTCarModel *)carModel;
- (instancetype)initWithCarModel:(JTCarModel *)carModel maintenanceDatas:(id)maintenanceDatas;

@end
