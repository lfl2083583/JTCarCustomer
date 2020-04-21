//
//  JTPersonInfoViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTNormalUserInfo.h"
#import "BaseRefreshViewController.h"

@interface JTPersonInfoViewController : BaseRefreshViewController

@property (nonatomic, strong) JTNormalUserInfo *userInfo;

- (instancetype)initWithUserInfo:(JTNormalUserInfo *)userInfo;

@end
