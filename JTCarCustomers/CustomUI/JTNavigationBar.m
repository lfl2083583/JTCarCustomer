//
//  JTNavigationBar.m
//  JTDirectSeeding
//
//  Created by apple on 2017/4/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTNavigationBar.h"

@implementation JTNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIButton *)leftBT
{
    if (!_leftBT) {
        _leftBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _leftBT.frame = CGRectMake(15, 0, 100, kTopBarHeight);
        _leftBT.titleLabel.font = Font(14);
        [_leftBT addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBT;
}

- (UIButton *)rightBT
{
    if (!_rightBT) {
        _rightBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBT.frame = CGRectMake(App_Frame_Width-115, 0, 100, kTopBarHeight);
        _rightBT.titleLabel.font = Font(14);
        [_rightBT addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBT;
}

- (ZTCirlceImageView *)leftIV
{
    if (!_leftIV) {
        _leftIV = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(10, 0, 35, 35)];
        _leftIV.userInteractionEnabled = YES;
        [_leftIV addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftIV;
}

- (ZTCirlceImageView *)rightIV
{
    if (!_rightIV) {
        _rightIV = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-45, 0, 35, 35)];
        _rightIV.userInteractionEnabled = YES;
        [_rightIV addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftIV;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(18);
        _titleLB.frame = CGRectMake(0, 0, App_Frame_Width, 44);
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}

- (void)leftClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(navigationBarToLeft:)]) {
        [_delegate navigationBarToLeft:self];
    }
}

- (void)rightClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(navigationBarToRight:)]) {
        [_delegate navigationBarToRight:self];
    }
}
@end

@implementation JTCardNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.leftBT];
        [self addSubview:self.rightBT];
        [self addSubview:self.titleLB];
        [self addSubview:self.bottomView];
        [self.rightBT setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [self.leftBT setImage:[UIImage imageNamed:@"nav_back_bottom"] forState:UIControlStateNormal];
        [self.titleLB setY:kStatusBarHeight];
        [self.leftBT setY:kStatusBarHeight];
        [self.rightBT setY:kStatusBarHeight];
    }
    return self;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight-0.5, App_Frame_Width, 0.5)];
        _bottomView.backgroundColor = BlackLeverColor2;
    }
    return _bottomView;
}

@end

@implementation JTMapMarkNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.leftBT];
        [self addSubview:self.rightBT];
        [self.leftBT setImage:[UIImage imageNamed:@"nav_back_bottom"] forState:UIControlStateNormal];
        [self.rightBT setImage:[UIImage imageNamed:@"nav_more_bottom"] forState:UIControlStateNormal];
    }
    return self;
}

@end

@implementation JTBonusDetailNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleLB];
        [self.titleLB setTop:kStatusBarHeight];
        [self.titleLB setText:@"红包"];
        [self.titleLB setTextColor:WhiteColor];
        [self addSubview:self.leftBT];
        [self addSubview:self.rightBT];
        [self.leftBT setTop:kStatusBarHeight];
        [self.leftBT setTitle:@"返回" forState:UIControlStateNormal];
        [self.leftBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.rightBT setTop:kStatusBarHeight];
        [self.rightBT setTitle:@"红包明细" forState:UIControlStateNormal];
        [self.rightBT setTitleColor:WhiteColor forState:UIControlStateNormal];
    }
    return self;
}
@end

@implementation JTStoreNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleLB];
        [self.titleLB setTop:kStatusBarHeight];
        [self.titleLB setText:@"门店"];
        [self.titleLB setTextColor:WhiteColor];
        [self addSubview:self.leftIV];
        [self.leftIV setTop:kStatusBarHeight];
        [self addSubview:self.rightBT];
        [self.rightBT setTop:kStatusBarHeight];
        [self.rightBT setTitle:@"我的爱车" forState:UIControlStateNormal];
        [self.rightBT setTitleColor:WhiteColor forState:UIControlStateNormal];
    }
    return self;
}

@end

@implementation JTTeamInfoNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.leftBT];
        [self addSubview:self.rightBT];
        [self.leftBT setImage:[UIImage imageNamed:@"nav_back_bottom"] forState:UIControlStateNormal];
        [self.rightBT setImage:[UIImage imageNamed:@"nav_more_bottom"] forState:UIControlStateNormal];
    }
    return self;
}

@end
