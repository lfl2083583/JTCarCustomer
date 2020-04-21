//
//  JTSessionShopTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionShopTableViewCell.h"

@implementation JTSessionShopTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.photo];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.detailLB];
    [self.contentView addSubview:self.addressLB];
}

- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc] init];
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.clipsToBounds = YES;
    }
    return _photo;
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

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = Font(10);
        _detailLB.textColor = BlackLeverColor3;
    }
    return _detailLB;
}

- (UILabel *)addressLB
{
    if (!_addressLB) {
        _addressLB = [[UILabel alloc] init];
        _addressLB.font = Font(10);
        _addressLB.textColor = BlackLeverColor3;
    }
    return _addressLB;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NIMCustomObject *customObject = (NIMCustomObject *)self.message.messageObject;
    id attachment = customObject.attachment;
    self.photo.frame = CGRectMake(self.bubbleImageView.left+17, self.bubbleImageView.top+10, self.bubbleImageView.width-30, (self.bubbleImageView.width-30)* 9./16.);
    self.titleLB.frame = CGRectMake(self.photo.left, self.photo.bottom+10, self.photo.width, 20);
    self.detailLB.frame = CGRectMake(self.photo.left, self.titleLB.bottom+10, self.photo.width, 10);
    self.addressLB.frame = CGRectMake(self.photo.left, self.detailLB.bottom+5, self.photo.width, 10);
    if ([attachment isKindOfClass:[JTShopAttachment class]]) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:[[(JTShopAttachment *)attachment coverUrl] avatarHandleWithSize:CGSizeMake(self.photo.width*2, self.photo.height*2)]]];
        [self.titleLB setText:[(JTShopAttachment *)attachment name]];
        NSString *score = [NSString stringWithFormat:@"%@分", [(JTShopAttachment *)attachment score]];
        NSString *detail = [NSString stringWithFormat:@"综合评分：%@  营业时间：%@", score, [(JTShopAttachment *)attachment time]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detail];
        [attributedString addAttribute:NSFontAttributeName value:Font(12) range:[detail rangeOfString:[NSString stringWithFormat:@"综合评分：%@", score]]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:YellowColor range:[detail rangeOfString:score]];
        self.detailLB.attributedText = attributedString;
        self.addressLB.text = [(JTShopAttachment *)attachment address];
    }
}

@end
