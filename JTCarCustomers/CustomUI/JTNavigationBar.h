//
//  JTNavigationBar.h
//  JTDirectSeeding
//
//  Created by apple on 2017/4/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

@protocol JTNavigationBarDelegate <NSObject>

@optional
- (void)navigationBarToLeft:(id)navigationBar;
- (void)navigationBarToRight:(id)navigationBar;

@end

@interface JTNavigationBar : UIView

@property (strong, nonatomic) UIButton *leftBT;
@property (strong, nonatomic) UIButton *rightBT;
@property (strong, nonatomic) ZTCirlceImageView *leftIV;
@property (strong, nonatomic) ZTCirlceImageView *rightIV;
@property (strong, nonatomic) UILabel *titleLB;

@property (weak, nonatomic) id<JTNavigationBarDelegate> delegate;

@end

@interface JTCardNavigationBar : JTNavigationBar

@property (nonatomic, strong) UIView *bottomView;

@end

@interface JTMapMarkNavigationBar : JTNavigationBar

@end

@interface JTBonusDetailNavigationBar : JTNavigationBar

@end

@interface JTStoreNavigationBar : JTNavigationBar

@end

@interface JTTeamInfoNavigationBar : JTNavigationBar

@end
