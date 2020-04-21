//
//  JTStoreServiceTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceTableViewCell.h"
#import "JTAddCarViewController.h"

@implementation JTStoreServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.choiceBT];
    [self.bottomView addSubview:self.editBT];
    [self.bottomView addSubview:self.titleLB];
    [self.bottomView addSubview:self.priceLB];
    [self.bottomView addSubview:self.goodsPriceLB];
    [self.bottomView addSubview:self.worksPriceLB];
    [self.bottomView addSubview:self.detailLB];
}

- (void)setModel:(JTStoreSeviceModel *)model
{
    _model = model;
    self.bottomView.frame = model.bottomFrame;
    if (model.disable && model.status) {
        self.choiceBT.frame = model.choiceFrame;
        self.choiceBT.hidden = NO;
    }
    else
    {
        self.choiceBT.hidden = YES;
    }
    self.editBT.frame = model.editFrame;
    self.titleLB.text = model.name;
    self.titleLB.frame = model.titleFrame;
    if (model.price > 0 || (model.maxPrice > 0 && model.minPrice > 0)) {
        self.priceLB.hidden = NO;
        if (model.status) {
            if ([JTUserInfo shareUserInfo].myCarList.count > 0) {
                NSString *price = [NSString stringWithFormat:@"¥%.2f", model.price];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price];
                [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[price rangeOfString:[NSString stringWithFormat:@"%.2f", model.price]]];
                self.priceLB.attributedText = attributedString;
            }
            else
            {
                NSString *price = [NSString stringWithFormat:@"¥%.2f~¥%.2f", model.minPrice, model.maxPrice];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price];
                [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[price rangeOfString:[NSString stringWithFormat:@"%.2f", model.minPrice]]];
                [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[price rangeOfString:[NSString stringWithFormat:@"%.2f", model.maxPrice]]];
                self.priceLB.attributedText = attributedString;
            }
        }
        else
        {
            self.priceLB.text = @"库存不足，紧急上架中";
        }
        self.priceLB.frame = model.priceFrame;
    }
    else
    {
        self.priceLB.hidden = YES;
    }
    if (model.goodsPrice > 0 || (model.maxGoodsPrice > 0 && model.minGoodsPrice > 0)) {
        self.goodsPriceLB.hidden = NO;
        if (model.status) {
            if ([JTUserInfo shareUserInfo].myCarList.count > 0) {
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
                NSString *goodsPrice = [NSString stringWithFormat:@"商品：¥%.2f~¥%.2f", model.minGoodsPrice, model.maxGoodsPrice];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:goodsPrice];
                [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[goodsPrice rangeOfString:[NSString stringWithFormat:@"%.2f", model.minGoodsPrice]]];
                [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[goodsPrice rangeOfString:[NSString stringWithFormat:@"%.2f", model.maxGoodsPrice]]];
                [attributedString addAttributes:@{NSForegroundColorAttributeName:BlackLeverColor3} range:[goodsPrice rangeOfString:@"商品："]];
                self.goodsPriceLB.attributedText = attributedString;
            }
        }
        else
        {
            self.goodsPriceLB.text = @"库存不足，紧急上架中";
        }
        self.goodsPriceLB.frame = model.goodsPriceFrame;
    }
    else
    {
        self.goodsPriceLB.hidden = YES;
    }
    if ((model.worksPrice > 0 || (model.maxWorksPrice > 0 && model.minWorksPrice > 0)) && model.status) {
        self.worksPriceLB.hidden = NO;
        if ([JTUserInfo shareUserInfo].myCarList.count > 0) {
            NSString *worksPrice = [NSString stringWithFormat:@"工时：¥%.2f", model.worksPrice];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:worksPrice];
            [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[worksPrice rangeOfString:[NSString stringWithFormat:@"%.2f", model.worksPrice]]];
            [attributedString addAttributes:@{NSForegroundColorAttributeName:BlackLeverColor3} range:[worksPrice rangeOfString:@"工时："]];
            self.worksPriceLB.attributedText = attributedString;
            self.worksPriceLB.frame = model.worksPriceFrame;
        }
        else
        {
            NSString *goodsPrice = [NSString stringWithFormat:@"工时：¥%.2f~¥%.2f", model.minWorksPrice, model.maxWorksPrice];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:goodsPrice];
            [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[goodsPrice rangeOfString:[NSString stringWithFormat:@"%.2f", model.minWorksPrice]]];
            [attributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[goodsPrice rangeOfString:[NSString stringWithFormat:@"%.2f", model.maxWorksPrice]]];
            [attributedString addAttributes:@{NSForegroundColorAttributeName:BlackLeverColor3} range:[goodsPrice rangeOfString:@"工时："]];
            self.worksPriceLB.attributedText = attributedString;
            self.worksPriceLB.frame = model.worksPriceFrame;
        }
    }
    else
    {
        self.worksPriceLB.hidden = YES;
    }
    self.detailLB.text = model.introduce;
    self.detailLB.frame = model.detailFrame;
}

- (void)editClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(storeServiceTableViewCell:didSelectRowAtIndexPath:didEditAtStatus:)]) {
        [_delegate storeServiceTableViewCell:self didSelectRowAtIndexPath:self.indexPath didEditAtStatus:sender.selected];
    }
}

- (void)choiceClick:(UIButton *)sender
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        if ([JTUserInfo shareUserInfo].myCarList.count > 0) {
            sender.selected = !sender.selected;
            if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(storeServiceTableViewCell:didSelectRowAtIndexPath:didChoiceAtStatus:)]) {
                [_delegate storeServiceTableViewCell:self didSelectRowAtIndexPath:self.indexPath didChoiceAtStatus:sender.selected];
            }
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加爱车后，才能勾选相应的服务项目" message:@"有车型的基础上，商家会为您提供最终服务价" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"添加爱车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [[Utility currentViewController].navigationController pushViewController:[[JTAddCarViewController alloc] init] animated:YES];
            }]];
            [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
        }
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
    }
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UIButton *)choiceBT
{
    if (!_choiceBT) {
        _choiceBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBT setImage:[UIImage imageNamed:@"icon_accessory_normal"] forState:UIControlStateNormal];
        [_choiceBT setImage:[UIImage imageNamed:@"icon_accessory_selected"] forState:UIControlStateSelected];
        [_choiceBT addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceBT;
}

- (UIButton *)editBT
{
    if (!_editBT) {
        _editBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBT setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBT setTitle:@"保存" forState:UIControlStateSelected];
        [_editBT setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_editBT.titleLabel setFont:Font(16)];
        [_editBT addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBT;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
    }
    return _titleLB;
}

- (UILabel *)priceLB
{
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] init];
        _priceLB.font = Font(14);
        _priceLB.textColor = RedLeverColor1;
    }
    return _priceLB;
}

- (UILabel *)goodsPriceLB
{
    if (!_goodsPriceLB) {
        _goodsPriceLB = [[UILabel alloc] init];
        _goodsPriceLB.font = Font(14);
        _goodsPriceLB.textColor = RedLeverColor1;
    }
    return _goodsPriceLB;
}

- (UILabel *)worksPriceLB
{
    if (!_worksPriceLB) {
        _worksPriceLB = [[UILabel alloc] init];
        _worksPriceLB.font = Font(14);
        _worksPriceLB.textColor = RedLeverColor1;
    }
    return _worksPriceLB;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = Font(14);
        _detailLB.textColor = BlackLeverColor3;
        _detailLB.numberOfLines = 0;
    }
    return _detailLB;
}

@end
