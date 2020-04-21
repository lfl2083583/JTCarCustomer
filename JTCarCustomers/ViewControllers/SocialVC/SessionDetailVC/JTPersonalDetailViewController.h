//
//  JTPersonalDetailViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTPersonalDetailViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) NIMUser *user;

- (instancetype)initWithSession:(NIMSession *)session;

@end
