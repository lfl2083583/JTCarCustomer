//
//  JTCollectionTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

@implementation JTCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initSubview];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.titleLB];
    [self.bottomView addSubview:self.timeLB];
}

- (ZTCirlceImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[ZTCirlceImageView alloc] init];
    }
    return _avatarView;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = BlackLeverColor6;
        _nameLB.font = Font(18);
    }
    return _nameLB;
}

- (JTGenderGradeImageView *)genderView {
    if (!_genderView) {
        _genderView = [[JTGenderGradeImageView alloc] init];
    }
    return _genderView;
}

- (UIView *)horizontalView {
    if (!_horizontalView) {
        _horizontalView = [[UIView alloc] init];
        _horizontalView.backgroundColor = BlackLeverColor2;
    }
    return _horizontalView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(12);
        _titleLB.textColor = BlackLeverColor3;
    }
    return _titleLB;
}

- (UILabel *)timeLB
{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.font = Font(12);
        _timeLB.textColor = BlackLeverColor3;
    }
    return _timeLB;
}

- (void)setViewAtuoLayout
{
    __weak typeof(self) weakself = self;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.top.equalTo(@0);
        make.right.equalTo(@-8);
        make.bottom.equalTo(weakself.contentView.mas_bottom);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.bottom.equalTo(weakself.bottomView.mas_bottom).with.offset(-15);
    }];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.titleLB.mas_top);
        make.left.equalTo(weakself.titleLB.mas_right).with.offset(10);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    _model = model;
    [self.titleLB setText:model.name];
    [self.timeLB setText:[Utility showTime:[model.collectionTime integerValue] showDetail:YES]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
