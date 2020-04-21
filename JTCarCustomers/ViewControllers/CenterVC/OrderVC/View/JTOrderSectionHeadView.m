//
//  JTOrderSectionHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderSectionHeadView.h"

@implementation JTOrderSectionHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.horizontalView];
        self.contentView.backgroundColor = WhiteColor;
        
        __weak typeof(self)weakSelf = self;
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.height.mas_equalTo(10.0);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20.0);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10.0);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = BlackLeverColor1;
    }
    return _topView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
    }
    return _titleLB;
}

- (UIView *)horizontalView {
    if (!_horizontalView) {
        _horizontalView = [[UIView alloc] init];
        _horizontalView.backgroundColor = BlackLeverColor2;
    }
    return _horizontalView;
}

@end
