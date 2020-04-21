//
//  JTBindingAndLoginViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTBaseLoginViewController.h"

@interface JTBindingAndLoginViewController : JTBaseLoginViewController

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *bindID;

- (instancetype)initWithBundingPhoneNum:(NSString *)phoneNum bindID:(NSString *)bindID;

@end
