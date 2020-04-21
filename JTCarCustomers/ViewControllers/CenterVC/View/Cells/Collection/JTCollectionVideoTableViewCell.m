//
//  JTCollectionVideoTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionVideoTableViewCell.h"
#import "UIImage+Chat.h"

@implementation JTCollectionVideoTableViewCell

- (UIImageView *)contentImage
{
    if (!_contentImage) {
        _contentImage = [[UIImageView alloc] init];
        _contentImage.contentMode = UIViewContentModeScaleAspectFill;
        _contentImage.clipsToBounds = YES;
    }
    return _contentImage;
}

- (UIImageView *)playIcon
{
    if (!_playIcon) {
        _playIcon = [[UIImageView alloc] init];
        _playIcon.image = [UIImage jt_imageInKit:@"icon_play_normal"];
    }
    return _playIcon;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.contentImage];
    [self.bottomView addSubview:self.playIcon];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
    [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(weakself.contentImage.mas_centerY);
        make.centerX.equalTo(weakself.contentImage.mas_centerX);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSString *avatarUrlString = [model.contentDic[@"coverUrl"] stringByAppendingString:@"?imageView&thumbnail=160z160"];
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:avatarUrlString]];
}

@end
