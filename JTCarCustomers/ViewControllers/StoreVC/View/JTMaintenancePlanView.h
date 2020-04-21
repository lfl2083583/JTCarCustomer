//
//  JTMaintenancePlanView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "FormScrollView.h"

@interface JTMaintenancePlanView : FormScrollView <FDataSource>

@property (copy, nonatomic) NSArray *dataArray;

@end
