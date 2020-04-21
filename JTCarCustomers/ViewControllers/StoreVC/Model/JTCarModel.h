//
//  JTCarModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTCarModel : MTLModel

@property (copy, nonatomic) NSString *carID;   // 车型id
@property (copy, nonatomic) NSString *number;  // 车牌号码
@property (copy, nonatomic) NSString *brand;   // 品牌名称
@property (copy, nonatomic) NSString *model;   // 车型名称
@property (copy, nonatomic) NSString *name;    // 车型名称
@property (assign, nonatomic) NSInteger isAuth;// 是否认证 -1:未认证  1:已认证  2:认证中
@property (copy, nonatomic) NSString *buyTime; // 购车时间
@property (copy, nonatomic) NSString *mileageStr; // 行驶里程
@property (copy, nonatomic) NSString *mileageNum; // 行驶里程
@property (copy, nonatomic) NSString *icon;    // 车型图标
@property (assign, nonatomic) BOOL isDefault;  // 是否默认车型 1:是 0:不是

@end
