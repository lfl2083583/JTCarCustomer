//
//  JTSessionTeamTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTeamTableViewCell.h"

@implementation JTSessionTeamTableViewCell

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
    [self addSubview:self.remarksLB];
    [self addSubview:self.statusLB];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)style_one
{
    [self.titleLB setFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame)+10, 20, 100, 20)];
    [self.contentLB setFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame)+10, CGRectGetMaxY(self.titleLB.frame), App_Frame_Width-CGRectGetMaxX(self.avatar.frame)-20, 20)];
    [self.remarksLB setHidden:YES];
    [self.statusLB setHidden:YES];
    [self.statusLB setFrame:CGRectMake(App_Frame_Width-65, 20, 50, 20)];
}

- (void)style_two
{
    [self.titleLB setFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame)+10, 10, 100, 20)];
    [self.contentLB setFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame)+10, CGRectGetMaxY(self.titleLB.frame), App_Frame_Width-CGRectGetMaxX(self.avatar.frame)-20, 20)];
    [self.remarksLB setHidden:NO];
    [self.remarksLB setFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame)+10, CGRectGetMaxY(self.contentLB.frame), App_Frame_Width-CGRectGetMaxX(self.avatar.frame)-20, 20)];
    [self.statusLB setHidden:YES];
    [self.statusLB setFrame:CGRectMake(App_Frame_Width-65, 10, 50, 20)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.avatar setFrame:CGRectMake(10, 15, 50, 50)];
    if ([self.attachment isKindOfClass:[JTTeamInviteAttachment class]]) {
        
        [self style_two];
        [self.avatar setAvatarByUrlString:[[(JTTeamInviteAttachment *)self.attachment avatarUrlString] avatarHandleWithSquare:self.avatar.height*2] defaultImage:nil];
        [self.titleLB setText:[(JTTeamInviteAttachment *)self.attachment userName]];
        NSString *content = [NSString stringWithFormat:@"邀请你加入群组 %@", [(JTTeamInviteAttachment *)self.attachment teamName]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
        NSRange range = [content rangeOfString:[(JTTeamInviteAttachment *)self.attachment teamName]];
        [string addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
        self.contentLB.attributedText = string;
        [self.remarksLB setText:[NSString stringWithFormat:@"来自：%@的邀请", [(JTTeamInviteAttachment *)self.attachment userName]]];
        if ([(JTTeamInviteAttachment *)self.attachment operationType] != 0) {
            self.statusLB.hidden = NO;
            self.statusLB.text = [NSString stringWithFormat:@"%@", [(JTTeamInviteAttachment *)self.attachment operationType] == 1 ? @"已同意" : @"已拒绝"];
        }
    }
    
    else if ([self.attachment isKindOfClass:[JTTeamInviteRefuseAttachment class]]) {
        
        [self style_one];
        [self.avatar setAvatarByUrlString:[[(JTTeamInviteRefuseAttachment *)self.attachment avatarUrlString] avatarHandleWithSquare:self.avatar.height*2] defaultImage:nil];
        [self.titleLB setText:[(JTTeamInviteRefuseAttachment *)self.attachment userName]];
        NSString *content = [NSString stringWithFormat:@"拒绝加入你的群组 %@", [(JTTeamInviteRefuseAttachment *)self.attachment teamName]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
        NSRange range = [content rangeOfString:[(JTTeamInviteRefuseAttachment *)self.attachment teamName]];
        [string addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
        self.contentLB.attributedText = string;
    }
    
    else if ([self.attachment isKindOfClass:[JTTeamApplyAttachment class]]) {

        if ([(JTTeamApplyAttachment *)self.attachment remarks].length > 0) {
            [self style_two];
            [self.remarksLB setText:[NSString stringWithFormat:@"备注：%@", [(JTTeamApplyAttachment *)self.attachment remarks]]];
        }
        else
        {
            [self style_one];
        }
        [self.avatar setAvatarByUrlString:[[(JTTeamApplyAttachment *)self.attachment avatarUrlString] avatarHandleWithSquare:self.avatar.height*2] defaultImage:nil];
        [self.titleLB setText:[(JTTeamApplyAttachment *)self.attachment userName]];
        NSString *content = [NSString stringWithFormat:@"申请加入群组 %@", [(JTTeamApplyAttachment *)self.attachment teamName]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
        NSRange range = [content rangeOfString:[(JTTeamApplyAttachment *)self.attachment teamName]];
        [string addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
        self.contentLB.attributedText = string;
        if ([(JTTeamApplyAttachment *)self.attachment operationType] != 0) {
            self.statusLB.hidden = NO;
            self.statusLB.text = [NSString stringWithFormat:@"%@", [(JTTeamApplyAttachment *)self.attachment operationType] == 1 ? @"已同意" : @"已拒绝"];
        }
    }
    
    else if ([self.attachment isKindOfClass:[JTTeamApplyRefuseAttachment class]]) {
        [self style_one];
        [self.avatar setAvatarByUrlString:[[(JTTeamApplyRefuseAttachment *)self.attachment teamAvatar] avatarHandleWithSquare:self.avatar.height*2] defaultImage:nil];
        [self.titleLB setText:[(JTTeamApplyRefuseAttachment *)self.attachment teamName]];
        [self.contentLB setText:@"拒绝让你加群"];
    }
    
    else if ([self.attachment isKindOfClass:[JTTeamRemoveAttachment class]]) {
        [self style_one];
        [self.avatar setAvatarByUrlString:[[(JTTeamApplyRefuseAttachment *)self.attachment teamAvatar] avatarHandleWithSquare:self.avatar.height*2] defaultImage:nil];
        [self.titleLB setText:[(JTTeamApplyRefuseAttachment *)self.attachment teamName]];
        [self.contentLB setText:@"已将你移出群"];
    }
    
    else if ([self.attachment isKindOfClass:[JTTeamDismissAttachment class]]) {
        [self style_one];
        [self.avatar setAvatarByUrlString:[[(JTTeamApplyRefuseAttachment *)self.attachment teamAvatar] avatarHandleWithSquare:self.avatar.height*2] defaultImage:nil];
        [self.titleLB setText:[(JTTeamApplyRefuseAttachment *)self.attachment teamName]];
        [self.contentLB setText:@"群聊已解散"];
    }
}

- (ZTCirlceImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] init];
    }
    return _avatar;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.font = Font(18);
    }
    return _titleLB;
}

- (UILabel *)contentLB
{
    if (!_contentLB) {
        _contentLB = [[UILabel alloc] init];
        _contentLB.textColor = BlackLeverColor5;
        _contentLB.font = Font(15);
    }
    return _contentLB;
}

- (UILabel *)remarksLB
{
    if (!_remarksLB) {
        _remarksLB = [[UILabel alloc] init];
        _remarksLB.textColor = BlackLeverColor3;
        _remarksLB.font = Font(15);
    }
    return _remarksLB;
}

- (UILabel *)statusLB
{
    if (!_statusLB) {
        _statusLB = [[UILabel alloc] init];
        _statusLB.textColor = BlackLeverColor3;
        _statusLB.font = Font(15);
        _statusLB.textAlignment = NSTextAlignmentRight;
    }
    return _statusLB;
}

@end
