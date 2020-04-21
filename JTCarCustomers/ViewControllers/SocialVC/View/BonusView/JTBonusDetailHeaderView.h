//
//  JTBonusDetailHeaderView.h
//  JTSocial
//
//  Created by apple on 2017/10/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

@protocol JTBonusDetailHeaderViewDelegate <NSObject>

@optional

- (void)lookWalletInBonusDetailHeaderView:(id)bonusDetailHeaderView;

@end

@interface JTBonusDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet ZTCirlceImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) id<JTBonusDetailHeaderViewDelegate> delegate;

- (void)configWithBonusDetailHeaderView:(NSString *)senduserAvatar sendUserName:(NSString *)sendUserName bonusTitle:(NSString *)bonusTitle bonusType:(NSInteger)bonusType bonusRobMoney:(CGFloat)bonusRobMoney;

@end
