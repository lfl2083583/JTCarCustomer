//
//  JTStoreGoodsTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/5/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreGoodsTableViewCell.h"

@implementation JTStoreGoodsTableViewCell

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
    [self.bottomView addSubview:self.cover];
    [self.bottomView addSubview:self.titleLB];
    [self.bottomView addSubview:self.priceLB];
    [self.bottomView addSubview:self.numLB];
}

- (void)setModel:(JTStoreGoodsModel *)model
{
    _model = model;
    [self.cover sd_setImageWithURL:[NSURL URLWithString:[model.coverUrlString avatarHandleWithSize:CGSizeMake(self.cover.width*2, self.cover.height*2)]]];
    [self.titleLB setText:model.name];
    NSString *price = [NSString stringWithFormat:@"¥%.2f", model.price];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:price];
    [priceAttributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[price rangeOfString:[NSString stringWithFormat:@"%.2f", model.price]]];
    self.priceLB.attributedText = priceAttributedString;
    NSString *num = [NSString stringWithFormat:@"x%ld", model.num];
    NSMutableAttributedString *numAttributedString = [[NSMutableAttributedString alloc] initWithString:num];
    [numAttributedString addAttributes:@{NSFontAttributeName:Font(16)} range:[num rangeOfString:[NSString stringWithFormat:@"%ld", model.num]]];
    self.numLB.attributedText = numAttributedString;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, App_Frame_Width-110, 90)];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UIImageView *)cover
{
    if (!_cover) {
        _cover = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
        _cover.contentMode = UIViewContentModeScaleAspectFill;
        _cover.clipsToBounds = YES;
    }
    return _cover;
}

- (ZTAlignmentLabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[ZTAlignmentLabel alloc] initWithFrame:CGRectMake(self.cover.right+10, self.cover.top, self.bottomView.width-self.cover.right-20, 40)];
        _titleLB.verticalAlignment = VerticalAlignmentTop;
        _titleLB.font = Font(12);
        _titleLB.textColor = BlackLeverColor5;
    }
    return _titleLB;
}

- (UILabel *)priceLB
{
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLB.left, self.titleLB.bottom, self.titleLB.width-50, 20)];
        _priceLB.font = Font(14);
        _priceLB.textColor = RedLeverColor1;
    }
    return _priceLB;
}

- (UILabel *)numLB
{
    if (!_numLB) {
        _numLB = [[UILabel alloc] initWithFrame:CGRectMake(self.priceLB.right, self.priceLB.top, 50, self.priceLB.height)];
        _numLB.textAlignment = NSTextAlignmentRight;
        _numLB.font = Font(12);
        _numLB.textColor = BlackLeverColor6;
    }
    return _numLB;
}
@end
