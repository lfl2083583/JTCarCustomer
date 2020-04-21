//
//  JTActivityParticipateEditeViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef void(^ZT_ParticipateEditeBlock)(NSString *participateName, NSString *participatePhone);

@interface JTActivityParticipateEditeViewController : BaseRefreshViewController

@property (nonatomic, copy) ZT_ParticipateEditeBlock callBack;

@end
