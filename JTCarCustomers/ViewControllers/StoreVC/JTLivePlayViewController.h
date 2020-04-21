//
//  JTLivePlayViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreServiceLiveModel.h"

@interface JTLivePlayViewController : UIViewController

@property (copy, nonatomic) JTStoreServiceLiveModel *model;

- (instancetype)initWithStoreServiceLiveModel:(JTStoreServiceLiveModel *)model;

@end
