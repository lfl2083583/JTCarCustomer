//
//  JTCarBrandViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTCarModelViewController.h"

@interface JTCarBrandViewController : BaseRefreshViewController

@property (weak, nonatomic) id<JTCarModelViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<JTCarModelViewControllerDelegate>)delegate;

@end
