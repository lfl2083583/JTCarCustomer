//
//  JTBadgeTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBadgeTableViewCell.h"

@implementation JTBadgeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.badgeView];
    }
    return self;
}

- (void)setBedgeNum:(NSInteger)bedgeNum
{
    _bedgeNum = bedgeNum;
    if (bedgeNum > 0) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld", bedgeNum];
        self.badgeView.centerX = 55;
        self.badgeView.centerY = 15;
    }
    else
    {
        self.badgeView.hidden = YES;
    }
}

- (JTBadgeView *)badgeView
{
    if (!_badgeView) {
        _badgeView = [JTBadgeView viewWithBadgeTip:@""];
    }
    return _badgeView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
