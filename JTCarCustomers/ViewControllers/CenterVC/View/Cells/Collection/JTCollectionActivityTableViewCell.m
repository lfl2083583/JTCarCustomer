//
//  JTCollectionActivityTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionActivityTableViewCell.h"

@implementation JTCollectionActivityTableViewCell

- (UIImageView *)contentImage
{
    if (!_contentImage) {
        _contentImage = [[UIImageView alloc] init];
        _contentImage.contentMode = UIViewContentModeScaleAspectFill;
        _contentImage.clipsToBounds = YES;
    }
    return _contentImage;
}

- (UILabel *)themeLB {
    if (!_themeLB) {
        _themeLB = [[UILabel alloc] init];
        _themeLB.font = Font(14);
        _themeLB.textColor = BlackLeverColor6;
    }
    return _themeLB;
}

- (UILabel *)scheduleLB {
    if (!_scheduleLB) {
        _scheduleLB = [[UILabel alloc] init];
        _scheduleLB.font = Font(14);
        _scheduleLB.textColor = BlackLeverColor6;
    }
    return _scheduleLB;
}

- (UILabel *)siteLB {
    if (!_siteLB) {
        _siteLB = [[UILabel alloc] init];
        _siteLB.font = Font(14);
        _siteLB.textColor = BlackLeverColor6;
    }
    return _siteLB;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.contentImage];
    [self.bottomView addSubview:self.themeLB];
    [self.bottomView addSubview:self.scheduleLB];
    [self.bottomView addSubview:self.siteLB];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(80, 105));
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
    
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.top.equalTo(@(30));
        make.right.equalTo(weakself.mas_right).offset(-18);
        make.height.mas_equalTo(20);
    }];
    
    [self.scheduleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.top.equalTo(weakself.themeLB.mas_bottom).offset(5);
        make.right.equalTo(weakself.mas_right).offset(-18);
        make.height.mas_equalTo(20);
    }];
    
    [self.siteLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.top.equalTo(weakself.scheduleLB.mas_bottom).offset(5);
        make.right.equalTo(weakself.mas_right).offset(-18);
        make.height.mas_equalTo(20);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSString *url = [model.infoDic objectForKey:@"image"] ? [model.infoDic objectForKey:@"image"] : @"";
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:[url avatarHandleWithSize:CGSizeMake(80, 105)]]];
    [self.themeLB setText:[NSString stringWithFormat:@"活动主题：%@", [model.infoDic objectForKey:@"theme"]]];
    [self.scheduleLB setText:[NSString stringWithFormat:@"时间：%@", [model.infoDic objectForKey:@"time"]]];
    [self.siteLB setText:[NSString stringWithFormat:@"地点：%@", [model.infoDic objectForKey:@"address"]]];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
