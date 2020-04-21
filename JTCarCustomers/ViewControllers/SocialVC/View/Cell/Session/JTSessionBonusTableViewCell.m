//
//  JTSessionBonusTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionBonusTableViewCell.h"

@implementation JTSessionBonusTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.subTitleLB];
    [self.contentView addSubview:self.noteLB];
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = WhiteColor;
    }
    return _titleLB;
}

- (UILabel *)subTitleLB
{
    if (!_subTitleLB) {
        _subTitleLB = [[UILabel alloc] init];
        _subTitleLB.font = Font(12);
        _subTitleLB.textColor = [UIColor whiteColor];
    }
    return _subTitleLB;
}

- (UILabel *)noteLB
{
    if (!_noteLB) {
        _noteLB = [[UILabel alloc] init];
        _noteLB.font = Font(12);
        _noteLB.textColor = BlackLeverColor3;
        _noteLB.text = @"溜车圈红包";
    }
    return _noteLB;
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
        if ([attachment isKindOfClass:[JTBonusAttachment class]]) {
            
            if ([(JTBonusAttachment *)attachment isGrabbed] ||
                [(JTBonusAttachment *)attachment isOverTime] ||
                [(JTBonusAttachment *)attachment isOverGrab]) {
                self.icon.image = [UIImage jt_imageInKit:@"icon_bouns_select"];
            }
            else
            {
                self.icon.image = [UIImage jt_imageInKit: @"icon_bouns_normal"];
            }
            if ([(JTBonusAttachment *)attachment isGrabbed]) {
                self.subTitleLB.text = @"已领取";
            }
            else
            {
                if ([(JTBonusAttachment *)attachment isOverTime]) {
                    self.subTitleLB.text = @"红包已过期";
                }
                else
                {
                    if ([(JTBonusAttachment *)attachment isOverGrab]) {
                        self.subTitleLB.text = @"红包已领完";
                    }
                    else
                    {
                        BOOL isLook = [(JTBonusAttachment *)attachment isSender] && [(JTBonusAttachment *)attachment type] != JTBonusTypeTeamLuck;
                        self.subTitleLB.text = isLook?@"查看红包":@"领取红包";
                    }
                }
            }
            self.titleLB.text = [(JTBonusAttachment *)attachment content];
        }
        
        self.icon.frame = CGRectMake(self.bubbleImageView.left+16, self.bubbleImageView.top+12, 34, 38);
        self.titleLB.frame = CGRectMake(self.bubbleImageView.left+60, self.bubbleImageView.top+12, self.bubbleImageView.width-70, 20);
        self.subTitleLB.frame = CGRectMake(self.bubbleImageView.left+60, self.bubbleImageView.top+32, 143, 18);
        self.noteLB.frame = CGRectMake(self.bubbleImageView.left+16, self.bubbleImageView.top+63, 100, 18);
    }
}

@end
