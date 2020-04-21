//
//  JTTeamJoinModeViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTTeamPowerModel.h"

@interface JTTeamJoinModeViewController : BaseRefreshViewController

@property (nonatomic, copy) NIMSession *session;
@property (nonatomic, copy) JTTeamPowerModel *powerModel;

- (instancetype)initWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel;

@end
