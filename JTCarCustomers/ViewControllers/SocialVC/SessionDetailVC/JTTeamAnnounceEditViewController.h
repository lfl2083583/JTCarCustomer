//
//  JTTeamAnnounceEditViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTTeamAnnounceEditViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, copy) NSString *announceID;

- (instancetype)initWithTeam:(NIMTeam *)team;

- (instancetype)initWithTeam:(NIMTeam *)team announceID:(NSString *)announceID;

@end
