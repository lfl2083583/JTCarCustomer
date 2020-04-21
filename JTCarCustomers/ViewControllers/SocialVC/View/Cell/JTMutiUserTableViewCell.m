//
//  JTMutiUserTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTMutiUserTableViewCell.h"

@implementation JTMutiUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _choiceBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBT setImage:[UIImage imageNamed:@"icon_accessory_normal"] forState:UIControlStateNormal];
        _choiceBT.frame = CGRectMake(0, 0, 40, 70);
        _choiceBT.userInteractionEnabled = NO;
        [self addSubview:_choiceBT];
        
        _avatarImageView = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(40, 10, 50, 50)];
        [self addSubview:_avatarImageView];
        
        _detailLB = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, App_Frame_Width-115, 70)];
        _detailLB.backgroundColor = [UIColor clearColor];
        _detailLB.font            = Font(16);
        _detailLB.textColor       = BlackLeverColor5;
        [self addSubview:_detailLB];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, App_Frame_Width, 0.5)];
        _bottomView.backgroundColor = BlackLeverColor2;
        [self addSubview:_bottomView];
        
        
    }
    return self;
}

- (void)setUser:(NIMUser *)user
{
    _user = user;
    [self.avatarImageView setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:100] defaultImage:DefaultSmallAvatar];
    [self.detailLB setText:[JTUserInfoHandle showNick:user.userId]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
