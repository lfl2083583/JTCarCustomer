//
//  JTMyLoveCarViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTMyLoveCarViewController : BaseRefreshViewController

@property (assign, nonatomic) NSInteger currentIndex;

- (instancetype)initWithCurrentIndex:(NSInteger)currentIndex;
@end
