//
//  JTAddCarViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef NS_ENUM(NSInteger, JTAddCarType) {
    JTAddCarTypeNormal = 0,
    JTAddCarTypeMaintain,
    JTAddCarTypeParkingLot,
};

@interface JTAddCarViewController : BaseRefreshViewController

@property (assign, nonatomic) JTAddCarType addCarType;

- (instancetype)initWithAddCarType:(JTAddCarType)addCarType;

@end
