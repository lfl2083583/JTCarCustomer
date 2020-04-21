//
//  JTBonusDetailTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTBonusDetailTableViewCell.h"

@implementation JTBonusDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.titleLB setFrame:CGRectMake(70, 10, 150, 20)];
        [self.timeLB setFrame:CGRectMake(70, 30, 150, 20)];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (ZTCirlceImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    }
    return _avatarImageView;
}

@end
