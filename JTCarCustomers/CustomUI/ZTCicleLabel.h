//
//  ZTCicleLabel.h
//  JTCarCustomers
//
//  Created by liufulin on 2019/3/21.
//  Copyright © 2019 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTCicleLabel : UILabel

@property (nonatomic, strong)CAShapeLayer *maskLayer;
@property (nonatomic, strong)UIBezierPath *borderPath;

@end

NS_ASSUME_NONNULL_END
