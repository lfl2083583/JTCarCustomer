//
//  JTSessionTextTableViewCell.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTextTableViewCell.h"

@implementation JTSessionTextTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.textLB];
}

- (UILabel *)textLB
{
    if (!_textLB) {
        _textLB = [[UILabel alloc] init];
        _textLB.font = Font(JTMessageTextFont);
        _textLB.textColor = BlackLeverColor6;
        _textLB.numberOfLines = 0;
    }
    return _textLB;
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
        self.textLB.attributedText = self.model.string;
        if (self.isOutgoingMessage) {
            self.textLB.frame = CGRectMake(self.bubbleImageView.left + 12, self.bubbleImageView.top + 10, self.bubbleImageView.width - 28, self.bubbleImageView.height - 20);
            self.textLB.textColor = (self.message.messageType != NIMMessageTypeText) ? BlueLeverColor1 : BlackLeverColor6 ;
        }
        else
        {
            self.textLB.frame = CGRectMake(self.bubbleImageView.left + 16, self.bubbleImageView.top + 10, self.bubbleImageView.width - 28, self.bubbleImageView.height - 20);
            self.textLB.textColor = (self.message.messageType != NIMMessageTypeText) ? BlackLeverColor5 : BlackLeverColor6 ;
        }
    }
}
@end
