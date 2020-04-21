//
//  JTTeamManageViewController.h
//  JTSocial
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTTeamPowerModel.h"

@interface JTTeamManageViewController : BaseRefreshViewController

@property (nonatomic, copy) NIMSession *session;
@property (nonatomic, copy) JTTeamPowerModel *powerModel;

- (instancetype)initWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel;

@end
