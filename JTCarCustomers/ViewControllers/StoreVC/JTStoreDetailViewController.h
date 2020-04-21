//
//  JTStoreDetailViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreModel.h"

@interface JTStoreDetailViewController : UIViewController

@property (copy, nonatomic) JTStoreModel *model;
@property (copy, nonatomic) NSString *storeID;

- (instancetype)initWithModel:(JTStoreModel *)model;
- (instancetype)initWithStoreID:(NSString *)storeID;

@end
