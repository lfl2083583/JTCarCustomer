//
//  JTTeamDismissViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTTeamDismissViewController : BaseRefreshViewController

@property (copy, nonatomic) NIMMessage *message;

- (instancetype)initWithMessage:(NIMMessage *)message;

@end
