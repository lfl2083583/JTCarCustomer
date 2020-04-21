//
//  JTShoppingCartTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTShoppingCartTableViewCell.h"

@implementation JTShoppingCartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.priceLB];
    [self.contentView addSubview:self.goodsPriceLB];
    [self.contentView addSubview:self.worksPriceLB];
    [self.contentView addSubview:self.deleteBT];
}

- (void)setModel:(JTStoreSeviceModel *)model
{
    _model = model;
    self.titleLB.text = model.name;
    if (model.price > 0) {
        NSString *price = [NSString stringWithFormat:@"¥%.2f", model.price];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price];
        [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[price rangeOfString:[NSString stringWithFormat:@"%.2f", model.price]]];
        self.priceLB.attributedText = attributedString;
    }
    else
    {
        self.priceLB.text = @"";
    }
    if (model.goodsPrice > 0) {
        CGFloat price = 0;
        if (model.storeGoodsModel && [model.storeGoodsModel isKindOfClass:[NSArray class]] && model.storeGoodsModel.count > 0) {
            for (JTStoreGoodsModel *item in model.storeGoodsModel) {
                price += item.num * item.price;
            }
        }
        else
        {
            price = model.goodsPrice;
        }
        NSString *goodsPrice = [NSString stringWithFormat:@"商品：¥%.2f", price];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:goodsPrice];
        [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[goodsPrice rangeOfString:[NSString stringWithFormat:@"%.2f", price]]];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:BlackLeverColor3} range:[goodsPrice rangeOfString:@"商品："]];
        self.goodsPriceLB.attributedText = attributedString;
    }
    else
    {
        self.goodsPriceLB.text = @"";
    }
    
    if (model.worksPrice > 0) {
        NSString *worksPrice = [NSString stringWithFormat:@"工时：¥%.2f", model.worksPrice];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:worksPrice];
        [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[worksPrice rangeOfString:[NSString stringWithFormat:@"%.2f", model.worksPrice]]];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:BlackLeverColor3} range:[worksPrice rangeOfString:@"工时："]];
        self.worksPriceLB.attributedText = attributedString;
    }
    else
    {
        self.worksPriceLB.text = @"";
    }
}

- (void)deleteClick:(id)sender
{
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(shoppingCartTableViewCell:didDeleteAtIndexPath:)]) {
        [_delegate shoppingCartTableViewCell:self didDeleteAtIndexPath:self.indexPath];
    }
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.frame = CGRectMake(15, 0, self.deleteBT.left-145, 60);
    }
    return _titleLB;
}

- (UILabel *)priceLB
{
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] init];
        _priceLB.font = Font(14);
        _priceLB.textColor = RedLeverColor1;
        _priceLB.frame = CGRectMake(self.titleLB.right+5, 0, 125, 60);
        _priceLB.textAlignment = NSTextAlignmentRight;
    }
    return _priceLB;
}

- (UILabel *)goodsPriceLB
{
    if (!_goodsPriceLB) {
        _goodsPriceLB = [[UILabel alloc] init];
        _goodsPriceLB.font = Font(14);
        _goodsPriceLB.textColor = RedLeverColor1;
        _goodsPriceLB.frame = CGRectMake(self.titleLB.right+5, 10, self.deleteBT.left-self.titleLB.right-5, 20);
        _goodsPriceLB.textAlignment = NSTextAlignmentRight;
    }
    return _goodsPriceLB;
}

- (UILabel *)worksPriceLB
{
    if (!_worksPriceLB) {
        _worksPriceLB = [[UILabel alloc] init];
        _worksPriceLB.font = Font(14);
        _worksPriceLB.textColor = RedLeverColor1;
        _worksPriceLB.frame = CGRectMake(self.titleLB.right+15, 30, self.deleteBT.left-self.titleLB.right-15, 20);
        _worksPriceLB.textAlignment = NSTextAlignmentRight;
     }
    return _worksPriceLB;
}

- (UIButton *)deleteBT
{
    if (!_deleteBT) {
        _deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBT setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_deleteBT.titleLabel setFont:Font(12)];
        [_deleteBT addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBT setFrame:CGRectMake(App_Frame_Width-50, 0, 50, 60)];
    }
    return _deleteBT;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
