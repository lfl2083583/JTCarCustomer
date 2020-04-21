//
//  JTSessionActivityTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionActivityTableViewCell.h"

@implementation JTSessionActivityTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.photo];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.themeLB];
    [self.contentView addSubview:self.timeLB];
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
        _titleLB.font = Font(18);
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.text = @"邀请你参加活动";
    }
    return _titleLB;
}

- (UILabel *)themeLB
{
    if (!_themeLB) {
        _themeLB = [[UILabel alloc] init];
        _themeLB.font = Font(14);
        _themeLB.textColor = BlackLeverColor4;
    }
    return _themeLB;
}

- (UILabel *)timeLB
{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.font = Font(14);
        _timeLB.textColor = BlackLeverColor4;
    }
    return _timeLB;
}

- (UILabel *)addressLB
{
    if (!_addressLB) {
        _addressLB = [[UILabel alloc] init];
        _addressLB.font = Font(14);
        _addressLB.textColor = BlackLeverColor4;
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
    if ([attachment isKindOfClass:[JTActivityAttachment class]]) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:[[(JTActivityAttachment *)attachment coverUrl] avatarHandleWithSize:CGSizeMake(160, 210)]]];
        [self.themeLB setText:[NSString stringWithFormat:@"主题：%@", [(JTActivityAttachment *)attachment theme]]];
        [self.timeLB setText:[NSString stringWithFormat:@"时间：%@", [(JTActivityAttachment *)attachment time]]];
        [self.addressLB setText:[NSString stringWithFormat:@"地点：%@", [(JTActivityAttachment *)attachment address]]];
    }
    self.photo.frame = CGRectMake(self.bubbleImageView.left+16, self.bubbleImageView.top+(self.bubbleImageView.height-105)/2, 80, 105);
    self.titleLB.frame = CGRectMake(self.photo.right+10, self.photo.top, self.bubbleImageView.width-self.photo.width-36, 20);
    self.themeLB.frame = CGRectMake(self.photo.right+10, self.titleLB.bottom+25, self.bubbleImageView.width-self.photo.width-36, 20);
    self.timeLB.frame = CGRectMake(self.photo.right+10, self.themeLB.bottom, self.bubbleImageView.width-self.photo.width-36, 20);
    self.addressLB.frame = CGRectMake(self.photo.right+10, self.timeLB.bottom, self.bubbleImageView.width-self.photo.width-36, 20);
}
@end
