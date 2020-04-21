//
//  ZTSegmentedControl.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/12.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <HMSegmentedControl/HMSegmentedControl.h>

typedef void (^IndexClickBlock)(NSInteger index);

@interface ZTSegmentedControl : HMSegmentedControl

@property (nonatomic, assign) BOOL showHorizonLine;
@property (nonatomic, strong) UIColor *horizonLineColor;

@property (nonatomic, assign) BOOL showVerticalLine;
@property (nonatomic, strong) UIColor *verticalLineColor;

@property (nonatomic, copy) IndexClickBlock indexClick;

@end
