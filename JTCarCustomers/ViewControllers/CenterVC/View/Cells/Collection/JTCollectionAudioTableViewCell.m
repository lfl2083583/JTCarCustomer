//
//  JTCollectionAudioTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionAudioTableViewCell.h"

@implementation JTCollectionAudioTableViewCell


- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"icon_audio"];
    }
    return _icon;
}

- (UILabel *)durationLB
{
    if (!_durationLB) {
        _durationLB = [[UILabel alloc] init];
        _durationLB.font = Font(16);
        _durationLB.textColor = BlackLeverColor6;
    }
    return _durationLB;
}


- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.icon];
    [self.bottomView addSubview:self.durationLB];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
    [self.durationLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.icon.mas_right).with.offset(15);
        make.centerY.equalTo(weakself.icon.mas_centerY).with.offset(0);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSInteger duration = [model.contentDic[@"duration"] integerValue];
    [self.durationLB setText:[NSString stringWithFormat:@"%02d:%02d", (int)duration/60, (int)duration%60]];
}

@end
