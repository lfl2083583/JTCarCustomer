//
//  JTBonusDetailHeaderView.m
//  JTSocial
//
//  Created by apple on 2017/10/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTBonusDetailHeaderView.h"

@implementation JTBonusDetailHeaderView

- (void)configWithBonusDetailHeaderView:(NSString *)senduserAvatar sendUserName:(NSString *)sendUserName bonusTitle:(NSString *)bonusTitle bonusType:(NSInteger)bonusType bonusRobMoney:(CGFloat)bonusRobMoney
{
    [self.avatar setAvatarByUrlString:[senduserAvatar avatarHandleWithSquare:140] defaultImage:DefaultBigAvatar];
    [self.titleLB setText:[sendUserName stringByAppendingString:@"的红包"]];
    if (bonusType == 2) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[sendUserName stringByAppendingString:@"的红包"]];;
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -1.5, 16, 16);
        attach.image = [UIImage imageNamed:@"icon_fight"];
        NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
        [attributedString insertAttributedString:strAtt atIndex:attributedString.length];
        self.titleLB.attributedText = attributedString;
    }
    else
    {
        self.titleLB.text = [sendUserName stringByAppendingString:@"的红包"];
    }
    [self.detailLB setText:bonusTitle];
    if (bonusRobMoney > 0) {
        NSString *moneyText = [NSString stringWithFormat:@"%.2f唐人币", bonusRobMoney];
        NSMutableAttributedString *moneyAttributedString = [[NSMutableAttributedString alloc] initWithString:moneyText];
        NSRange range = [moneyText rangeOfString:@"唐人币"];
        [moneyAttributedString addAttribute:NSFontAttributeName value:Font(16) range:range];
        self.moneyLB.attributedText = moneyAttributedString;
    }
}

- (IBAction)lookWalletClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookWalletInBonusDetailHeaderView:)]) {
        [self.delegate lookWalletInBonusDetailHeaderView:self];
    }
}
@end
