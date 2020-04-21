//
//  JTBaseLoginViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTBaseLoginViewController : BaseRefreshViewController

/**
 登录云信
 
 @param userInfo 用户信息
 */
- (void)socialLoginSeccess:(JTUserInfo *)userInfo;

@end
