//
//  JTMemberCollectionViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTMemberCollectionViewCell.h"

@implementation JTMemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.avatar];
        [self addSubview:self.nameLB];
    }
    return self;
}

- (ZTCirlceImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(0, 5, 50, 50)];
    }
    return _avatar;
}

- (UILabel *)nameLB
{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.avatar.frame)+5, 50, 20)];
        _nameLB.textColor = BlackLeverColor5;
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.font = Font(12);
    }
    return _nameLB;
}
@end
