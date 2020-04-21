//
//  JTRescueAddressSearchViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, JTRescueAddressType)
{
    JTRescueAddressTypeLiftElectricity,      // 搭电
    JTRescueAddressTypeTrailerStart,         // 拖车起点
    JTRescueAddressTypeTrailerEnd            // 拖车终点
};

@interface JTRescueAddressSearchViewController : BaseRefreshViewController

@property (assign, nonatomic) JTRescueAddressType rescueAddressType;
@property (strong, nonatomic) MKPlacemark *currentPlacemark;
@property (copy, nonatomic) void(^completedBlock)(MKPlacemark *placemark);

- (instancetype)initWithRescueAddressType:(JTRescueAddressType)rescueAddressType currentPlacemark:(MKPlacemark *)currentPlacemark completedBlock:(void (^)(MKPlacemark *placemark))completedBlock;

@end
