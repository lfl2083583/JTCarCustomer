//
//  JTCarCertificationRewardTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIImage+Extension.h"
#import "JTCarCertificationRewardTableViewCell.h"

@implementation JTCarCertificationRewardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.giftView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.subtitleLB];
        [self.contentView addSubview:self.rightBtn];
        
        self.backgroundColor = BlackLeverColor1;
        self.userInteractionEnabled = NO;
        __weak typeof(self)weakSelf = self;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.left.equalTo(weakSelf.contentView.mas_left).offset(35);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.giftView.mas_right).offset(23);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
            make.right.equalTo(weakSelf.rightBtn.mas_left).offset(-15);
        }];
        
        [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(5);
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.right.equalTo(weakSelf.titleLB.mas_right);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self configCarCertificationRewardCell];
    }
    return self;
}

- (void)configCarCertificationRewardCell {
    self.titleLB.text = @"免费洗车5次";
    self.subtitleLB.text = @"仅限自营店，认证可领取5次免费洗车劵";
    self.giftView.image = [UIImage imageNamed:@"team_housing_seleted"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UIImageView *)giftView {
    if (!_giftView) {
        _giftView = [[UIImageView alloc] init];
    }
    return _giftView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor5;
        _titleLB.font = Font(20);
    }
    return _titleLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.textColor = BlackLeverColor3;
        _subtitleLB.font = Font(12);
        _subtitleLB.numberOfLines = 0;
    }
    return _subtitleLB;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.titleLabel.font = Font(16);
        _rightBtn.layer.cornerRadius = 15;
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_rightBtn setTitle:@"领取" forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage graphicsImageWithColor:BlueLeverColor1 rect:CGRectMake(0, 0, 80, 30)] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage graphicsImageWithColor:UIColorFromRGB(0xdedede) rect:CGRectMake(0, 0, 80, 30)] forState:UIControlStateDisabled];
    }
    return _rightBtn;
}

@end
