//
//  JTImageTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTImageTableViewCell.h"

@implementation JTImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self addSubview:self.icon];
    [self addSubview:self.titleLB];
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.frame = CGRectMake(16, (self.height-30)/2, 30, 30);
    }
    return _icon;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor5;
        _titleLB.font = Font(14);
        _titleLB.frame = CGRectMake(CGRectGetMaxX(self.icon.frame)+15, 0, self.width-CGRectGetMaxX(self.icon.frame)-30, self.height);
    }
    return _titleLB;
}

@end
