//
//  JTTalentEvaluateViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTTalentEvaluateViewController : BaseRefreshViewController

@property (nonatomic, copy) NSString *userID;

- (instancetype)initWithUserID:(NSString *)userID;

@end
