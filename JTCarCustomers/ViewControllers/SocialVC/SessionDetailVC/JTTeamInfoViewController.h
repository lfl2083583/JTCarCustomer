//
//  JTTeamInfoViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTTeamPowerModel.h"
#import "JTJoinTeamViewController.h"

@interface JTTeamInfoViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, strong) NIMTeamMember *myTeamMember;
@property (nonatomic, strong) JTTeamPowerModel *powerModel;

@property (nonatomic, assign) JTTeamSource teamSource;
@property (nonatomic, copy) NSString *inviteID;

- (instancetype)initWithTeam:(NIMTeam *)team;

- (instancetype)initWithTeam:(NIMTeam *)team teamSource:(JTTeamSource)teamSource;

@end
