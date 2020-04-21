//
//  JTCarItemView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarItemView.h"

@interface JTCarItemView ()

@property (strong, nonatomic) UIButton *addBT;
@property (strong, nonatomic) UIImageView *carIcon;
@property (strong, nonatomic) UILabel *carNameLB;
@property (strong, nonatomic) UILabel *carNumberLB;
@property (strong, nonatomic) UIButton *carStatusBT;
@property (strong, nonatomic) UIButton *carDefaultBT;

@end

@implementation JTCarItemView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCarItemViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:delegate];
        [self.layer setCornerRadius:4.];
        [self setClipsToBounds:YES];
        [self setBackgroundColor:WhiteColor];
        [self initSubview];
    }
    return self;
}

- (void)setModel:(JTCarModel *)model
{
    _model = model;
    [self.carIcon sd_setImageWithURL:[NSURL URLWithString:[model.icon avatarHandleWithSquare:self.carIcon.width*2]]];
    [self.carNameLB setText:model.name];
    [self.carNumberLB setText:model.number];
    if (model.isAuth == 1) {
        [self.carStatusBT setImage:[UIImage imageNamed:@"icon_auth"] forState:UIControlStateNormal];
        [self.carStatusBT setUserInteractionEnabled:NO];
    }
    else
    {
        [self.carStatusBT setImage:[UIImage imageNamed:(model.isAuth == 2)?@"icon_authing":@"icon_unAuth"] forState:UIControlStateNormal];
        [self.carStatusBT setUserInteractionEnabled:YES];
    }
    if (model.isDefault) {
        [self.carDefaultBT setImage:[UIImage imageNamed:@"icon_default_car"] forState:UIControlStateNormal];
        [self.carDefaultBT setUserInteractionEnabled:NO];
        [self.carDefaultBT setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    else
    {
        [self.carDefaultBT setImage:[UIImage imageNamed:@"icon_unDefault_car"] forState:UIControlStateNormal];
        [self.carDefaultBT setUserInteractionEnabled:YES];
        [self.carDefaultBT setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
}

- (void)setIsHideSubView:(BOOL)isHideSubView
{
    _isHideSubView = isHideSubView;
    
    [self.addBT setHidden:!isHideSubView];
    [self.carIcon setHidden:isHideSubView];
    [self.carNameLB setHidden:isHideSubView];
    [self.carNumberLB setHidden:isHideSubView];
    [self.carStatusBT setHidden:isHideSubView];
    [self.carDefaultBT setHidden:isHideSubView];
}

- (void)addClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carItemView:carOperationType:)]) {
        [_delegate carItemView:self carOperationType:JTCarOperationTypeAdd];
    }
}

- (void)authClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carItemView:carOperationType:)]) {
        [_delegate carItemView:self carOperationType:JTCarOperationTypeAuth];
    }
}

- (void)defaultClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carItemView:carOperationType:)]) {
        [_delegate carItemView:self carOperationType:JTCarOperationTypeDefault];
    }
}

- (UIButton *)addBT
{
    if (!_addBT) {
        _addBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBT setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_addBT setTitle:@"+ 添加爱车" forState:UIControlStateNormal];
        [_addBT.titleLabel setFont:Font(20)];
        [_addBT addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addBT setFrame:self.bounds];
    }
    return _addBT;
}

- (UIImageView *)carIcon
{
    if (!_carIcon) {
        _carIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.height-50)/2, 50, 50)];
        _carIcon.layer.cornerRadius = 25;
        _carIcon.layer.borderWidth = .5;
        _carIcon.layer.borderColor = BlackLeverColor2.CGColor;
        _carIcon.clipsToBounds = YES;
        _carIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _carIcon;
}

- (UILabel *)carNameLB
{
    if (!_carNameLB) {
        _carNameLB = [[UILabel alloc] initWithFrame:CGRectMake(self.carIcon.right+20, self.carIcon.top+3, self.width-self.carIcon.right-35, 15)];
        _carNameLB.textColor = BlackLeverColor6;
        _carNameLB.font = Font(16);
    }
    return _carNameLB;
}

- (UILabel *)carNumberLB
{
    if (!_carNumberLB) {
        _carNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(self.carNameLB.left, self.carNameLB.bottom+5, self.carNameLB.width, 15)];
        _carNumberLB.textColor = BlackLeverColor3;
        _carNumberLB.font = Font(12);
    }
    return _carNumberLB;
}

- (UIButton *)carStatusBT
{
    if (!_carStatusBT) {
        _carStatusBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carStatusBT addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
        [_carStatusBT setFrame:CGRectMake(self.carNameLB.left, self.carNumberLB.bottom+5, 60, 22)];
        [_carStatusBT setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _carStatusBT;
}

- (UIButton *)carDefaultBT
{
    if (!_carDefaultBT) {
        _carDefaultBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carDefaultBT addTarget:self action:@selector(defaultClick:) forControlEvents:UIControlEventTouchUpInside];
        [_carDefaultBT setFrame:CGRectMake(self.width-83, 15, 83, 20)];
    }
    return _carDefaultBT;
}

- (void)initSubview
{
    [self addSubview:self.addBT];
    [self addSubview:self.carIcon];
    [self addSubview:self.carNameLB];
    [self addSubview:self.carNumberLB];
    [self addSubview:self.carStatusBT];
    [self addSubview:self.carDefaultBT];
}


@end
