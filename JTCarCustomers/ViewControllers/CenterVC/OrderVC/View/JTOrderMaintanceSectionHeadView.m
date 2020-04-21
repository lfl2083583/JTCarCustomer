//
//  JTOrderMaintanceSectionHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderMaintanceSectionHeadView.h"

@implementation JTOrderMaintanceSectionHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.titleLB];
        [self.bottomView addSubview:self.statusLB];
        
        __weak typeof(self)weakSelf = self;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(0);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bottomView.mas_left).offset(20);
            make.right.equalTo(weakSelf.statusLB.mas_left).offset(-20);
            make.top.equalTo(weakSelf.bottomView.mas_top);
            make.bottom.equalTo(weakSelf.bottomView.mas_bottom);
        }];
        
        [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.bottomView.mas_right).offset(-20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(50);
            make.centerY.equalTo(weakSelf.titleLB.mas_centerY);
        }];
    }
    return self;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(14);
        _titleLB.textColor = BlueLeverColor1;
    }
    return _titleLB;
}

- (UILabel *)statusLB {
    if (!_statusLB) {
        _statusLB = [[UILabel alloc] init];
        _statusLB.font = Font(12);
        _statusLB.textColor = BlueLeverColor1;
        _statusLB.layer.cornerRadius = 2;
        _statusLB.layer.borderWidth = 1;
        _statusLB.layer.borderColor = BlueLeverColor1.CGColor;
        _statusLB.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLB;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

@end
