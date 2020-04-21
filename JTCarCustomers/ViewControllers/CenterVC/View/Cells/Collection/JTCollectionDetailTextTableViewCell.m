//
//  JTCollectionDetailTextTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionDetailTextTableViewCell.h"

@implementation JTCollectionDetailTextTableViewCell

- (UILabel *)contentLB
{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = Font(16);
        _contentLB.textColor = BlackLeverColor6;
        _contentLB.numberOfLines = 0;
    }
    return _contentLB;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.contentLB];
    [self.bottomView addSubview:self.avatarView];
    [self.bottomView addSubview:self.nameLB];
    [self.bottomView addSubview:self.genderView];
    [self.bottomView addSubview:self.horizontalView];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.avatarView.mas_right).offset(10);
        make.centerY.equalTo(weakself.avatarView.mas_centerY);
    }];
    
    [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(16);
        make.right.equalTo(weakself.mas_right).offset(-16);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(weakself.avatarView.mas_bottom).offset(10);
    }];
    
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(weakself.horizontalView.mas_bottom).offset(10);
        make.right.equalTo(@-16);
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    if (model.infoDic && [model.infoDic isKindOfClass:[NSDictionary class]]) {
        [self.avatarView setAvatarByUrlString:[model.infoDic[@"avatar"] avatarHandleWithSquare:50] defaultImage:DefaultSmallAvatar];
        [self.nameLB setText:model.infoDic[@"nick_name"]];
    }
    [self.contentLB setText:[model.contentDic objectForKey:@"text"]];
}
@end
