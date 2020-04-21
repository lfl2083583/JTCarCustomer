//
//  JTSessionInformationTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionInformationTableViewCell.h"

@implementation JTSessionInformationTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.photo];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.contentLB];
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
        _titleLB.font = Font(18);
        _titleLB.textColor = BlackLeverColor6;
    }
    return _titleLB;
}

- (UILabel *)contentLB
{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = Font(14);
        _contentLB.textColor = BlackLeverColor4;
        _contentLB.numberOfLines = 0;
    }
    return _contentLB;
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
    if ([attachment isKindOfClass:[JTInformationAttachment class]]) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:[[(JTInformationAttachment *)attachment coverUrl] avatarHandleWithSquare:160]]];
        [self.titleLB setText:[(JTInformationAttachment *)attachment title]];
        [self.contentLB setText:[(JTInformationAttachment *)attachment content]];
    }
    self.photo.frame = CGRectMake(self.bubbleImageView.left+16, self.bubbleImageView.top+(self.bubbleImageView.height-80)/2, 80, 80);
    self.titleLB.frame = CGRectMake(self.photo.right+10, self.photo.top, self.bubbleImageView.width-self.photo.width-36, 20);
    self.contentLB.frame = CGRectMake(self.photo.right+10, self.titleLB.bottom+5, self.bubbleImageView.width-self.photo.width-36, self.photo.bottom-self.titleLB.bottom-5);
}

@end
