//
//  JTOrderGoodsTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderGoodsTableViewCell.h"

@implementation JTOrderGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentImgeView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.detailLB];
        [self.contentView addSubview:self.priceLB];
        [self.contentView addSubview:self.goodsNumLB];
        
        __weak typeof(self)weakSelf = self;
        [self.contentImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(13);
            make.size.mas_equalTo(CGSizeMake(54, 54));
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-13);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentImgeView.mas_right).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(13);
        }];
        
        [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentImgeView.mas_right).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.centerY.equalTo(weakSelf.contentImgeView.mas_centerY);
        }];
        
        [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentImgeView.mas_right).offset(10);
            make.right.equalTo(weakSelf.goodsNumLB.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.contentImgeView.mas_bottom);
        }];
        
        [self.goodsNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.equalTo(weakSelf.contentImgeView.mas_bottom);
        }];
        
        [self congfigCell];
    }
    return self;
}

- (void)congfigCell {
    [self.contentImgeView sd_setImageWithURL:[NSURL URLWithString:[[JTUserInfo shareUserInfo].userAvatar avatarHandleWithSquare:108]]];
    [self.titleLB setText:@"商品详情冲洗擦干、轮胎轮毂清洁、车内洗擦…"];
    [self.detailLB setText:@"已省39元：XXXX优惠券"];
    [self.priceLB setText:@"￥25.00"];
    [self.goodsNumLB setText:@"X 1"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)contentImgeView {
    if (!_contentImgeView) {
        _contentImgeView = [[UIImageView alloc] init];
        _contentImgeView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgeView.clipsToBounds = YES;
    }
    return _contentImgeView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(12);
        _titleLB.textColor = BlackLeverColor5;
    }
    return _titleLB;
}

- (UILabel *)detailLB {
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = Font(12);
        _detailLB.textColor = UIColorFromRGB(0xffa056);
    }
    return _detailLB;
}

- (UILabel *)priceLB {
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] init];
        _priceLB.font = Font(16);
        _priceLB.textColor = BlackLeverColor6;
    }
    return _priceLB;
}

- (UILabel *)goodsNumLB {
    if (!_goodsNumLB) {
        _goodsNumLB = [[UILabel alloc] init];
        _goodsNumLB.font = Font(12);
        _goodsNumLB.textColor = BlackLeverColor6;
        _goodsNumLB.textAlignment = NSTextAlignmentRight;
    }
    return _goodsNumLB;
}

@end
