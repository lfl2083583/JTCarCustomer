//
//  JTAttentionTipTopView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTAttentionTipTopView.h"


@interface JTAttentionTipTopView ()

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *contentLB;
@property (strong, nonatomic) UIButton *attentionBT;
@property (strong, nonatomic) UIButton *cancelBT;

@end

@implementation JTAttentionTipTopView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTAttentionTipTopViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setDelegate:delegate];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.contentLB];
    [self.bottomView addSubview:self.attentionBT];
    [self.bottomView addSubview:self.cancelBT];
}

- (void)setPrompt:(NSString *)prompt
{
    _prompt = prompt;
    self.contentLB.text = prompt;
}

- (void)cancelClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(attentionTipTopViewToCancel:)]) {
        [_delegate attentionTipTopViewToCancel:self];
    }
}

- (void)attentionClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(attentionTipTopViewToAttention:)]) {
        [_delegate attentionTipTopViewToAttention:self];
    }
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = RedLeverColor2;
        _bottomView.layer.cornerRadius = 5.f;
        _bottomView.frame = CGRectMake(16, (self.height-44)/2, self.width-32, 44);
    }
    return _bottomView;
}

- (UILabel *)contentLB
{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = Font(14);
        _contentLB.textColor = RedLeverColor1;
        _contentLB.frame = CGRectMake(16, 0, self.attentionBT.left-32, self.bottomView.height);
    }
    return _contentLB;
}

- (UIButton *)attentionBT
{
    if (!_attentionBT) {
        _attentionBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBT.titleLabel setFont:Font(14)];
        [_attentionBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_attentionBT setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBT setBackgroundColor:RedLeverColor1];
        [_attentionBT.layer setCornerRadius:13];
        [_attentionBT setFrame:CGRectMake(self.cancelBT.left-50, (self.bottomView.height-26)/2, 50, 26)];
        [_attentionBT addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBT;
}

- (UIButton *)cancelBT
{
    if (!_cancelBT) {
        _cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBT.titleLabel setFont:Font(14)];
        [_cancelBT setTitleColor:RedLeverColor1 forState:UIControlStateNormal];
        [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBT setBackgroundColor:[UIColor clearColor]];
        [_cancelBT setFrame:CGRectMake(self.bottomView.width-50, 0, 50, self.bottomView.height)];
        [_cancelBT addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBT;
}
@end
