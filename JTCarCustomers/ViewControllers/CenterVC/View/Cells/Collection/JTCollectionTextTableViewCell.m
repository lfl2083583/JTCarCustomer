//
//  JTCollectionTextTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionTextTableViewCell.h"

@implementation JTCollectionTextTableViewCell

- (UILabel *)contentLB
{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = Font(16);
        _contentLB.textColor = BlackLeverColor6;
        _contentLB.numberOfLines = 3;
    }
    return _contentLB;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.contentLB];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@15);
        make.right.equalTo(@-16);
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    [self.contentLB setText:[model.contentDic objectForKey:@"text"]];
}


@end
