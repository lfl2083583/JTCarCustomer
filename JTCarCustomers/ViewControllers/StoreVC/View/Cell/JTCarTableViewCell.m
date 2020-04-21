//
//  JTCarTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarTableViewCell.h"

@implementation JTCarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initSubview];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(JTCarModel *)model
{
    _model = model;
    [self.carIcon sd_setImageWithURL:[NSURL URLWithString:[model.icon avatarHandleWithSquare:self.carIcon.width*2]]];
    [self.carModelLB setText:model.model];
    [self.carNamelLB setText:model.name];
    [self.carNumberLB setText:[NSString stringWithFormat:@"%@ %@", model.number, model.mileageStr]];

    self.carStatusBT.left = [Utility getTextString:self.carModelLB.text textFont:self.carModelLB.font frameWidth:MAXFLOAT attributedString:nil].width + self.carModelLB.left + 15;
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

- (void)authClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carTableViewCell:carOperationType:)]) {
        [_delegate carTableViewCell:self carOperationType:JTCarOperationTypeAuth];
    }
}

- (void)defaultClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carTableViewCell:carOperationType:)]) {
        [_delegate carTableViewCell:self carOperationType:JTCarOperationTypeDefault];
    }
}

- (void)deleteClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carTableViewCell:carOperationType:)]) {
        [_delegate carTableViewCell:self carOperationType:JTCarOperationTypeDelete];
    }
}

- (void)editClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carTableViewCell:carOperationType:)]) {
        [_delegate carTableViewCell:self carOperationType:JTCarOperationTypeEdit];
    }
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, App_Frame_Width-30, 135)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 4.;
        _bottomView.layer.shadowColor = UIColorFromRGBoraAlpha(0x000000, .4).CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(2, 2);
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowRadius = 4;
    }
    return _bottomView;
}

- (UIImageView *)carIcon
{
    if (!_carIcon) {
        _carIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.bottomView.height-50)/2, 50, 50)];
        _carIcon.layer.cornerRadius = 25;
        _carIcon.layer.borderWidth = .5;
        _carIcon.layer.borderColor = BlackLeverColor2.CGColor;
        _carIcon.clipsToBounds = YES;
        _carIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _carIcon;
}

- (UILabel *)carModelLB
{
    if (!_carModelLB) {
        _carModelLB = [[UILabel alloc] initWithFrame:CGRectMake(self.carIcon.right+20, self.carIcon.top, self.bottomView.width-self.carIcon.right-35, 20)];
        _carModelLB.textColor = BlackLeverColor6;
        _carModelLB.font = BoldFont(16);
    }
    return _carModelLB;
}

- (UILabel *)carNamelLB
{
    if (!_carNamelLB) {
        _carNamelLB = [[UILabel alloc] initWithFrame:CGRectMake(self.carModelLB.left, self.carModelLB.bottom+5, self.carModelLB.width, 15)];
        _carNamelLB.textColor = BlackLeverColor6;
        _carNamelLB.font = Font(16);
    }
    return _carNamelLB;
}

- (UILabel *)carNumberLB
{
    if (!_carNumberLB) {
        _carNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(self.carNamelLB.left, self.carNamelLB.bottom+5, self.carNamelLB.width, 12)];
        _carNumberLB.textColor = BlackLeverColor3;
        _carNumberLB.font = Font(14);
    }
    return _carNumberLB;
}

- (UIButton *)carStatusBT
{
    if (!_carStatusBT) {
        _carStatusBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carStatusBT addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
        [_carStatusBT setSize:CGSizeMake(60, 22)];
        [_carStatusBT setCenterY:self.carModelLB.centerY];
        [_carStatusBT setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _carStatusBT;
}

- (UIButton *)carDefaultBT
{
    if (!_carDefaultBT) {
        _carDefaultBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carDefaultBT addTarget:self action:@selector(defaultClick:) forControlEvents:UIControlEventTouchUpInside];
        [_carDefaultBT setFrame:CGRectMake(self.bottomView.width-83, 15, 83, 20)];
    }
    return _carDefaultBT;
}

- (UIButton *)carDeleteBT
{
    if (!_carDeleteBT) {
        _carDeleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carDeleteBT setImage:[UIImage imageNamed:@"activity_delete_icon"] forState:UIControlStateNormal];
        [_carDeleteBT addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_carDeleteBT setFrame:CGRectMake(self.bottomView.width-55, self.bottomView.height-40, 40, 40)];
    }
    return _carDeleteBT;
}

- (UIButton *)carEditBT
{
    if (!_carEditBT) {
        _carEditBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carEditBT setImage:[UIImage imageNamed:@"activity_edit_icon"] forState:UIControlStateNormal];
        [_carEditBT addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        [_carEditBT setFrame:CGRectMake(self.carDeleteBT.left-40, self.bottomView.height-40, 40, 40)];
    }
    return _carEditBT;
}

- (void)initSubview
{
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.carIcon];
    [self.bottomView addSubview:self.carModelLB];
    [self.bottomView addSubview:self.carNamelLB];
    [self.bottomView addSubview:self.carNumberLB];
    [self.bottomView addSubview:self.carStatusBT];
    [self.bottomView addSubview:self.carDefaultBT];
    [self.bottomView addSubview:self.carDeleteBT];
    [self.bottomView addSubview:self.carEditBT];
}

@end
