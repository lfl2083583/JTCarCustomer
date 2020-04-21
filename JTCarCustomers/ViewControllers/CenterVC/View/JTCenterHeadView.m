//
//  JTCenterHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCenterHeadView.h"
#import "ZTCirlceImageView.h"

@interface JTCenterHeadView ()

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) ZTCirlceImageView *avatarView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIButton *memberBtn;

@end

@implementation JTCenterHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.rightBtn];
        [self addSubview:self.avatarView];
        [self addSubview:self.topLabel];
        [self addSubview:self.memberBtn];
        [self refreshHeadViewData];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (void)refreshHeadViewData {
    
    [self.avatarView setAvatarByUrlString:[JTUserInfo shareUserInfo].userAvatar defaultImage:DefaultSmallAvatar];
    self.topLabel.text = [JTUserInfo shareUserInfo].userName;
}


- (void)avatarClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(headViewAvatarClick)]) {
        [_delegate headViewAvatarClick];
    }
}

- (void)rightBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(headViewQRClick)]) {
        [_delegate headViewQRClick];
    }
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 50, 39, 25, 25)];
        [_rightBtn setImage:[UIImage imageNamed:@"center_qr_icon"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (ZTCirlceImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 67) / 2.0, 77, 67, 67)];
        _avatarView.userInteractionEnabled = YES;
        [_avatarView addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.avatarView.frame) + 10, self.bounds.size.width - 20, 28)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = Font(20);
        _topLabel.textColor = BlackLeverColor5;
    }
    return _topLabel;
}

- (UIButton *)memberBtn {
    if (!_memberBtn) {
        _memberBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - 60) / 2.0, CGRectGetMaxY(self.topLabel.frame) + 5, 60, 25)];
        [_memberBtn setImage:[UIImage imageNamed:@"center_diamond_icon"] forState:UIControlStateNormal];
    }
    return _memberBtn;
}
@end


@implementation JTCenterFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _leftLabel.font = Font(12);
        _leftLabel.textColor = BlackLeverColor5;
        _leftLabel.text = @"@法律条款与隐私政策";
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}

@end
