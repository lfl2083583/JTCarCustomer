//
//  JTMaintenanceCategoryViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef NS_ENUM(NSInteger, JTMaintenanceLogType) {
    JTMaintenanceLogTypeForAll = 0,             // 全部记录
    JTMaintenanceLogTypeForSystem,              // 系统添加记录
    JTMaintenanceLogTypeForManual,              // 手动添加记录
};

@interface JTMaintenanceCategoryViewController : BaseRefreshViewController

@property (nonatomic, assign) JTMaintenanceLogType logType;
@property (nonatomic, strong) JTCarModel *carModel;

- (instancetype)initWithMaintenanceLogType:(JTMaintenanceLogType)logType carModel:(JTCarModel *)carModel;

@end
