//
//  JTTeamTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamInfoHandle.h"
#import "JTTeamTableViewCell.h"

@implementation JTTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.rightImgeView];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.bottomView];
        
        __weak typeof(self)weakSelf = self;
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.avatar.mas_right).offset(10);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
            make.height.mas_equalTo(20);
        }];
        [self.rightImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topLabel.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(32, 16));
            make.centerY.equalTo(weakSelf.topLabel.mas_centerY);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.topLabel.mas_bottom);
            make.left.equalTo(weakSelf.topLabel.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}


- (void)configTeamCellWithTeam:(NIMTeam *)team {
    [self.avatar setAvatarByUrlString:[[NSString stringWithFormat:@"%@",team.avatarUrl] avatarHandleWithSquare:50] defaultImage:[UIImage imageNamed:@"default_group_icon"]];
    NSString *teamName = team.teamName;
    JTTeamMemeberType memeberType = [team.owner isEqualToString:[JTUserInfo shareUserInfo].userYXAccount]?JTTeamMemeberTypeOwner:JTTeamMemeberTypeNormal;
    NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:teamName];
    if (memeberType == JTTeamMemeberTypeOwner) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(5, -2, 24, 20);
        attach.image = [UIImage imageNamed:@"team_owner_icon"];
        NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
        [atributeStr insertAttributedString:strAtt atIndex:teamName.length];
    }
    self.topLabel.attributedText = atributeStr;
    JTTeamCategoryType teamCategory = [JTTeamInfoHandle showTeamCategoryWithTeam:team];
    self.rightImgeView.image = [JTTeamInfoHandle showTeamCategoryImage:teamCategory];
}

- (void)configTeamCellWithTeamInfo:(id)teamInfo {
    if (teamInfo && [teamInfo isKindOfClass:[NSDictionary class]]) {
        [self.avatar setAvatarByUrlString:[[NSString stringWithFormat:@"%@",teamInfo[@"head_image"]] avatarHandleWithSquare:50] defaultImage:[UIImage imageNamed:@"default_group_icon"]];
        NSString *teamName = teamInfo[@"name"];
        JTTeamMemeberType memeberType = [teamInfo[@"role_type"] integerValue];
        NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:teamName];
        if (memeberType == JTTeamMemeberTypeOwner) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.bounds = CGRectMake(5, -2, 24, 20);
            attach.image = [UIImage imageNamed:@"team_owner_icon"];
            NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
            [atributeStr insertAttributedString:strAtt atIndex:teamName.length];
        }
        self.topLabel.attributedText = atributeStr;
        self.bottomLabel.text = [NSString stringWithFormat:@"%@",teamInfo[@"describe"]];
        JTTeamCategoryType teamCategory = [teamInfo[@"category"] integerValue];
        self.rightImgeView.image = [JTTeamInfoHandle showTeamCategoryImage:teamCategory];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (ZTCirlceImageView *)avatar {
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatar;
}

- (UIImageView *)rightImgeView {
    if (!_rightImgeView) {
        _rightImgeView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImgeView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImgeView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabel.font = Font(18);
        _topLabel.textColor = BlackLeverColor6;
        [_topLabel sizeToFit];
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.font = Font(14);
        _bottomLabel.textColor = BlackLeverColor3;
    }
    return _bottomLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = BlackLeverColor2;
    }
    return _bottomView;
}

@end
