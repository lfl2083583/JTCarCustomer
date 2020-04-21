//
//  JTSessionMoneyBonusReturnTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionMoneyBonusReturnTableViewCell.h"

@implementation JTSessionMoneyBonusReturnTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self addSubview:self.titleLB];
    [self addSubview:self.messageTimeLB];
    [self addSubview:self.moneyLB];
    [self addSubview:self.line];
    [self addSubview:self.reasonLB];
    [self addSubview:self.reasonValueLB];
    [self addSubview:self.theMoneyTimeLB];
    [self addSubview:self.theMoneyTimeValueLB];
    [self addSubview:self.remarksLB];
    [self addSubview:self.remarksValueLB];
    [self addSubview:self.line_2];
    [self addSubview:self.lookDetailLB];
    [self addSubview:self.arrowIcon];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlueLeverColor1;
        _titleLB.text = @"红包退还通知";
    }
    return _titleLB;
}

- (UILabel *)messageTimeLB
{
    if (!_messageTimeLB) {
        _messageTimeLB = [[UILabel alloc] init];
        _messageTimeLB.font = Font(12);
        _messageTimeLB.textColor = BlackLeverColor3;
    }
    return _messageTimeLB;
}

- (UILabel *)moneyLB
{
    if (!_moneyLB) {
        _moneyLB = [[UILabel alloc] init];
        _moneyLB.font = Font(16);
        _moneyLB.textColor = BlackLeverColor5;
        _moneyLB.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLB;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = BlackLeverColor2;
    }
    return _line;
}

- (UILabel *)reasonLB
{
    if (!_reasonLB) {
        _reasonLB = [[UILabel alloc] init];
        _reasonLB.font = Font(14);
        _reasonLB.textColor = BlackLeverColor3;
        _reasonLB.text = @"退款原因";
    }
    return _reasonLB;
}

- (UILabel *)reasonValueLB
{
    if (!_reasonValueLB) {
        _reasonValueLB = [[UILabel alloc] init];
        _reasonValueLB.font = Font(14);
        _reasonValueLB.textColor = BlackLeverColor5;
        _reasonValueLB.numberOfLines = 0;
    }
    return _reasonValueLB;
}

- (UILabel *)theMoneyTimeLB
{
    if (!_theMoneyTimeLB) {
        _theMoneyTimeLB = [[UILabel alloc] init];
        _theMoneyTimeLB.font = Font(14);
        _theMoneyTimeLB.textColor = BlackLeverColor3;
        _theMoneyTimeLB.text = @"到账时间";
    }
    return _theMoneyTimeLB;
}

- (UILabel *)theMoneyTimeValueLB
{
    if (!_theMoneyTimeValueLB) {
        _theMoneyTimeValueLB = [[UILabel alloc] init];
        _theMoneyTimeValueLB.font = Font(14);
        _theMoneyTimeValueLB.textColor = BlackLeverColor5;
        _theMoneyTimeValueLB.numberOfLines = 0;
    }
    return _theMoneyTimeValueLB;
}

- (UILabel *)remarksLB
{
    if (!_remarksLB) {
        _remarksLB = [[UILabel alloc] init];
        _remarksLB.font = Font(14);
        _remarksLB.textColor = BlackLeverColor3;
        _remarksLB.text = @"备注";
    }
    return _remarksLB;
}

- (UILabel *)remarksValueLB
{
    if (!_remarksValueLB) {
        _remarksValueLB = [[UILabel alloc] init];
        _remarksValueLB.font = Font(14);
        _remarksValueLB.textColor = BlackLeverColor5;
        _remarksValueLB.numberOfLines = 0;
    }
    return _remarksValueLB;
}

- (UIView *)line_2
{
    if (!_line_2) {
        _line_2 = [[UIView alloc] init];
        _line_2.backgroundColor = BlackLeverColor2;
    }
    return _line_2;
}

- (UILabel *)lookDetailLB
{
    if (!_lookDetailLB) {
        _lookDetailLB = [[UILabel alloc] init];
        _lookDetailLB.font = Font(14);
        _lookDetailLB.textColor = BlackLeverColor5;
        _lookDetailLB.text = @"查看详情";
    }
    return _lookDetailLB;
}

