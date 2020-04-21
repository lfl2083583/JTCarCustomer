//
//  JTWalletViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
@protocol JTWalletHeadViewDelegate <NSObject>

- (void)walletRecharge;

@end

@interface JTWalletHeadView : UIView

@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UIImageView *bottomImgV;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UILabel *rightLB;
@property (nonatomic, weak) id<JTWalletHeadViewDelegate>delegate;

@end

@interface JTWalletViewController : BaseRefreshViewController

@end
