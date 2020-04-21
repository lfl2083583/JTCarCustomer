//
//  JTStoreServiceCollectionFooterView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceCollectionFooterView.h"

@interface JTStoreServiceCollectionFooterView ()

@end

@implementation JTStoreServiceCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTStoreServiceCollectionFooterViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.explainBT];
        [self addSubview:self.icon];
        [self addSubview:self.badgeView];
        [self addSubview:self.allPriceLB];
        [self addSubview:self.workPriceLB];
        [self addSubview:[Utility initLineRect:CGRectMake(self.serviceBT.left, self.serviceBT.top + (self.serviceBT.height - 25) / 2, .5, 25) lineColor:BlackLeverColor2]];
        [self addSubview:self.serviceBT];
        [self addSubview:self.confirmBT];
        [self setBackgroundColor:WhiteColor];
        [self setAllPrice:0];
        [self setWorkPrice:0];
        [self setBedge:0];
        _delegate = delegate;
    }
    return self;
}

- (void)setAllPrice:(CGFloat)allPrice
{
    _allPrice = allPrice;
    NSString *price = [NSString stringWithFormat:@"总价：¥%.2f", allPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price];
    [attributedString addAttributes:@{NSFontAttributeName:Font(14)} range:[price rangeOfString:@"总价："]];
    [attributedString addAttributes:@{NSFontAttributeName:Font(12)} range:[price rangeOfString:@"¥"]];
    self.allPriceLB.attributedText = attributedString;
}

- (void)setWorkPrice:(CGFloat)workPrice
{
    _workPrice = workPrice;
    NSString *price = [NSString stringWithFormat:@"包含工时：¥%.2f", workPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price];
    [attributedString addAttributes:@{NSFontAttributeName:Font(12)} range:[price rangeOfString:@"¥"]];
    self.workPriceLB.attributedText = attributedString;
}

- (void)setBedge:(NSInteger)bedge
{
    if (bedge > 0) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld", (long)bedge];
        self.badgeView.centerX = self.icon.right;
    }
    else
    {
        self.badgeView.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.icon.frame, touchPoint)) {
        if (_delegate && [_delegate respondsToSelector:@selector(shoppingCartInStoreServiceCollectionFooterView:)]) {
            [_delegate shoppingCartInStoreServiceCollectionFooterView:self];
        }
    }
}

- (void)confirmClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(makeAnAppointmentInStoreServiceCollectionFooterView:)]) {
        [_delegate makeAnAppointmentInStoreServiceCollectionFooterView:self];
    }
}

- (void)serviceClick:(id)sender
{
    
}

- (UIButton *)explainBT
{
    if (!_explainBT) {
        _explainBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_explainBT setTitle:@"金额明细说明" forState:UIControlStateNormal];
        [_explainBT setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_explainBT.titleLabel setFont:Font(14)];
        [_explainBT setBackgroundColor:BlueLeverColor4];
        [_explainBT setFrame:CGRectMake(0, 0, App_Frame_Width, 30)];
    }
    return _explainBT;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 55, 55)];
        _icon.image = [UIImage imageNamed:@"icon_shoppingCart_normal"];
    }
    return _icon;
}

- (JTBadgeView *)badgeView
{
    if (!_badgeView) {
        _badgeView = [[JTBadgeView alloc] init];
        _badgeView.centerX = self.icon.right;
        _badgeView.centerY = self.icon.top;
    }
    return _badgeView;
}

- (UILabel *)allPriceLB
{
    if (!_allPriceLB) {
        _allPriceLB = [[UILabel alloc] init];
        _allPriceLB.textColor = RedLeverColor1;
        _allPriceLB.font = Font(16);
        _allPriceLB.frame = CGRectMake(self.icon.right+10, self.explainBT.bottom+5, self.serviceBT.left-self.icon.right-20, 20);
    }
    return _allPriceLB;
}

- (UILabel *)workPriceLB
{
    if (!_workPriceLB) {
        _workPriceLB = [[UILabel alloc] init];
        _workPriceLB.textColor = BlackLeverColor3;
        _workPriceLB.font = Font(14);
        _workPriceLB.frame = CGRectMake(self.allPriceLB.left, self.allPriceLB.bottom, self.allPriceLB.width, self.allPriceLB.height);
    }
    return _workPriceLB;
}

- (ZTButtonExt *)serviceBT
{
    if (!_serviceBT) {
        _serviceBT = [ZTButtonExt buttonWithType:UIButtonTypeCustom];
        [_serviceBT setTitle:@"客服咨询" forState:UIControlStateNormal];
        [_serviceBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_serviceBT.titleLabel setFont:Font(12)];
        [_serviceBT setImage:[UIImage imageNamed:@"icon_shopService"] forState:UIControlStateNormal];
        [_serviceBT addTarget:self action:@selector(serviceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_serviceBT setFrame:CGRectMake(self.confirmBT.left-70, self.explainBT.bottom, 70, self.height-self.explainBT.bottom)];
        [_serviceBT centerImageAndTitle];
    }
    return _serviceBT;
}

- (JTGradientButton *)confirmBT
{
    if (!_confirmBT) {
        _confirmBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        _confirmBT.cornerRadius = 0;
        [_confirmBT setTitle:@"去预约" forState:UIControlStateNormal];
        [_confirmBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_confirmBT.titleLabel setFont:Font(18)];
        [_confirmBT addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBT setFrame:CGRectMake(App_Frame_Width-80, self.explainBT.bottom, 80, self.height-self.explainBT.bottom)];
    }
    return _confirmBT;
}
@end
