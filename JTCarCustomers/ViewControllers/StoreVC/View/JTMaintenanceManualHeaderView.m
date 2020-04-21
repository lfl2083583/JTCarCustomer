//
//  JTMaintenanceManualHeaderView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMaintenanceManualHeaderView.h"

@interface JTMaintenanceManualHeaderView ()

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIImageView *carIcon;
@property (strong, nonatomic) UILabel *carModelLB;
@property (strong, nonatomic) UILabel *carNumberLB;

@end

@implementation JTMaintenanceManualHeaderView

- (instancetype)initWithModel:(JTCarModel *)model
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _model = model;
        [self addSubview:self.bottomView];
        [self setFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, self.bottomView.bottom + 10)];
        [self.bottomView addSubview:self.carIcon];
        [self.bottomView addSubview:self.carModelLB];
        [self.bottomView addSubview:self.carNumberLB];
    }
    return self;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, App_Frame_Width-30, 100)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 4.;
        _bottomView.layer.shadowColor = UIColorFromRGBoraAlpha(0x000000, .4).CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(2, 2);
        _bottomView.layer.shadowOpacity = 0.5;
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
        [_carIcon sd_setImageWithURL:[NSURL URLWithString:[self.model.icon avatarHandleWithSquare:100]]];
    }
    return _carIcon;
}

- (UILabel *)carNumberLB
{
    if (!_carNumberLB) {
        _carNumberLB = [[UILabel alloc] init];
        _carNumberLB.textColor = BlackLeverColor5;
        _carNumberLB.font = Font(20);
        _carNumberLB.frame = CGRectMake(self.carIcon.right+20, self.carIcon.centerX-20, self.bottomView.width-self.carIcon.right-35, 20);
        _carNumberLB.text = self.model.number;
    }
    return _carNumberLB;
}

- (UILabel *)carModelLB
{
    if (!_carModelLB) {
        _carModelLB = [[UILabel alloc] init];
        _carModelLB.textColor = BlackLeverColor3;
        _carModelLB.font = Font(12);
        _carModelLB.frame = CGRectMake(self.carIcon.right+20, self.carIcon.centerX, self.bottomView.width-self.carIcon.right-35, 20);
        _carModelLB.text = self.model.model;
    }
    return _carModelLB;
}

@end
