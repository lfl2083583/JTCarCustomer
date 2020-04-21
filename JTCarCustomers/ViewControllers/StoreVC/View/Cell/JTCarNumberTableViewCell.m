//
//  JTCarNumberTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarNumberTableViewCell.h"

@implementation JTCarNumberTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.arrow];
        [self.contentTF setFrame:CGRectMake(166, 0, kScreenWidth-199, self.height)];
    }
    return self;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.frame = CGRectMake(15, 0, 30, self.height);
        _titleLB.text = @"粤";
    }
    return _titleLB;
}

- (UIImageView *)arrow
{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = [UIImage imageNamed:@"down_arrow"];
        _arrow.frame = CGRectMake(self.titleLB.right, (self.height-8)/2, 12, 8);
    }
    return _arrow;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.titleLB.frame, touchPoint) || CGRectContainsPoint(self.arrow.frame, touchPoint)) {
        if (_carNumberTableViewCellDelegate && [_carNumberTableViewCellDelegate respondsToSelector:@selector(carNumberTableViewCellAtChoiceAlias:)]) {
            [_carNumberTableViewCellDelegate carNumberTableViewCellAtChoiceAlias:self];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
