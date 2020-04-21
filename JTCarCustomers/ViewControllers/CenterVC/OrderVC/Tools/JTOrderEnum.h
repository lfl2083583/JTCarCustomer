//
//  JTOrderEnum.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#ifndef JTOrderEnum_h
#define JTOrderEnum_h

typedef NS_ENUM(NSUInteger, JTOrderType)
{
    JTOrderTypeLiftElectricity                 = 0,  //搭电订单
    JTOrderTypeLiftTrailer                     = 1,  //救援订单
    JTOrderTypeStore                           = 2,  //门店服务订单
};

typedef NS_ENUM(NSUInteger, JTOrderHandleStatus) {
    
    JTOrderHandleStatusRegistered              = 0,  // 订单预约中
    JTOrderHandleStatusRegisteredSuccess       = 1,  // 订单预约成功
    JTOrderHandleStatusRegisteredFail          = 2,  // 订单预约失败
    JTOrderHandleStatusInProgress              = 3,  // 订单进行中
    JTOrderHandleStatusCancel                  = 4,  // 订单取消
    JTOrderHandleStatusComplete                = 5,  // 订单完成
};



#endif /* JTOrderEnum_h */
