//
//  JTRealCertificationViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTRealCertificationViewController : UIViewController

@property (nonatomic, assign) JTRealCertificationStatus status;

- (instancetype)initWithRealCertificationStatus:(JTRealCertificationStatus)status;

@end
