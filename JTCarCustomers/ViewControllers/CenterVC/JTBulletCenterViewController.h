//
//  JTBulletCenterViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTBulletCenterViewController : BaseRefreshViewController

@property (nonatomic, copy) NSString *userID;

- (instancetype)initWithUserID:(NSString *)userID;

@end
