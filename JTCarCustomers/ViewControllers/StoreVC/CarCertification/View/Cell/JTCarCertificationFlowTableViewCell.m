//
//  JTCarCertificationFlowTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define Randio 219/328.0
#import "UIImage+Extension.h"
#import "ZTCirlceImageView.h"
#import "JTCarCertificationFlowTableViewCell.h"

@interface JTCarCertificationEntryTableViewCell ()

@property (nonatomic, strong) ZTCirlceImageView *circleView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIButton *entryBtn;
@property (nonatomic, strong) UILabel *subtitleLB;


@end

@implementation JTCarCertificationEntryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.entryBtn];
        [self.contentView addSubview:self.subtitleLB];
        
        __weak typeof(self)weakSelf = self;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.circleView.mas_right).offset(5);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        }];
        
        [self.entryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(23.5);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-23.5);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(20);
            make.height.mas_equalTo(Randio*(App_Frame_Width-47));
        }];
        
        [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.entryBtn.mas_bottom).offset(20);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        }];
    }
    return self;
}

- (void)entryBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(recognizeLicence)]) {
        [_delegate recognizeLicence];
    }
}

- (ZTCirlceImageView *)circleView {
    if (!_circleView) {
        _circleView = [[ZTCirlceImageView alloc] init];
        _circleView.image = [UIImage graphicsImageWithColor:UIColorFromRGB(0xd8d8d8) rect:CGRectMake(0, 0, 20, 20)];
    }
    return _circleView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(14);
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = BlackLeverColor3;
        _titleLB.text = @"请上传您需要认证车辆的行驶证原件正面如有模糊、太暗、有遮挡等不予认证";
    }
    return _titleLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.font = Font(14);
        _subtitleLB.numberOfLines = 0;
        _subtitleLB.textColor = BlackLeverColor3;
        _subtitleLB.text = @"您上传的行驶证照片，溜车承诺仅审核使用，无其他用途，请放心！";
    }
    return _subtitleLB;
}

- (UIButton *)entryBtn {
    if (!_entryBtn) {
        _entryBtn = [[UIButton alloc] init];
        [_entryBtn setBackgroundImage:[UIImage imageNamed:@"drivephone_entry"] forState:UIControlStateNormal];
        [_entryBtn addTarget:self action:@selector(entryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _entryBtn;
}

@end


@implementation JTCarCertificationDescribeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.markView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.describeLB];
        
        __weak typeof(self)weakSelf = self;
        [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(4, 14));
            make.left.equalTo(weakSelf.contentView.mas_left).offset(18);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.markView.mas_right).offset(10);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        }];
        
        [self.describeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
        }];
    
    }
    return self;
}

- (UIView *)markView {
    if (!_markView) {
        _markView = [[UIView alloc] init];
        _markView.backgroundColor = BlueLeverColor1;
    }
    return _markView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor5;
    }
    return _titleLB;
}

- (UILabel *)describeLB {
    if (!_describeLB) {
        _describeLB = [[UILabel alloc] init];
        _describeLB.font = Font(14);
        _describeLB.textColor = BlackLeverColor3;
        _describeLB.numberOfLines = 0;
    }
    return _describeLB;
}

@end

