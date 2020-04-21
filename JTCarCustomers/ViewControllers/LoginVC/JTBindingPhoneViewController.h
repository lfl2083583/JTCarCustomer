//
//  JTBindingPhoneViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTBindingPhoneViewController : UIViewController

@property (nonatomic, copy) NSString *bindID;

- (instancetype)initWithBindID:(NSString *)bindID;

@end
