//
//  JTCardViewHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTBullet.h"
#import "JTCardViewHeadView.h"

@implementation JTBulletMenu

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.centerBtn];
        [self addSubview:self.rightSwitch];
        self.backgroundColor = UIColorFromRGB(0x4c4c4c);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(self.bounds.size.height,self.bounds.size.height)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
    }
    return self;
}

- (void)leftBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(bulletMenuResponse:)]) {
        [_delegate bulletMenuResponse:sender.selected ? JTBulletMenuShow : JTBulletMenuDismiss];
    }
}

- (void)centerBtnClick:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(bulletMenuResponse:)]) {
        [_delegate bulletMenuResponse:JTBulletSendMsg];
    }
}

- (void)rightSwitchClick:(UISwitch *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(bulletMenuResponse:)]) {
        [_delegate bulletMenuResponse:sender.isOn ? JTBulletTurnOn : JTBulletTurnOff];
    }
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, (self.bounds.size.height - 32) / 2.0, 32, 32)];
        _leftBtn.layer.cornerRadius = 16;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.titleLabel.font = Font(16);
        _leftBtn.backgroundColor = BlueLeverColor1;
        [_leftBtn setTitle:@"弹" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame) + 10, (self.bounds.size.height - 32) / 2.0, 32, 32)];
        _centerBtn.layer.cornerRadius = 16;
        _centerBtn.layer.masksToBounds = YES;
        _centerBtn.titleLabel.font = Font(16);
        _centerBtn.backgroundColor = WhiteColor;
        [_centerBtn setTitle:@"发" forState:UIControlStateNormal];
        [_centerBtn setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}

- (UISwitch *)rightSwitch{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.centerBtn.frame) + 10, (self.bounds.size.height - 32) / 2.0, 52, 32)];
        [_rightSwitch setOnTintColor:BlueLeverColor1];
        [_rightSwitch setOn:YES];
        [_rightSwitch addTarget:self action:@selector(rightSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}
@end


@interface JTCardViewHeadView () <JTBulletMenuDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) int currentPage;

@end

@implementation JTCardViewHeadView

- (void)dealloc {
    [[ZTBullet manager]  zt_stopAction];
    if ([self.fuid isEqualToString:[JTUserInfo shareUserInfo].userID]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userBullentsChangedNotificationName" object:nil];
    }
    
    CCLOG(@"JTCardViewHeadView销毁");
}

- (instancetype)initWithFrame:(CGRect)frame fuid:(NSString *)fuid{
    self = [super initWithFrame:frame];
    if (self) {
        self.fuid = fuid;
        [self addSubview:self.carouselView];
        [self addSubview:self.bulletMenu];
        [self configBullet];
        if ([fuid isEqualToString:[JTUserInfo shareUserInfo].userID]) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userBullentsChanged:) name:@"userBullentsChangedNotificationName" object:nil];
        }
        
    }
    return self;
}

- (void)userBullentsChanged:(NSNotification *)notice {
    [self loadBulletData];
}

- (void)configBullet {
    __weak typeof (self) weakSelf = self;
    [ZTBullet manager].generateViewBlock = ^(ZTBulletView *bulletView) {
        [weakSelf addBulletView:bulletView];
    };
    [self loadBulletData];
}

- (void)configHeadViewImgs:(NSArray *)imgs avatarUrl:(NSString *)avatarUrl {
    NSMutableArray *array = [NSMutableArray arrayWithArray:imgs];
    for (int i = 0; i < array.count; i++) {
        if ([avatarUrl isEqualToString:array[i]]) {
            [array exchangeObjectAtIndex:0 withObjectAtIndex:i];
            break;
        }
    }
    self.carouselView.urlImages = array;
}

#pragma mark JTCardViewHeadViewDelegate
- (void)bulletMenuResponse:(JTBulletFuctionType)fucType{
    switch (fucType) {
        case JTBulletMenuShow:
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.bulletMenu setX:App_Frame_Width-146];
            }];
        }
            break;
        case JTBulletMenuDismiss:
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.bulletMenu setX:App_Frame_Width-44];
            }];
        }
            break;
        case JTBulletSendMsg:
            if (_delegate && [_delegate respondsToSelector:@selector(bulletMenuResponse:)]) {
                [_delegate bulletMenuResponse:JTBulletSendMsg];
            }
            break;
        case JTBulletTurnOn:
            [[ZTBullet manager] zt_startBulletsAction];
            break;
        case JTBulletTurnOff:
            [[ZTBullet manager]  zt_stopAction];
            break;
        default:
            break;
    }
}

- (void)loadBulletData {
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(BulletListApi) parameters:@{@"uid" : self.fuid} success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        NSArray *list = responseObject[@"list"];
        [ZTBullet manager].dataSources = [NSMutableArray arrayWithArray:list];
        [[ZTBullet manager] zt_startBulletsAction];
    } failure:^(NSError *error) {
        
    }];
}

- (void)addBulletView:(ZTBulletView *)bulltView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    bulltView.frame = CGRectMake(width,  kStatusBarHeight+kTopBarHeight+bulltView.trajectory * (bulltView.bounds.size.height+10)+20, bulltView.bounds.size.width, bulltView.bounds.size.height);
    [self addSubview:bulltView];
    [bulltView zt_startAnimation];
}

- (JTBulletMenu *)bulletMenu{
    if (!_bulletMenu) {
        _bulletMenu = [[JTBulletMenu alloc] initWithFrame:CGRectMake(App_Frame_Width-44, 206, 146, 44)];
        _bulletMenu.delegate = self;
    }
    return _bulletMenu;
}

- (KCarouselView *)carouselView {
    if (!_carouselView) {
        _carouselView = [[KCarouselView alloc] init];
        _carouselView.frame = self.bounds;
        _carouselView.pageColor = BlackLeverColor1;
        _carouselView.currentPageColor = BlueLeverColor1;
        _carouselView.pageControlPosition = KPageContolPositionBottomCenter;
        _carouselView.showPageControl = YES;
    }
    return _carouselView;
}
@end
