//
//  JTMoneyDetailViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTMoneyDetailViewController : BaseRefreshViewController

@property (nonatomic, strong) id source;

- (instancetype)initWithSource:(id)source;

@end
