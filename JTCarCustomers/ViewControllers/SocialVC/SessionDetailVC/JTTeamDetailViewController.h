//
//  JTTeamDetailViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTTeamPowerModel.h"

@interface JTTeamDetailViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) JTTeamPowerModel *powerModel;

- (instancetype)initWithSession:(NIMSession *)session;

@end
