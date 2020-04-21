//
//  JTOrderStatusView.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderStatusView.h"

@implementation JTOrderStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLB];
        [self addSubview:self.subtitleLB];
        [self addSubview:self.detailLB];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        self.backgroundColor = WhiteColor;
        [self configOrderStatusView];
    }
    return self;
}

- (void)configOrderStatusView {
    
    [self.titleLB setText:@"预约成功"];
    [self.titleLB setTextColor:UIColorFromRGB(0xffa056)];
    [self.subtitleLB setText:@"预约订单会提前30分钟通知到您哦~"];
    [self.detailLB setText:@"预约时间：05-09  15:00开始  18:00结束"];
    [self.leftBtn setImage:[UIImage imageNamed:@"icon_phone_white"] forState:UIControlStateNormal];
    [self.leftBtn setTitle:@"商家电话" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.leftBtn setBackgroundColor:BlueLeverColor2];
    [self.rightBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
    [self.rightBtn.layer setBorderColor:BlackLeverColor2.CGColor];
    [self.rightBtn.layer setBorderWidth:1];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(18);
        _titleLB.frame = CGRectMake(20, 13, 80, 25);
    }
    return _titleLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.frame = CGRectMake(CGRectGetMaxX(self.titleLB.frame)+5, 13, self.width-CGRectGetMaxX(self.titleLB.frame)-10, 25);
        _subtitleLB.font = Font(16);
        _subtitleLB.textColor = BlackLeverColor3;
    }
    return _subtitleLB;
}

- (UILabel *)detailLB {
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = Font(14);
        _detailLB.frame = CGRectMake(20, CGRectGetMaxY(self.titleLB.frame), self.width-40, 20);
        _detailLB.textColor = BlackLeverColor6;
    }
    return _detailLB;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.titleLabel.font = Font(14);
        _leftBtn.frame = CGRectMake(20, CGRectGetMaxY(self.detailLB.frame)+15, 100, 32);
        _leftBtn.layer.cornerRadius = 2;
        _leftBtn.layer.masksToBounds = YES;
        
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.frame = CGRectMake(CGRectGetMaxX(self.leftBtn.frame)+10, CGRectGetMaxY(self.detailLB.frame)+15, 86, 32);
        _rightBtn.titleLabel.font = Font(14);
        _rightBtn.layer.cornerRadius = 2;
        _rightBtn.layer.masksToBounds = YES;
    }
    return _rightBtn;
}

@end
