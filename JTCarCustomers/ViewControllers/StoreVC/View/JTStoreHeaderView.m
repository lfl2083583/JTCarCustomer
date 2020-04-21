//
//  JTStoreHeaderView.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreHeaderView.h"
#import "JTCarCertificationRewardViewController.h"

@interface JTStoreHeaderView ()

@property (strong, nonatomic) UIImageView *bottomImage;
@property (strong, nonatomic) ZTCirlceImageView *carImage;
@property (strong, nonatomic) UILabel *carNumberLB;
@property (strong, nonatomic) UILabel *carModelLB;
@property (strong, nonatomic) UIButton *carStatusBT;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *maintainBT;
@property (strong, nonatomic) UIButton *faultBT;
@property (strong, nonatomic) UIButton *rescueBT;
@property (strong, nonatomic) UIButton *parkingLotBT;

@end

@implementation JTStoreHeaderView

- (instancetype)initWithStoreHeaderViewDelegate:(id<JTStoreHeaderViewDelegate>)storeHeaderViewDelegate
{
    self = [super init];
    if (self) {
        [self setStoreHeaderViewDelegate:storeHeaderViewDelegate];
        [self initSubview];
        [self setFrame:CGRectMake(0, 0, App_Frame_Width, self.bottomView.bottom + 15)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self reloadData];
    }
    return self;
}

- (void)reloadData
{
    JTCarModel *model = ([JTUserInfo shareUserInfo].myCarList.count > 0) ? [[JTUserInfo shareUserInfo].myCarList objectAtIndex:0] : nil;
    if (model == nil) {
        self.carImage.image = [UIImage imageNamed:@"icon_car_add"];
        self.carNumberLB.text = @"添加爱车";
        self.carModelLB.text = @"";
        self.carModelLB.hidden = YES;
        self.carStatusBT.hidden = YES;
        self.carNumberLB.frame = CGRectMake(self.carImage.right+8, self.carImage.top, App_Frame_Width - self.carImage.right - 16, self.carImage.height);
    }
    else
    {
        [self.carImage zt_setImageWithURL:[NSURL URLWithString:[model.icon avatarHandleWithSquare:self.carImage.width*2]]];
        [self.carNumberLB setText:model.number];
        [self.carModelLB setText:model.model];
        [self.carStatusBT setHidden:NO];
        [self.carStatusBT setImage:[UIImage imageNamed:(model.isAuth == 1)?@"icon_auth":((model.isAuth == 2)?@"icon_authing":@"icon_unAuth")] forState:UIControlStateNormal];
        [self.carModelLB setHidden:NO];
        [self.carNumberLB setFrame:CGRectMake(self.carImage.right+8, self.carImage.centerY-20, App_Frame_Width - self.carImage.right - 16, 20)];
    }
}

- (void)initSubview
{
    [self addSubview:self.bottomImage];
    [self addSubview:self.carImage];
    [self addSubview:self.carNumberLB];
    [self addSubview:self.carModelLB];
    [self addSubview:self.carStatusBT];
    [self addSubview:self.bottomView];
    [self addSubview:self.maintainBT];
    [self addSubview:self.faultBT];
    [self addSubview:self.rescueBT];
    [self addSubview:self.parkingLotBT];
    [self addSubview:[Utility initLineRect:CGRectMake(self.bottomView.left, self.maintainBT.bottom, self.bottomView.width, .5) lineColor:BlackLeverColor2]];
    [self addSubview:[Utility initLineRect:CGRectMake(self.maintainBT.right, self.bottomView.top, .5, self.bottomView.height) lineColor:BlackLeverColor2]];
}

- (void)authClick:(id)sender
{
    JTCarModel *model = ([JTUserInfo shareUserInfo].myCarList.count > 0) ? [[JTUserInfo shareUserInfo].myCarList objectAtIndex:0] : nil;
    if (model.isAuth != 1) {
        [[Utility currentViewController].navigationController pushViewController:[[JTCarCertificationRewardViewController alloc] initCarModel:model] animated:YES];
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (_storeHeaderViewDelegate && [_storeHeaderViewDelegate respondsToSelector:@selector(storeHeaderView:didSelectHeaderAtType:)]) {
        [_storeHeaderViewDelegate storeHeaderView:self didSelectHeaderAtType:button.tag];
    }
}

- (UIImageView *)bottomImage
{
    if (!_bottomImage) {
        _bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(kStatusBarHeight + kTopBarHeight), App_Frame_Width, self.bottomView.bottom + 15 + kStatusBarHeight + kTopBarHeight)];
        if (kScreenWidth == 320) {
            
        }
        _bottomImage.image = [UIImage imageNamed:((kScreenWidth == 320)?@"bg_storeHeader_640":((kScreenWidth == 375)?@"bg_storeHeader_750":@"bg_storeHeader_1242"))];
    }
    return _bottomImage;
}

