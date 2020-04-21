//
//  JTCollectionDetailImageTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIImage+Chat.h"
#import "JTCollectionDetailImageTableViewCell.h"

@implementation JTCollectionDetailImageTableViewCell

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
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(weakself.horizontalView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSString *url = [model.contentDic objectForKey:@"thumbnail"] ? [model.contentDic objectForKey:@"thumbnail"] : @"";
    CGSize size = [self contentSize:CGSizeMake([[model.contentDic objectForKey:@"width"] floatValue], [[model.contentDic objectForKey:@"height"] floatValue])];
    if (model.infoDic && [model.infoDic isKindOfClass:[NSDictionary class]]) {
        [self.avatarView setAvatarByUrlString:[model.infoDic[@"avatar"] avatarHandleWithSquare:50] defaultImage:DefaultSmallAvatar];
        [self.nameLB setText:model.infoDic[@"nick_name"]];
    }
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:[url avatarHandleWithSize:size]]];
    __weak typeof(self) weakself = self;
    [self.contentImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.size.mas_equalTo(size);
    }];
}

- (CGSize)contentSize:(CGSize)originalSize
{
    if (originalSize.width && originalSize.height) {
        CGFloat attachmentImageMinWidth  = 40.0;
        CGFloat attachmentImageMinHeight = 40.0;
        CGFloat attachmemtImageMaxWidth  = App_Frame_Width-32.0;
        CGFloat attachmentImageMaxHeight = APP_Frame_Height;
        CGSize imageSize = originalSize;
        CGSize turnImageSize = [UIImage jt_sizeWithImageOriginSize:imageSize
                                                           minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                           maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
        return CGSizeMake(turnImageSize.width, turnImageSize.height);
    }
    else
    {
        return CGSizeMake(App_Frame_Width-32.0, App_Frame_Width-32.0);
    }
}
@end
