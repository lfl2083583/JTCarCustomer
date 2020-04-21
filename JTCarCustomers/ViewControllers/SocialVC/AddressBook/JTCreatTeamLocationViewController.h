//
//  JTCreatTeamLocationViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTCreatTeamClassifyViewController.h"
typedef void (^zt_TeamLoctionInfoBlock)(JTTeamPositionType positionType, NSString *address, NSString *lng, NSString *lat);
@interface JTCreatTeamLocationViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, copy) zt_TeamLoctionInfoBlock callBack;

- (instancetype)initWithTeam:(NIMTeam *)team callBack:(zt_TeamLoctionInfoBlock)callBack;

@end
