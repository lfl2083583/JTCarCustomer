//
//  JTUserTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTUserTableViewCell.h"

@interface JTUserTableViewCell ()

@property (nonatomic, strong) NIMUser *user;

@end

@implementation JTUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.genderView];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.rightBtn];
        
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
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.topLabel.mas_bottom);
            make.left.equalTo(weakSelf.topLabel.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(80);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        }];
        [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topLabel.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 12));
            make.centerY.equalTo(weakSelf.topLabel.mas_centerY);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
    }
    return self;
}

- (void)configCellWithNIMUser:(NIMUser *)user isTeamOwner:(BOOL)isOwner {
    self.user = user;
    [self.avatar setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:50] defaultImage:[UIImage imageNamed:@"nav_default"]];
    NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:user.userInfo.nickName?user.userInfo.nickName:@""];
    if (isOwner) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(5, -2, 24, 20);
        attach.image = [UIImage imageNamed:@"team_owner_icon"];
        NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
        [atributeStr insertAttributedString:strAtt atIndex:user.userInfo.nickName.length];
    }
    self.topLabel.attributedText = atributeStr;
    [self.genderView configGenderView:user.userInfo.gender grade:[[self class] caculateBirthWithBirthDate:user.userInfo.birth]];
    
    __weak typeof(self)weakSelf = self;
    if (!user.userInfo.sign || [user.userInfo.sign isBlankString]) {
        [self.topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.mas_centerY);
        }];
        self.bottomLabel.text = @"";
    }
    else
    {
        [self.topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.mas_centerY).offset(-10);
        }];
       self.bottomLabel.text = user.userInfo.sign;
    }
}

- (void)configCellWithNIMUser:(NIMUser *)user {
    [self configCellWithNIMUser:user isTeamOwner:NO];
}

- (void)configUserCellWithUserInfo:(id)userInfo {
    if (userInfo && [userInfo isKindOfClass:[NSDictionary class]]) {
        [self.avatar setAvatarByUrlString:[[NSString stringWithFormat:@"%@",userInfo[@"avatar"]] avatarHandleWithSquare:50] defaultImage:[UIImage imageNamed:@"nav_default"]];
        self.topLabel.text = [NSString stringWithFormat:@"%@",userInfo[@"nick_name"]];
        [self.genderView configGenderView:[[NSString stringWithFormat:@"%@",userInfo[@"gender"]] integerValue] grade:[[self class] caculateBirthWithBirthDate:userInfo[@"birth"]]];
        
        __weak typeof(self)weakSelf = self;
        NSString *sign = userInfo[@"sign"];
        if (!sign || [sign isBlankString]) {
            [self.topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.mas_centerY);
            }];
            self.bottomLabel.text = @"";
        }
        else
        {
            [self.topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.mas_centerY).offset(-10);
            }];
            self.bottomLabel.text = sign;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)rightBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(followUserWithInfo:)]) {
        [_delegate followUserWithInfo:self.user];
    }
}


+ (NSInteger)caculateBirthWithBirthDate:(NSString *)birthDate {
    NSInteger birth;
    if (birthDate && [birthDate isKindOfClass:[NSString class]] && birthDate.length >= 4) {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger year = [dateComponent year];
        birth = labs([[birthDate substringWithRange:NSMakeRange(0, 4)] integerValue]-year);
    }
    else
    {
        birth = 0;
    }
    return birth;
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

- (JTGenderGradeImageView *)genderView {
    if (!_genderView) {
        _genderView = [[JTGenderGradeImageView alloc] initWithFrame:CGRectZero];
    }
    return _genderView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = BlackLeverColor2;
    }
    return _bottomView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _rightBtn.layer.borderColor = BlueLeverColor1.CGColor;
        _rightBtn.layer.cornerRadius = 15;
        _rightBtn.layer.borderWidth = 1;
        [_rightBtn.layer masksToBounds];
        _rightBtn.hidden = YES;
        _rightBtn.titleLabel.font = Font(15);
        [_rightBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