- (UIImageView *)arrowIcon
{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] init];
        _arrowIcon.image = [UIImage imageNamed:@""];
    }
    return _arrowIcon;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.model) {
        NIMCustomObject *customObject = (NIMCustomObject *)self.message.messageObject;
        id attachment = customObject.attachment;
        if ([attachment isKindOfClass:[JTMoneyBonusReturnAttachment class]]) {
            self.titleLB.text = [(JTMoneyBonusReturnAttachment *)attachment title];
            self.messageTimeLB.text = [Utility showTime:self.message.timestamp showDetail:NO];
            NSString *moneyText = [NSString stringWithFormat:@"%@ 唐人币", [(JTMoneyBonusReturnAttachment *)attachment money]];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:moneyText];
            NSRange range = [moneyText rangeOfString:[(JTMoneyBonusReturnAttachment *)attachment money]];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AlternateGothicNo2BT-Regular" size:24] range:range];
            self.moneyLB.attributedText = string;
            self.reasonValueLB.text = [(JTMoneyBonusReturnAttachment *)attachment reason];
            self.theMoneyTimeValueLB.text = [(JTMoneyBonusReturnAttachment *)attachment time];
            self.remarksValueLB.text = [(JTMoneyBonusReturnAttachment *)attachment remarks];
        }
        self.titleLB.frame = CGRectMake(self.bubbleImageView.left + 16, self.bubbleImageView.top + 10, self.bubbleImageView.width-28, 20);
        self.messageTimeLB.frame = CGRectMake(self.titleLB.left, self.titleLB.bottom+5, self.titleLB.width, 15);
        self.moneyLB.frame = CGRectMake(self.messageTimeLB.left, self.messageTimeLB.bottom+10, self.messageTimeLB.width, 50);
        self.line.frame = CGRectMake(self.bubbleImageView.left, self.moneyLB.bottom, self.bubbleImageView.width, .5);
        
        self.reasonLB.frame = CGRectMake(self.titleLB.left, self.line.bottom + 10, 65, 15);
        CGFloat reasonValueWidth = self.bubbleImageView.width-28-self.reasonLB.width;
        CGSize reasonValueSize = [Utility getTextString:[(JTMoneyBonusReturnAttachment *)attachment reason] textFont:self.reasonValueLB.font frameWidth:reasonValueWidth attributedString:nil];
        self.reasonValueLB.frame = CGRectMake(self.reasonLB.right, self.reasonLB.top, reasonValueWidth, MAX(15, reasonValueSize.height));
        
        self.theMoneyTimeLB.frame = CGRectMake(self.reasonLB.left, self.reasonValueLB.bottom + 10, 65, 15);
        CGFloat theMoneyTimeValueWidth = reasonValueWidth;
        CGSize theMoneyTimeValueSize = [Utility getTextString:[(JTMoneyBonusReturnAttachment *)attachment time] textFont:self.theMoneyTimeValueLB.font frameWidth:theMoneyTimeValueWidth attributedString:nil];
        self.theMoneyTimeValueLB.frame = CGRectMake(self.theMoneyTimeLB.right, self.theMoneyTimeLB.top, theMoneyTimeValueWidth, MAX(15, theMoneyTimeValueSize.height));
        
        self.remarksLB.frame = CGRectMake(self.theMoneyTimeLB.left, self.theMoneyTimeValueLB.bottom + 10, 65, 15);
        CGFloat remarksValueWidth =theMoneyTimeValueWidth;
        CGSize remarksValueSize = [Utility getTextString:[(JTMoneyBonusReturnAttachment *)attachment remarks] textFont:self.remarksValueLB.font frameWidth:remarksValueWidth attributedString:nil];
        self.remarksValueLB.frame = CGRectMake(self.remarksLB.right, self.remarksLB.top, remarksValueWidth, MAX(15, remarksValueSize.height));
        
        self.line_2.frame = CGRectMake(self.bubbleImageView.left, self.remarksValueLB.bottom + 10, self.bubbleImageView.width, .5);
        self.lookDetailLB.frame = CGRectMake(self.titleLB.left, self.line_2.bottom, self.titleLB.width, 30);
    }
}

@end
