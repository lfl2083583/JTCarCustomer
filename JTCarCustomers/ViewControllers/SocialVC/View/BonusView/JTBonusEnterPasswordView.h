//
//  JTBonusEnterPasswordView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTBonusPaymentResults)
{
    JTBonusPaymentResultsSuccess = 0, // 成功
    JTBonusPaymentResultsNoMoney      // 没钱
};

@interface JTBonusEnterPasswordView : UIView

@property (assign, nonatomic) double bonusMoney;
@property (assign, nonatomic) JTBonusType bonusType;
@property (copy, nonatomic) NSString *toID;
@property (copy, nonatomic) NSString *bonusTitle;
@property (assign, nonatomic) NSInteger bonusNum;
@property (copy, nonatomic) void (^completionHandler)(JTBonusPaymentResults bonusPaymentResults);

- (instancetype)initWithBonusMoney:(double)bonusMoney bonusType:(JTBonusType)bonusType toID:(NSString *)toID bonusTitle:(NSString *)bonusTitle  bonusNum:(NSInteger)bonusNum completionHandler:(void (^)(JTBonusPaymentResults bonusPaymentResults))completionHandler;
@end
