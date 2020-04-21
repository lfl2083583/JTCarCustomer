//
//  JTTeamSelectViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTContactConfig.h"
#import "BaseRefreshViewController.h"

typedef void(^ZT_TeamSelectBlock)(NSArray *teamIDs, NSString *content);

@interface JTTeamSelectViewController : BaseRefreshViewController

@property (nonatomic, strong, readonly) id<JTContactConfig>config;
@property (nonatomic, copy) ZT_TeamSelectBlock callBack;

- (instancetype)initWithConfig:(id<JTContactConfig>)config;


@end
