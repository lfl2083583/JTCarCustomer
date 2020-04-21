//
//  JTTeamMemberListViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTTeamMemberListViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;

- (instancetype)initWithTeam:(NIMTeam *)team;

@end
