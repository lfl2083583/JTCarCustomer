//
//  JTAccountNewPhoneViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTAccountNewPhoneViewController : BaseRefreshViewController

@property (nonatomic, copy) NSString *randCode;

- (instancetype)initWithRandCode:(NSString *)randCode;

@end
