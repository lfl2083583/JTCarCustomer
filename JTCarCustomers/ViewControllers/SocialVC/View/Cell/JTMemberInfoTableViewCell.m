//
//  JTTeamInfoTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamInfoHandle.h"
#import "ZTCirlceImageView.h"
#import "JTMemberInfoTableViewCell.h"

@interface JTMemberInfoTableViewCell ()

@property (nonatomic, strong) ZTCirlceImageView *avatar;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UIImageView *rightImgeView;
@property (nonatomic, strong) UILabel *bottomLB;


@end

@implementation JTMemberInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.topLB];
        [self.contentView addSubview:self.rightImgeView];
        [self.contentView addSubview:self.bottomLB];
        
        __weak typeof(self)weakSelf = self;
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self.topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.avatar.mas_right).offset(15);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(-10);
            make.height.mas_equalTo(25);
        }];
        [self.rightImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topLB.mas_right).offset(5);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(32);
            make.centerY.equalTo(weakSelf.topLB.mas_centerY);
        }];
        [self.bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.avatar.mas_right).offset(15);
            make.top.equalTo(weakSelf.topLB.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)configMemberInfoCell:(id)info {
    
    if ([info isKindOfClass:[NIMTeam class]]) {
        NIMTeam *team = info;
        [self.avatar setAvatarByUrlString:[team.avatarUrl avatarHandleWithSquare:160] defaultImage:[UIImage imageNamed:@"default_group_icon"]];
        self.topLB.text = team.teamName;
        JTTeamCategoryType category = [JTTeamInfoHandle showTeamCategoryWithTeam:team];
        self.rightImgeView.image = [JTTeamInfoHandle showTeamCategoryImage:category];
        self.bottomLB.text = [NSString stringWithFormat:@"群号：%@",team.teamId];
    }else if ([info isKindOfClass:[NIMUser class]]) {
        NIMUser *user = info;
        [self.avatar setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:160] defaultImage:[UIImage imageNamed:@"nav_default"]];
        self.topLB.text = [JTUserInfoHandle showNick:user member:nil];
        self.rightImgeView.hidden = YES;
        self.bottomLB.text = [NSString stringWithFormat:@"%@",user.userInfo.sign?user.userInfo.sign:@""];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLB.font = Font(18);
        [_topLB sizeToFit];
    }
    return _topLB;
}


- (UIImageView *)rightImgeView {
    if (!_rightImgeView) {
        _rightImgeView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _rightImgeView;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLB.font = Font(14);
        _bottomLB.textColor = BlackLeverColor3;
    }
    return _bottomLB;
}

- (ZTCirlceImageView *)avatar {
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatar;
}
@end
