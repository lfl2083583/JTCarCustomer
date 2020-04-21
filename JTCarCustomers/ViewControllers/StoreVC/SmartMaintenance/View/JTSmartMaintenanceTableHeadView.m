//
//  JTSmartMaintenanceTableHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSmartMaintenanceTableHeadView.h"

@implementation JTSmartMaintenanceTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BlackLeverColor1;
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.carIcon];
        [self.bottomView addSubview:self.rightBtn];
        [self.bottomView addSubview:self.nameLB];
        [self.bottomView addSubview:self.modelLB];
        [self.bottomView addSubview:self.travelLB];
    }
    return self;
}


- (void)rightBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chooseLoveCar)]) {
        [_delegate chooseLoveCar];
    }
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.width-60, 10, 50, 20)];
        _rightBtn.titleLabel.font = Font(14);
        _rightBtn.enabled = NO;
        [_rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, App_Frame_Width-30, 80)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 4.;
        _bottomView.layer.shadowColor = UIColorFromRGBoraAlpha(0x000000, .4).CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(2, 2);
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowRadius = 4;
    }
    return _bottomView;
}

- (ZTCirlceImageView *)carIcon {
    if (!_carIcon) {
        _carIcon = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(22, 15, 50, 50)];
    }
    return _carIcon;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.carIcon.frame)+10, 10, App_Frame_Width-125, 20)];
        _nameLB.textColor = BlackLeverColor6;
        _nameLB.font = Font(16);
    }
    return _nameLB;
}

- (UILabel *)modelLB {
    if (!_modelLB) {
        _modelLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.carIcon.frame)+10, CGRectGetMaxY(self.nameLB.frame), App_Frame_Width-125, 20)];
        _modelLB.textColor = BlackLeverColor6;
        _modelLB.font = Font(16);
    }
    return _modelLB;
}

- (UILabel *)travelLB {
    if (!_travelLB) {
        _travelLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.carIcon.frame)+10, CGRectGetMaxY(self.modelLB.frame), App_Frame_Width-125, 20)];
        _travelLB.textColor = BlackLeverColor3;
        _travelLB.font = Font(14);
    }
    return _travelLB;
}


@end

@implementation JTSmartMaintenanceFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.explainBtn];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.estimatedCostLB];
        [self.bottomView addSubview:self.manhourCostLB];
        [self.bottomView addSubview:self.chooseStoreBtn];
    }
    return self;
}

- (void)explainBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(feeDetailExplain)]) {
        [_delegate feeDetailExplain];
    }
}

- (void)chooseStoreBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chooseMaintenanceStore)]) {
        [_delegate chooseMaintenanceStore];
    }
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, App_Frame_Width, self.height-CGRectGetHeight(_explainBtn.frame))];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UIButton *)explainBtn {
    if (!_explainBtn) {
        _explainBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _explainBtn.titleLabel.font = Font(16);
        [_explainBtn setTitle:@"金额明细说明" forState:UIControlStateNormal];
        [_explainBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_explainBtn setBackgroundColor:UIColorFromRGB(0xcad5ff)];
        [_explainBtn addTarget:self action:@selector(explainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _explainBtn;
}

- (UILabel *)estimatedCostLB {
    if (!_estimatedCostLB) {
        _estimatedCostLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, self.width-130, 20)];
        _estimatedCostLB.font = Font(16);
        _estimatedCostLB.textColor = RedLeverColor1;
        _estimatedCostLB.text = @"预计总价:￥0.00-￥0.00";
    }
    return _estimatedCostLB;
}

- (UILabel *)manhourCostLB {
    if (!_manhourCostLB) {
        _manhourCostLB = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.estimatedCostLB.frame), self.width-130, 20)];
        _manhourCostLB.font = Font(16);
        _manhourCostLB.textColor = BlackLeverColor3;
        _manhourCostLB.text = @"包含工时:￥0.00-￥0.00";
    }
    return _manhourCostLB;
}

- (UIButton *)chooseStoreBtn {
    if (!_chooseStoreBtn) {
        _chooseStoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-100, 0, 100, self.height-CGRectGetHeight(_explainBtn.frame))];
        _chooseStoreBtn.titleLabel.font = Font(18);
        [_chooseStoreBtn setTitle:@"去选店" forState:UIControlStateNormal];
        [_chooseStoreBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_chooseStoreBtn setBackgroundColor:BlueLeverColor1];
        [_chooseStoreBtn addTarget:self action:@selector(chooseStoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseStoreBtn;
}

@end


@implementation JTSmartMaintenanceSectionHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
  
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.titleLB];
        [self.bottomView addSubview:self.horizonView];
    }
    return self;
}

- (UIView *)horizonView {
    if (!_horizonView) {
        _horizonView = [[UIView alloc] initWithFrame:CGRectMake(0, _bottomView.height-0.5, _bottomView.width, 0.5)];
        _horizonView.backgroundColor = BlackLeverColor2;
    }
    return _horizonView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, App_Frame_Width-30, 33)];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _bottomView.width-30, _bottomView.height)];
        _titleLB.font = Font(14);
        _titleLB.textColor = BlueLeverColor1;
    }
    return _titleLB;
}

@end
