//
//  JTSessionBusinessReplyTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionBusinessReplyTableViewCell.h"

@implementation JTSessionBusinessReplyTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self addSubview:self.titleLB];
    [self addSubview:self.contentLB];
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlueLeverColor1;
        _titleLB.text = @"商家回复";
    }
    return _titleLB;
}

- (UILabel *)contentLB
{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = Font(16);
        _contentLB.textColor = BlackLeverColor5;
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
    if (self.model) {
        NIMCustomObject *customObject = (NIMCustomObject *)self.message.messageObject;
        id attachment = customObject.attachment;
        if ([attachment isKindOfClass:[JTBusinessReplyAttachment class]]) {
            self.contentLB.text = [(JTBusinessReplyAttachment *)attachment content];
        }
        self.titleLB.frame = CGRectMake(self.bubbleImageView.left + 16, self.bubbleImageView.top + 10, self.bubbleImageView.width - 28, 15);
        self.contentLB.frame = CGRectMake(self.titleLB.left, self.titleLB.bottom + 10, self.titleLB.width, self.bubbleImageView.height - 30);
    }
}
@end
