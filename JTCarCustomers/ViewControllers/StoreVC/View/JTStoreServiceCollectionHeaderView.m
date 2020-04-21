//
//  JTStoreServiceCollectionHeaderView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceCollectionHeaderView.h"
#import "JTCarManageViewController.h"

@implementation JTStoreServiceCollectionHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.carIcon];
        [self.bottomView addSubview:self.titleLB];
        [self.bottomView addSubview:self.subTitleLB];
        [self.bottomView addSubview:self.manageBT];
    }
    return self;
}

- (void)setModel:(JTCarModel *)model
{
    _model = model;
    if (model) {
        [self.bottomView setHidden:NO];
        [self.carIcon setAvatarByUrlString:[model.icon avatarHandleWithSquare:100] defaultImage:nil];
        _titleLB.text = model.name;
        _subTitleLB.text = model.mileageStr;
        [self setFrame:CGRectMake(0, 0, App_Frame_Width, self.bottomView.bottom + 10)];
    }
    else
    {
        [self.bottomView setHidden:YES];
        [self setFrame:CGRectZero];
    }
}

- (void)manageClick:(id)sender
{
    [[Utility currentViewController].navigationController pushViewController:[[JTCarManageViewController alloc] init] animated:YES];
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, App_Frame_Width-30, 70)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 4.;
        _bottomView.layer.shadowColor = UIColorFromRGBoraAlpha(0x000000, .4).CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(2, 2);
        _bottomView.layer.shadowOpacity = 0.5;
    }
    return _bottomView;
}

- (ZTCirlceImageView *)carIcon
{
    if (!_carIcon) {
        _carIcon = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(20, (self.bottomView.height-40)/2, 40, 40)];
        _carIcon.clipsToBounds = YES;
        _carIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _carIcon;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.font = Font(16);
        _titleLB.frame = CGRectMake(self.carIcon.right+15, self.carIcon.top, self.manageBT.left-self.carIcon.right-25, 20);
    }
    return _titleLB;
}

- (UILabel *)subTitleLB
{
    if (!_subTitleLB) {
        _subTitleLB = [[UILabel alloc] init];
        _subTitleLB.textColor = BlackLeverColor3;
        _subTitleLB.font = Font(14);
        _subTitleLB.frame = CGRectMake(self.carIcon.right+15, self.titleLB.bottom, self.bottomView.width-self.carIcon.right-30, 20);
    }
    return _subTitleLB;
}

- (UIButton *)manageBT
{
    if (!_manageBT) {
        _manageBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_manageBT setTitle:@"管理车型" forState:UIControlStateNormal];
        [_manageBT setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_manageBT.titleLabel setFont:Font(14)];
        [_manageBT setFrame:CGRectMake(self.bottomView.width-75, self.carIcon.top, 60, 20)];
        [_manageBT addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manageBT;
}

@end
