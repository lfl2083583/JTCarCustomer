//
//  JTRescueOrderViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTRescueOrderModel : NSObject

@property (assign, nonatomic) JTRescueType rescueType;  // 救援类型
@property (copy, nonatomic) NSString *price;            // 救援费用
@property (copy, nonatomic) NSString *startPoint;       // 开始经纬度
@property (copy, nonatomic) NSString *startAddress;     // 开始地址
@property (copy, nonatomic) NSString *endPoint;         // 终点经纬度
@property (copy, nonatomic) NSString *endAddress;       // 终点地址
@property (copy, nonatomic) NSString *carName;          // 车名称
@property (copy, nonatomic) NSString *carID;            // 车ID
@property (copy, nonatomic) NSString *carAlias;         // 车所属地
@property (copy, nonatomic) NSString *carNumber;        // 车牌号
@property (copy, nonatomic) NSString *contacts;         // 联系人
@property (copy, nonatomic) NSString *contactsNumber;   // 联系电话
@property (assign, nonatomic) BOOL isDrawBill;          // 是否开发票

@end;

@interface JTRescueOrderViewController : UIViewController

@property (copy, nonatomic) JTRescueOrderModel *model;

- (instancetype)initWithModel:(JTRescueOrderModel *)model;
@end
