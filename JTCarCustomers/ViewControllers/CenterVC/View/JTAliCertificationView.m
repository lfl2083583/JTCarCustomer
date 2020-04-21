//
//  JTAliCertificationView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTAliCertificationView.h"

@implementation JTAliCertificationAuditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLB];
        [self addSubview:self.topLB];
        [self addSubview:self.centerLB];
        [self addSubview:self.bottomBtn];
        self.backgroundColor = WhiteColor;
        [self configAliCertificationView];
    }
    return self;
}

- (void)bottomBtnClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}

- (void)configAliCertificationView {
    self.topLB.text = @"恭喜你个人实名认证成功\n你提交的认证资料已通过审核";
    self.centerLB.text = @"XXXXX\n14273****************************19";
    [Utility richTextLabel:self.topLB fontNumber:Font(18) andRange:NSMakeRange(0, 11) andColor:BlackLeverColor6];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(22, kStatusBarHeight+kTopBarHeight, self.width-44, 40)];
        _titleLB.font = Font(24);
        _titleLB.text = @"芝麻认证";
    }
    return _titleLB;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame)+43, self.width, 50)];
        _topLB.font = Font(16);
        _topLB.textColor = BlackLeverColor3;
        _topLB.textAlignment = NSTextAlignmentCenter;
        _topLB.numberOfLines = 0;
    }
    return _topLB;
}

- (UILabel *)centerLB {
    if (!_centerLB) {
        _centerLB = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.topLB.frame)+56, self.width-44, 80)];
        _centerLB.font = Font(14);
        _centerLB.textColor = BlackLeverColor6;
        _centerLB.textAlignment = NSTextAlignmentCenter;
        _centerLB.numberOfLines = 0;
    }
    return _centerLB;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, self.height-185, self.width-44, 45)];
        [_bottomBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = Font(14);
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end

@implementation JTAliCertificationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLB];
        [self addSubview:self.topLB];
        [self addSubview:self.centerLB];
        [self addSubview:self.bottomBtn];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self configAliCertificationView];
    }
    return self;
}

- (void)configAliCertificationView {
    self.topLB.text = @"支付宝账号138******27";
    self.centerLB.text = @"登陆后溜车将获得以下权限：\n\n获得你的公开信息（登录名、昵称、头像等）\n使用身份信息（姓名、手机号、证件号码）办理业务";
    [Utility richTextLabel:self.centerLB fontNumber:Font(16) andRange:NSMakeRange(0, 13) andColor:BlackLeverColor6];
}

- (void)bottomBtnClick:(id)sender {
    [self addSubview:self.auditView];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(22, kStatusBarHeight+kTopBarHeight, self.width-44, 40)];
        _titleLB.font = Font(24);
        _titleLB.text = @"芝麻认证";
    }
    return _titleLB;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame)+43, self.width, 25)];
        _topLB.font = Font(18);
        _topLB.textColor = BlackLeverColor6;
        _topLB.textAlignment = NSTextAlignmentCenter;
    }
    return _topLB;
}

- (UILabel *)centerLB {
    if (!_centerLB) {
        _centerLB = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.topLB.frame)+35, self.width-44, 80)];
        _centerLB.font = Font(14);
        _centerLB.textColor = BlackLeverColor3;
        _centerLB.numberOfLines = 0;
    }
    return _centerLB;
}

- (JTGradientButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[JTGradientButton alloc] init];
        _bottomBtn.frame = CGRectMake((self.width - 300) / 2.0, self.height-185, 300, 45);
        [_bottomBtn setTitle:@"绑定并登录" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, CGRectGetMinY(self.bottomBtn.frame)-60, 30, 30)];
        [_leftBtn setImage:[UIImage imageNamed:@"icon_accessory_selected"] forState:UIControlStateNormal];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame)+5, CGRectGetMinY(self.bottomBtn.frame)-60, 150, 30)];
        [_rightBtn setTitle:@"同意《用户授权协议》" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = Font(14);
    }
    return _rightBtn;
}

- (JTAliCertificationAuditView *)auditView {
    if (!_auditView) {
        _auditView = [[JTAliCertificationAuditView alloc] initWithFrame:self.bounds];
    }
    return _auditView;
}

@end
