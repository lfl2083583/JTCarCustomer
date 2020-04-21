//
//  JTRescueEvaluateTableHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIImage+Extension.h"
#import "JTRescueEvaluateTableHeadView.h"

@interface JTRescueEvaluateTableHeadView ()

@property (nonatomic, copy) NSString *str2;

@end

@implementation JTRescueEvaluateTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)btnClick:(UIButton *)sender {
    if (!sender.selected) {
        self.leftBtn.selected = NO;
        self.rightBtn.selected = NO;
        sender.selected = YES;
        [self.titleLB setText:(sender.tag == 0)?self.str1:self.str2];
        if (_delegate && [_delegate respondsToSelector:@selector(evaluateBtnClick:)]) {
            [_delegate evaluateBtnClick:sender.tag];
        }
    }
}

- (void)setupViews {
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    self.backgroundColor = WhiteColor;
}

- (void)didMoveToWindow
{
    if (self.window) {
        [self addSubview:self.titleLB];
        self.str1 = self.str1?self.str1:@"请选择满意的标签类型，支持多选(必填)";
        self.str2 = @"请选择不满意的标签类型，支持多选(必填)";
        CGSize size = [Utility getTextString:self.str1 textFont:Font(12) frameWidth:App_Frame_Width-30 attributedString:nil];
        CGFloat width = (self.width - size.width - 28 * 2 - 20) / 2.0;
        [self.titleLB setText:self.str1];
        
        for (int i = 0; i < 2; i++) {
            UIView *horizonView = [[UIView alloc] initWithFrame:CGRectMake((i==0)?28:self.width-28-width, CGRectGetMaxY(self.leftBtn.frame)+49, width, 1)];
            [horizonView setBackgroundColor:BlackLeverColor2];
            [horizonView setCenterY:self.titleLB.centerY];
            [self addSubview:horizonView];
        }
    }
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (self.leftBtn.hidden?0:CGRectGetMaxY(self.leftBtn.frame))+40, self.width-30, 18)];
        [_titleLB setFont:Font(12)];
        [_titleLB setTextColor:BlackLeverColor3];
        [_titleLB setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLB;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(App_Frame_Width/2.0-88, 30, 82, 30)];
        [_leftBtn.titleLabel setFont:Font(14)];
        [_leftBtn setTag:0];
        [_leftBtn setSelected:YES];
        _leftBtn.layer.cornerRadius = 2;
        _leftBtn.layer.borderColor = BlackLeverColor2.CGColor;
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.masksToBounds = YES;
        [_leftBtn setTitle:@"满意" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_leftBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
        [_leftBtn setBackgroundImage:[UIImage graphicsImageWithColor:UIColorFromRGB(0xf9f9f9) rect:_leftBtn.bounds] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage graphicsImageWithColor:BlueLeverColor1 rect:_leftBtn.bounds] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame)+12, 30, 82, 30)];
        [_rightBtn.titleLabel setFont:Font(14)];
        [_rightBtn setTag:1];
        _rightBtn.layer.cornerRadius = 2;
        _rightBtn.layer.borderColor = BlackLeverColor2.CGColor;
        _rightBtn.layer.borderWidth = 1;
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn setTitle:@"不满意" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_rightBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
        [_rightBtn setBackgroundImage:[UIImage graphicsImageWithColor:UIColorFromRGB(0xf9f9f9) rect:_rightBtn.bounds] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage graphicsImageWithColor:BlueLeverColor1 rect:_rightBtn.bounds] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
