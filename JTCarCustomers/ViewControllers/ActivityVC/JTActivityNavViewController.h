//
//  JTActivityNavViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTActivityNavViewController : BaseRefreshViewController


- (instancetype _Nullable)initWithLocation:(double)latitude
                                 longitude:(double)longitude
                                     title:(nullable NSString *)title;

@end
