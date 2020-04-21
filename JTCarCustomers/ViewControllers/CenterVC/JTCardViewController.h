//
//  JTCardViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTCardViewController : UIViewController

@property (nonatomic, copy) NSString *yunXinID;
/**
 用户ID
 */
@property (nonatomic, copy) NSString *userID;

@property (nonatomic, copy) NSString *teamID;

- (instancetype)initWithUserID:(NSString *)userID;

- (instancetype)initWithUserID:(NSString *)userID teamID:(NSString *)teamID;

@end
