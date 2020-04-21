//
//  JTOrderPriceTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderPriceTableViewCell.h"

@implementation JTOrderPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.goodsPrice];
        [self.contentView addSubview:self.subgoodsPrice];
        [self.contentView addSubview:self.manhousPrice];
        [self.contentView addSubview:self.submanhousPrice];
        [self.contentView addSubview:self.vipDiscount];
        [self.contentView addSubview:self.subvipDiscount];
        [self.contentView addSubview:self.totalDiscount];
        [self.contentView addSubview:self.subtotalDiscount];
        [self.contentView addSubview:self.dashView];
        [self.contentView addSubview:self.totalPrice];
        
        __weak typeof(self)weakSelf = self;
        [self.goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.subgoodsPrice.mas_left).offset(-10);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(18);
            make.height.mas_equalTo(20);
        }];
        
        [self.subgoodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.goodsPrice.mas_right).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(18);
            make.height.mas_equalTo(20);
        }];
        
        [self.manhousPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.submanhousPrice.mas_left).offset(-10);
            make.top.equalTo(weakSelf.goodsPrice.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        [self.submanhousPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.manhousPrice.mas_right).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.goodsPrice.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        [self.vipDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.subvipDiscount.mas_left).offset(-10);
            make.top.equalTo(weakSelf.manhousPrice.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        [self.subvipDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.vipDiscount.mas_right).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.submanhousPrice.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        [self.totalDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.subtotalDiscount.mas_left).offset(-10);
            make.top.equalTo(weakSelf.vipDiscount.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        [self.subtotalDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.totalDiscount.mas_right).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.vipDiscount.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
        [self.dashView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.totalDiscount.mas_bottom).offset(18);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.dashView.mas_bottom);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self.goodsPrice setText:@"商品费"];
    [self.manhousPrice setText:@"工时费"];
    [self.vipDiscount setText:@"白金会员卡抵扣"];
    [self.totalDiscount setText:@"总优惠"];
    
    [self.subgoodsPrice setText:@"￥32.09"];
    [self.submanhousPrice setText:@"￥120.09"];
    [self.subvipDiscount setText:@"项目免费"];
    [self.subtotalDiscount setText:@"-￥20.00"];
    [self.totalPrice setText:@"共2件商品 合计￥55.32"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [self buildLabel:Font(14) textColor:BlackLeverColor5 alignment:NSTextAlignmentLeft];
    }
    return _goodsPrice;
}

- (UILabel *)subgoodsPrice {
    if (!_subgoodsPrice) {
        _subgoodsPrice = [self buildLabel:Font(16) textColor:BlackLeverColor6 alignment:NSTextAlignmentRight];
    }
    return _subgoodsPrice;
}

- (UILabel *)manhousPrice
{
    if (!_manhousPrice) {
        _manhousPrice = [self buildLabel:Font(14) textColor:BlackLeverColor5 alignment:NSTextAlignmentLeft];
    }
    return _manhousPrice;
}

- (UILabel *)submanhousPrice
{
    if (!_submanhousPrice) {
        _submanhousPrice = [self buildLabel:Font(16) textColor:BlackLeverColor6 alignment:NSTextAlignmentRight];
    }
    return _submanhousPrice;
}

- (UILabel *)vipDiscount
{
    if (!_vipDiscount) {
        _vipDiscount = [self buildLabel:Font(14) textColor:BlackLeverColor5 alignment:NSTextAlignmentLeft];
    }
    return _vipDiscount;
}

- (UILabel *)subvipDiscount
{
    if (!_subvipDiscount) {
        _subvipDiscount = [self buildLabel:Font(16) textColor:BlackLeverColor6 alignment:NSTextAlignmentRight];
    }
    return _subvipDiscount;
}

- (UILabel *)totalDiscount
{
    if (!_totalDiscount) {
        _totalDiscount = [self buildLabel:Font(14) textColor:BlackLeverColor5 alignment:NSTextAlignmentLeft];
    }
    return _totalDiscount;
}

- (UILabel *)subtotalDiscount
{
    if (!_subtotalDiscount) {
        _subtotalDiscount = [self buildLabel:Font(16) textColor:RedLeverColor1 alignment:NSTextAlignmentRight];
    }
    return _subtotalDiscount;
}

- (UIView *)dashView
{
    if (!_dashView) {
        _dashView = [[UIView alloc] init];
        _dashView.backgroundColor = BlackLeverColor2;
    }
    return _dashView;
}

- (UILabel *)totalPrice
{
    if (!_totalPrice) {
        _totalPrice = [self buildLabel:Font(14) textColor:BlackLeverColor6 alignment:NSTextAlignmentRight];
    }
    return _totalPrice;
}


- (UILabel *)buildLabel:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = alignment;
    return label;
}

@end
