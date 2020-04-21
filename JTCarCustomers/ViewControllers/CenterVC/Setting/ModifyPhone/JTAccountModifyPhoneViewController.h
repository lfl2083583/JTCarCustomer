//
//  JTAccountModifyPhoneViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTAccountModifyPhoneViewController : BaseRefreshViewController

@property (nonatomic, copy) NSString *randCode;
@property (nonatomic, copy) NSString *phone;

- (instancetype)initWithRandCode:(NSString *)randCode newPhone:(NSString *)newPhone;

@end
