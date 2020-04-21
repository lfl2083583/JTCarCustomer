//
//  JTTradeBonusTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/9/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTradeBonusTableViewCell.h"

@implementation JTTradeBonusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.timeLB];
        [self.contentView addSubview:self.moneyLB];
        [self.contentView addSubview:self.detailLB];
    }
    return self;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.frame = CGRectMake(16, 10, 150, 20);
    }
    return _titleLB;
}

- (UILabel *)timeLB
{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.font = Font(14);
        _timeLB.textColor = BlackLeverColor3;
        _timeLB.frame = CGRectMake(16, 30, 150, 20);
    }
    return _timeLB;
}

- (UILabel *)moneyLB
{
    if (!_moneyLB) {
        _moneyLB = [[UILabel alloc] init];
        _moneyLB.font = Font(16);
        _moneyLB.textColor = BlackLeverColor6;
        _moneyLB.textAlignment = NSTextAlignmentRight;
        _moneyLB.frame = CGRectMake(App_Frame_Width-16-200, 10, 200, 20);
    }
    return _moneyLB;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = Font(14);
        _detailLB.textColor = BlackLeverColor3;
        _detailLB.textAlignment = NSTextAlignmentRight;
        _detailLB.frame = CGRectMake(App_Frame_Width-16-200, 30, 200, 20);
        
    }
    return _detailLB;
}

@end
