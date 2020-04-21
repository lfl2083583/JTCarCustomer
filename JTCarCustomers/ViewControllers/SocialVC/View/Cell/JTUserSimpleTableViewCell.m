//
//  JTUserSimpleTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTUserSimpleTableViewCell.h"

@implementation JTUserSimpleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.genderGradeImageView];
    [self.contentView addSubview:self.carImgeView];
    [self.contentView addSubview:self.horizontalView];
}

- (void)setViewAtuoLayout
{
    __weak typeof(self) weakself = self;
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.equalTo(@50);
        make.left.equalTo(@10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.avatar.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.genderGradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.nameLB.mas_right).with.offset(5);
         make.size.mas_equalTo(CGSizeMake(30, 12));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.carImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.genderGradeImageView.mas_right).with.offset(5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
}


- (ZTCirlceImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatar;
}

- (UILabel *)nameLB
{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = BlackLeverColor6;
        _nameLB.font = Font(18);
    }
    return _nameLB;
}

- (JTGenderGradeImageView *)genderGradeImageView
{
    if (!_genderGradeImageView) {
        _genderGradeImageView = [[JTGenderGradeImageView alloc] init];
    }
    return _genderGradeImageView;
}

- (UIImageView *)carImgeView
{
    if (!_carImgeView) {
        _carImgeView = [[UIImageView alloc] init];
    }
    return _carImgeView;
}

- (UIView *)horizontalView {
    if (!_horizontalView) {
        _horizontalView = [[UIView alloc] init];
        _horizontalView.backgroundColor = BlackLeverColor2;
        _horizontalView.hidden = YES;
    }
    return _horizontalView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
