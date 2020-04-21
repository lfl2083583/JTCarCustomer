//
//  JTSimpleStoreGoodsTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSimpleStoreGoodsTableViewCell.h"

@implementation JTSimpleStoreGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.cover];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.priceLB];
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
        _titleLB = [[ZTAlignmentLabel alloc] initWithFrame:CGRectMake(self.cover.right+10, self.cover.top, App_Frame_Width-self.cover.right-20, 40)];
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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
