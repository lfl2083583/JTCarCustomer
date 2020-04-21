//
//  JTCarCertificationRewardViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

static NSString *carCertificationChangeNotificationName = @"carCertificationChangeNotificationName";

@interface JTCarCertificationRewardViewController : BaseRefreshViewController

@property (nonatomic, strong) JTCarModel *carModel;

- (instancetype)initCarModel:(JTCarModel *)carModel;

@end
