//
//  JTRescueInfoViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import <MapKit/MapKit.h>

@interface JTRescueInfoViewController : BaseRefreshViewController

@property (assign, nonatomic) JTRescueType rescueType;
@property (copy, nonatomic) MKPlacemark *startPlacemark;
@property (copy, nonatomic) MKPlacemark *endPlacemark;
@property (copy, nonatomic) NSDictionary *dataDic;

- (instancetype)initWithRescueType:(JTRescueType)rescueType startPlacemark:(MKPlacemark *)startPlacemark dataDic:(NSDictionary *)dataDic;
- (instancetype)initWithRescueType:(JTRescueType)rescueType startPlacemark:(MKPlacemark *)startPlacemark endPlacemark:(MKPlacemark *)endPlacemark dataDic:(NSDictionary *)dataDic;

@end
