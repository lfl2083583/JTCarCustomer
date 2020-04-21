//
//  JTCardUserInfoCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCardUserInfoCell.h"

@implementation JTCardUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.genderView];
        [self.contentView addSubview:self.centerLabel];
        [self.contentView addSubview:self.bottomLabel];
        
        __weak typeof(self)weakSelf = self;
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(12);
            make.height.mas_equalTo(@28);
        }];
        [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topLabel.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 12));
            make.centerY.equalTo(weakSelf.topLabel.mas_centerY);
        }];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.top.equalTo(weakSelf.topLabel.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-22);
            make.height.mas_equalTo(@20);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.top.equalTo(weakSelf.centerLabel.mas_bottom).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-22);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configCellWithUserInfo:(JTNormalUserInfo *)userInfo {
    NSString *sign = (!userInfo.userSign || [userInfo.userSign isBlankString])?@"未设置":userInfo.userSign;
    self.topLabel.text = userInfo.userName;
    self.centerLabel.text = [NSString stringWithFormat:@"溜车号：%@",userInfo.userNumberCode];
    self.bottomLabel.text = [NSString stringWithFormat:@"个性签名：%@",sign];
    [self.genderView configGenderView:userInfo.userGenter grade:userInfo.userAge];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (JTGenderGradeImageView *)genderView {
    if (!_genderView) {
        _genderView = [[JTGenderGradeImageView alloc] initWithFrame:CGRectZero];
    }
    return _genderView;
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabel.font = Font(18);
        _topLabel.textColor = BlackLeverColor6;
    }
    return _topLabel;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _centerLabel.font = Font(14);
        _centerLabel.textColor = BlackLeverColor3;
    }
    return _centerLabel;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.font = Font(14);
        _bottomLabel.textColor = BlackLeverColor3;
        _bottomLabel.numberOfLines = 0;
    }
    return _bottomLabel;
}
@end
