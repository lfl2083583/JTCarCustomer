//
//  JTSessionFunsTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionFunsTableViewCell.h"
#import "JTUserInfoHandle.h"

@implementation JTSessionFunsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self addSubview:self.avatar];
    [self addSubview:self.titleLB];
    [self addSubview:self.contentLB];
}

- (void)avatarClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionFunsTableViewCell:clickInAvatarAtUserID:)]) {
        [self.delegate sessionFunsTableViewCell:self clickInAvatarAtUserID:self.attachment.userId];
    }
}

- (void)setAttachment:(JTFunsAttachment *)attachment
{
    _attachment = attachment;
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:attachment.yunxinId];
//    NSDictionary *ext = [JTUserInfoHandle showUserExtWithUser:user];
    [self.avatar setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:self.avatar.height*2] defaultImage:nil];
    self.titleLB.text = [JTUserInfoHandle showNick:user member:nil];
    self.contentLB.text = [NSString stringWithFormat:@"%@ 关注了你", attachment.time];
}

- (ZTCirlceImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] init];
        _avatar.frame = CGRectMake(10, 10, 50, 50);
        _avatar.userInteractionEnabled = YES;
        [_avatar addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatar;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.font = Font(18);
        _titleLB.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame)+10, 15, App_Frame_Width-CGRectGetMaxX(self.avatar.frame)-20, 20);
    }
    return _titleLB;
}

- (UILabel *)contentLB
{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.textColor = BlackLeverColor5;
        _contentLB.font = Font(15);
        _contentLB.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame)+10, CGRectGetMaxY(self.titleLB.frame), App_Frame_Width-CGRectGetMaxX(self.avatar.frame)-20, 20);
    }
    return _contentLB;
}

@end
