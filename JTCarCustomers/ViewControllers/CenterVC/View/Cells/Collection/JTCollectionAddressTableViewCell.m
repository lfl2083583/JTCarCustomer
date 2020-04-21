//
//  JTCollectionAddressTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionAddressTableViewCell.h"

@implementation JTCollectionAddressTableViewCell


- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"icon_location"];
    }
    return _icon;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = Font(16);
        _detailLB.textColor = BlackLeverColor6;
    }
    return _detailLB;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.icon];
    [self.bottomView addSubview:self.detailLB];
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
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.icon.mas_right).with.offset(15);
        make.right.equalTo(@-16);
        make.centerY.equalTo(weakself.icon.mas_centerY).with.offset(0);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSArray *array = [model.contentDic[@"address"] componentsSeparatedByString:@"&&&&&&"];
    [self.detailLB setText:(array.count == 2)?array[1]:model.contentDic[@"address"]];
}

@end
