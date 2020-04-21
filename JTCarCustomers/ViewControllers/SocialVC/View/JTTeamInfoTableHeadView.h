//
//  JTTeamInfoTableHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCarouselView.h"
#import "JTGradientButton.h"
@protocol JTTeamInfoViewDelegate <NSObject>

@optional
- (void)teamInfoViewEditeTeamInfo;

- (void)teamInfoViewQRCode;

- (void)teamInfoViewApplyJoin;

@end

@interface JTTeamInfoTableHeadView : UIView

@property (nonatomic, strong) KCarouselView *coverImgeView;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, strong) NSDictionary *distance;
@property (nonatomic, weak) id<JTTeamInfoViewDelegate>delegate;

@end

@interface JTTeamInfoTableFootView : UIView

@property (nonatomic, strong) JTGradientButton *centerBtn;
@property (nonatomic, weak) id<JTTeamInfoViewDelegate>delegate;

@end
