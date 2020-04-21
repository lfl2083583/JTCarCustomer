//
//  JTSessionCardTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionCardTableViewCell.h"

@implementation JTSessionCardTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.callLB];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.noteLB];
}

- (ZTCirlceImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] init];
        _avatar.size = CGSizeMake(40, 40);
    }
    return _avatar;
}

- (UILabel *)callLB
{
    if (!_callLB) {
        _callLB = [[UILabel alloc] init];
        _callLB.font = Font(16);
        _callLB.textColor = BlackLeverColor6;
    }
    return _callLB;
}

- (UILabel *)noteLB
{
    if (!_noteLB) {
        _noteLB = [[UILabel alloc] init];
        _noteLB.font = Font(12);
        _noteLB.textColor = BlackLeverColor3;
        _noteLB.text = @"推荐好友";
    }
    return _noteLB;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = BlackLeverColor2;
    }
    return _line;
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
    if (self.model) {
        NIMCustomObject *customObject = (NIMCustomObject *)self.message.messageObject;
        id attachment = customObject.attachment;
        if ([attachment isKindOfClass:[JTCardAttachment class]]) {
            [self.avatar setAvatarByUrlString:[[(JTCardAttachment *)attachment avatarUrlString] avatarHandleWithSquare:80] defaultImage:DefaultSmallAvatar];
            [self.callLB setText:[(JTCardAttachment *)attachment userName]];
        }
        
        self.avatar.frame = CGRectMake(self.bubbleImageView.left+10, self.bubbleImageView.top+(self.bubbleImageView.height-40)/2, 40, 40);
        self.callLB.frame = CGRectMake(self.bubbleImageView.left+60, self.avatar.centerY-25, 130, 20);
        self.line.frame = CGRectMake(self.bubbleImageView.left+60, self.avatar.centerY, 130, .5);
        self.noteLB.frame = CGRectMake(self.bubbleImageView.left+60, self.avatar.centerY+5, 130, 20);
    }
}

@end
