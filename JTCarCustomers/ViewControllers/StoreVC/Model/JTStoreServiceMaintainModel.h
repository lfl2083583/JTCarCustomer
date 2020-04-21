//
//  JTStoreServiceMaintainModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTStoreSeviceModel.h"

@interface JTStoreServiceMaintainModel : NSObject

@property (copy, nonatomic) NSString *maintainID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray<JTStoreSeviceModel *> *storeSeviceModels;
@property (assign, nonatomic) NSInteger total;
@end