- (ZTCirlceImageView *)carImage
{
    if (!_carImage) {
        _carImage = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    }
    return _carImage;
}

- (UILabel *)carNumberLB
{
    if (!_carNumberLB) {
        _carNumberLB = [[UILabel alloc] init];
        _carNumberLB.font = Font(20);
        _carNumberLB.textColor = WhiteColor;
        _carNumberLB.frame = CGRectMake(self.carImage.right+8, self.carImage.centerY-25, 100, 25);
    }
    return _carNumberLB;
}

- (UILabel *)carModelLB
{
    if (!_carModelLB) {
        _carModelLB = [[UILabel alloc] init];
        _carModelLB.font = Font(12);
        _carModelLB.textColor = WhiteColor;
        _carModelLB.frame = CGRectMake(self.carImage.right+8, self.carImage.centerY, App_Frame_Width - self.carImage.right - 16, 20);
    }
    return _carModelLB;
}

- (UIButton *)carStatusBT
{
    if (!_carStatusBT) {
        _carStatusBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _carStatusBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _carStatusBT.frame = CGRectMake(self.carNumberLB.right+5, self.carNumberLB.top, 60, 25);
        [_carStatusBT addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carStatusBT;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
        _bottomView.layer.cornerRadius = 5;
        CGFloat height = (App_Frame_Width - 30)*160./350.;
        _bottomView.frame = CGRectMake(15, self.carImage.bottom + 15, App_Frame_Width-30, height);
    }
    return _bottomView;
}

- (UIButton *)maintainBT
{
    if (!_maintainBT) {
        _maintainBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maintainBT setImage:[UIImage imageNamed:@"icon_maintain"] forState:UIControlStateNormal];
        [_maintainBT setTitle:@" 智能保养" forState:UIControlStateNormal];
        [_maintainBT setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_maintainBT.titleLabel setFont:Font(16)];
        [_maintainBT setFrame:CGRectMake(self.bottomView.left, self.bottomView.top, self.bottomView.width/2, self.bottomView.height/2)];
        [_maintainBT setTag:JTStoreHeaderClickTypeMaintain];
        [_maintainBT addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maintainBT;
}

- (UIButton *)faultBT
{
    if (!_faultBT) {
        _faultBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faultBT setImage:[UIImage imageNamed:@"icon_fault"] forState:UIControlStateNormal];
        [_faultBT setTitle:@" 故障自查" forState:UIControlStateNormal];
        [_faultBT setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_faultBT.titleLabel setFont:Font(16)];
        [_faultBT setFrame:CGRectMake(self.maintainBT.right, self.bottomView.top, self.bottomView.width/2, self.bottomView.height/2)];
        [_faultBT setTag:JTStoreHeaderClickTypeFault];
        [_faultBT addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faultBT;
}

- (UIButton *)rescueBT
{
    if (!_rescueBT) {
        _rescueBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rescueBT setImage:[UIImage imageNamed:@"icon_rescue"] forState:UIControlStateNormal];
        [_rescueBT setTitle:@" 道路救援" forState:UIControlStateNormal];
        [_rescueBT setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_rescueBT.titleLabel setFont:Font(16)];
        [_rescueBT setFrame:CGRectMake(self.bottomView.left, self.maintainBT.bottom, self.bottomView.width/2, self.bottomView.height/2)];
        [_rescueBT setTag:JTStoreHeaderClickTypeRescue];
        [_rescueBT addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rescueBT;
}

- (UIButton *)parkingLotBT
{
    if (!_parkingLotBT) {
        _parkingLotBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_parkingLotBT setImage:[UIImage imageNamed:@"icon_parkingLot"] forState:UIControlStateNormal];
        [_parkingLotBT setTitle:@" 预约车位" forState:UIControlStateNormal];
        [_parkingLotBT setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_parkingLotBT.titleLabel setFont:Font(16)];
        [_parkingLotBT setFrame:CGRectMake(self.maintainBT.right, self.maintainBT.bottom, self.bottomView.width/2, self.bottomView.height/2)];
        [_parkingLotBT setTag:JTStoreHeaderClickTypeParkingLot];
        [_parkingLotBT addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _parkingLotBT;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.carImage.frame, touchPoint) || CGRectContainsPoint(self.carNumberLB.frame, touchPoint)) {
        if (_storeHeaderViewDelegate && [_storeHeaderViewDelegate respondsToSelector:@selector(storeHeaderView:didSelectHeaderAtType:)]) {
            [_storeHeaderViewDelegate storeHeaderView:self didSelectHeaderAtType:JTStoreHeaderClickTypeCar];
        }
    }
}

@end
