//
//  JTBonusNoMoneyView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBonusNoMoneyView.h"

@interface JTBonusNoMoneyView ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;

@end

@implementation JTBonusNoMoneyView

- (instancetype)initWithBonusMoney:(double)bonusMoney completionHandler:(void (^)(void))completionHandler
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"JTBonusNoMoneyView" owner:nil options:nil] lastObject];
    if (self) {
        self.bonusMoney = bonusMoney;
        self.completionHandler = completionHandler;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSString *moneyText = [NSString stringWithFormat:@"%.2f唐人币", self.bonusMoney];
    NSMutableAttributedString *moneyAttributedString = [[NSMutableAttributedString alloc] initWithString:moneyText];
    NSRange range = [moneyText rangeOfString:@"唐人币"];
    [moneyAttributedString addAttribute:NSFontAttributeName value:Font(16) range:range];
    self.moneyLB.attributedText = moneyAttributedString;
    self.balanceLB.text = [NSString stringWithFormat:@"%.2f唐人币", [JTUserInfo shareUserInfo].userBalance];
}

- (IBAction)rechargeClick:(id)sender {
    if (self.completionHandler) {
        self.completionHandler();
    }
}

@end
