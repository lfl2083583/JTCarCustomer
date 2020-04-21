//
//  JTCardBottomView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCardBottomView.h"

@implementation JTCardBottomViewConfig


@end

@implementation JTCardBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.centerView];
        [self addSubview:self.centerBtn];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (void)setupParameter:(JTCardBottomViewConfig *)config {
    [self.leftBtn setTitle:config.leftTitle forState:UIControlStateNormal];
    [self.rightBtn setTitle:config.rightTitle forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:config.leftImageName] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:config.rightImgeName] forState:UIControlStateNormal];
    [self.leftBtn setImageEdgeInsets:config.leftImageEdgeInsets];
    [self.rightBtn setImageEdgeInsets:config.rightImageEdgeInsets];
    [self.leftBtn setTitleColor:config.lTColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:config.rTColot forState:UIControlStateNormal];
}


- (void)leftBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewToLeft:)]) {
        [_delegate bottomViewToLeft:sender];
    }
}

- (void)rightBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewToRight:)]) {
        [_delegate bottomViewToRight:sender];
    }
}

- (void)centerBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewToCenter:)]) {
        [_delegate bottomViewToCenter:sender];
    }
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 2.0, self.bounds.size.height)];
        _leftBtn.titleLabel.font = Font(16);
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2.0, 0, self.bounds.size.width / 2.0, self.bounds.size.height)];
        _rightBtn.titleLabel.font = Font(16);
        _rightBtn.enabled = NO;
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 1) / 2.0, 12, 1, self.bounds.size.height - 24)];
        _centerView.backgroundColor = BlackLeverColor2;
    }
    return _centerView;
}

- (UIButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _centerBtn.titleLabel.font = Font(16);
        _centerBtn.backgroundColor = BlueLeverColor1;
        [_centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _centerBtn.hidden = YES;
    }
    return _centerBtn;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _topView.backgroundColor = BlackLeverColor2;
        _topView.hidden = YES;
    }
    return _topView;
}
@end
