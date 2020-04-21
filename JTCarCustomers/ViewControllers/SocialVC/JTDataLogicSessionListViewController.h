//
//  JTDataLogicSessionListViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTDataLogicSessionListViewController : BaseRefreshViewController

@property (strong, nonatomic) NSMutableArray *recentSessions;

- (void)reloadUI:(BOOL)isReloadTableView;

@end
