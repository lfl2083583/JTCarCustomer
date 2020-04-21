//
//  JTNearbyTeamTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamInfoHandle.h"
#import "JTNearbyTeamTableViewCell.h"

@implementation JTNearbyTeamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.centerLabel];
        [self.contentView addSubview:self.centerImgeView];
        [self.contentView addSubview:self.rightImgeView];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addSubview:self.rightBottomLB];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.bottomView];
        
        __weak typeof(self)weakSelf = self;
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.avatar.mas_right).offset(7);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        }];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.avatar.mas_right).offset(10);
            make.top.equalTo(weakSelf.topLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(16);
        }];
        [self.centerImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.centerLabel.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(32, 16));
            make.centerY.equalTo(weakSelf.centerLabel.mas_centerY);
        }];
        [self.rightImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 16));
            make.left.equalTo(weakSelf.centerImgeView.mas_right).offset(5);
            make.centerY.equalTo(weakSelf.centerImgeView.mas_centerY);
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 30));
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self.rightBottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.rightImgeView.mas_right).offset(5);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(weakSelf.rightImgeView.mas_centerY);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.centerLabel.mas_bottom).offset(5);
            make.left.equalTo(weakSelf.avatar.mas_right).offset(7);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-85);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(58);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)configNearbyCellWithTeamInfo:(id)teamInfo indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    if (teamInfo && [teamInfo isKindOfClass:[NSDictionary class]]) {
        [self.avatar setAvatarByUrlString:[[NSString stringWithFormat:@"%@",teamInfo[@"head_image"]] avatarHandleWithSquare:50] defaultImage:[UIImage imageNamed:@"default_group_icon"]];
        self.topLabel.text = [NSString stringWithFormat:@"%@",teamInfo[@"name"]];
        self.centerLabel.text = [NSString stringWithFormat:@" %@人  ",teamInfo[@"count"]];
        self.bottomLabel.text = [NSString stringWithFormat:@"%@",teamInfo[@"describe"]];
        self.rightBottomLB.text = [NSString stringWithFormat:@"%@",teamInfo[@"distance"][@"distance"]];
        BOOL isJoin = [teamInfo[@"is_member"] boolValue];
        self.rightBtn.hidden = isJoin;
        JTTeamCategoryType category = [teamInfo[@"category"] integerValue];
        self.centerImgeView.image = [JTTeamInfoHandle showTeamCategoryImage:category];
    }
}

- (void)rightBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tableCellRightBtnClick:)]) {
        [_delegate tableCellRightBtnClick:self.indexPath];
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

- (ZTCirlceImageView *)avatar {
    if (!_avatar) {
        _avatar = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatar;
}

- (UIImageView *)rightImgeView {
    if (!_rightImgeView) {
        _rightImgeView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImgeView.image = [UIImage imageNamed:@"team_nearby_loction"];
    }
    return _rightImgeView;
}

- (UIImageView *)centerImgeView {
    if (!_centerImgeView) {
        _centerImgeView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _centerImgeView;
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

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _centerLabel.font = Font(12);
        _centerLabel.textColor = WhiteColor;
        _centerLabel.layer.cornerRadius = 8;
        _centerLabel.layer.masksToBounds = YES;
        _centerLabel.backgroundColor = BlueLeverColor1;
        _centerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLabel;
}

- (UILabel *)rightBottomLB {
    if (!_rightBottomLB) {
        _rightBottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightBottomLB.font = Font(14);
        _rightBottomLB.textColor = BlackLeverColor3;
    }
    return _rightBottomLB;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _rightBtn.titleLabel.font = Font(14);
        _rightBtn.layer.cornerRadius = 15;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.borderColor = BlueLeverColor1.CGColor;
        _rightBtn.layer.borderWidth = 1;
        [_rightBtn setTitle:@"加入" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.font = Font(12);
        _bottomLabel.textColor = BlackLeverColor3;
        [_bottomLabel sizeToFit];
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
