//
//  JTCollectionImageTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionImageTableViewCell.h"

@implementation JTCollectionImageTableViewCell

- (UIImageView *)contentImage
{
    if (!_contentImage) {
        _contentImage = [[UIImageView alloc] init];
        _contentImage.contentMode = UIViewContentModeScaleAspectFill;
        _contentImage.clipsToBounds = YES;
    }
    return _contentImage;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.contentImage];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSString *url = [model.contentDic objectForKey:@"thumbnail"] ? [model.contentDic objectForKey:@"thumbnail"] : @"";
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:[url avatarHandleWithSize:CGSizeMake(200, 200)]]];
}

@end
