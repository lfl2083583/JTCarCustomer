//
//  JTSessionActivityPromptTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionActivityPromptTableViewCell.h"

@implementation JTSessionActivityPromptTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self addSubview:self.titleLB];
    [self addSubview:self.contentLB];
    [self addSubview:self.line];
    [self addSubview:self.noteLB];
    [self addSubview:self.arrowIcon];
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlueLeverColor1;
        _titleLB.text = @"活动消息";
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

- (UILabel *)noteLB
{
    if (!_noteLB) {
        _noteLB = [[UILabel alloc] init];
        _noteLB.font = Font(12);
        _noteLB.textColor = BlackLeverColor3;
        _noteLB.text = @"活动详情";
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
        if ([attachment isKindOfClass:[JTActivityPromptAttachment class]]) {
            self.contentLB.text = [(JTActivityPromptAttachment *)attachment content];
        }
        self.titleLB.frame = CGRectMake(self.bubbleImageView.left + 16, self.bubbleImageView.top + 10, self.bubbleImageView.width - 28, 15);
        self.contentLB.frame = CGRectMake(self.titleLB.left, self.titleLB.bottom + 10, self.titleLB.width, self.bubbleImageView.height - 65);
        self.line.frame = CGRectMake(self.bubbleImageView.left, self.contentLB.bottom + 10, self.bubbleImageView.width, .5);
        self.noteLB.frame = CGRectMake(self.titleLB.left, self.line.top, 130, 20);
    }
}

@end
