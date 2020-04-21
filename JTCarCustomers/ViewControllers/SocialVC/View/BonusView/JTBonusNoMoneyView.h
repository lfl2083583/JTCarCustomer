//
//  JTBonusNoMoneyView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTBonusNoMoneyView : UIView

@property (assign, nonatomic) double bonusMoney;
@property (copy, nonatomic) void (^completionHandler)(void);

- (instancetype)initWithBonusMoney:(double)bonusMoney completionHandler:(void (^)(void))completionHandler;

@end
