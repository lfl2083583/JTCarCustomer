//
//  JTCarCertificationStatusView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarCertificationStatusView.h"

@interface JTCarCertificationStatusView ()

@property (nonatomic, assign) NSInteger carAuthStatus;

@end

@implementation JTCarCertificationStatusView

- (instancetype)initWithFrame:(CGRect)frame carAuthStatus:(NSInteger)carAuthStatus {
    self = [super initWithFrame:frame];
    if (self) {
        _carAuthStatus = carAuthStatus;
        [self addSubview:self.iconView];
        [self addSubview:self.titleLB];
        [self addSubview:self.subtitle];
        self.backgroundColor = WhiteColor;
        
        if (carAuthStatus == 1) {

            self.titleLB.text = @"您的爱车已认证成功";
        }
        else if (carAuthStatus == 2)
        {
            self.titleLB.text = @"认证审核中";
            self.subtitle.text = @"1-3个工作日内审核完成，请耐心等待审核";
        }
        else {
           self.titleLB.text = @"认证失败";
        }
    }
    return self;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        UIImage *image = (self.carAuthStatus == 1)?[UIImage imageNamed:@"center_real_sucess"]:[UIImage imageNamed:@"center_real_unaudit"];
        _iconView = [[UIImageView alloc] initWithImage:image];
        _iconView.centerY = self.centerY-20;
        _iconView.centerX = self.centerX;
    }
    return _iconView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.frame = CGRectMake(10, CGRectGetMaxY(self.iconView.frame)+((self.carAuthStatus == 1)?25:5), App_Frame_Width-20, 20);
        _titleLB.font = Font(18);
        _titleLB.textColor = BlueLeverColor1;
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}

- (UILabel *)subtitle {
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        _subtitle.frame = CGRectMake(10, CGRectGetMaxY(self.titleLB.frame)+5, App_Frame_Width-20, 20);
        _subtitle.font = Font(16);
        _subtitle.textColor = BlackLeverColor3;
        _subtitle.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitle;
}

@end
