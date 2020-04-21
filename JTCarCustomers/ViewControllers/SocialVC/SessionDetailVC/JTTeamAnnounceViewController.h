//
//  JTTeamAnnounceViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"


@interface JTTeamAnnounceViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;

- (instancetype)initWithTeam:(NIMTeam *)team;

@end
