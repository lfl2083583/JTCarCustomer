//
//  JTDynamicViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTDynamicViewController : BaseRefreshViewController

@property (assign, nonatomic) BOOL canScroll;
@property (strong, nonatomic) UIViewController *parentController;

@end
