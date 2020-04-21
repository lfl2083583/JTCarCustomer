//
//  JTLocalContactsTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTLocalContactsTableViewCell.h"

@interface JTLocalContactsTableViewCell ()


@end

@implementation JTLocalContactsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addSubview:self.bottomView];
        
        __weak typeof(self) weakself = self;
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.contentView.mas_left).offset(22);
            make.top.equalTo(weakself.contentView.mas_top).offset(5);
            make.right.equalTo(weakself.contentView.mas_right).offset(-100);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.topLabel.mas_left);
            make.top.equalTo(weakself.topLabel.mas_bottom).offset(5);
            make.right.equalTo(weakself.contentView.mas_right).offset(-100);
            make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-5);
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 30));
            make.right.equalTo(weakself.contentView.mas_right).offset(-20);
            make.centerY.equalTo(weakself.contentView.mas_centerY);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(weakself.contentView.mas_left).offset(20);
            make.right.equalTo(weakself.contentView.mas_right);
            make.bottom.equalTo(weakself.contentView.mas_bottom);
        }];
    }
    return self;
}

- (void)configCellInfo:(NSDictionary *)info indexPath:(NSIndexPath *)indexPath {
    self.topLabel.text = [info objectForKey:@"name"];
    self.bottomLabel.text = [info objectForKey:@"phone"];
    self.indexPath = indexPath;
    JTServiceType type = [[info objectForKey:@"type"] integerValue];
    UIColor *color;
    BOOL enable = NO;
    if (type == JTServiceUnRegister) {
        [_rightBtn setTitle:@"邀请" forState:UIControlStateNormal];
        color = BlueLeverColor1;
        enable = YES;
    }else if (type == JTServiceFocus) {
        [_rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
        color = BlackLeverColor3;
        enable = NO;
    }else {
        [_rightBtn setTitle:@"关注" forState:UIControlStateNormal];
        color = BlueLeverColor1;
        enable = YES;
    }
    self.rightBtn.enabled = enable;
    self.rightBtn.layer.borderColor = color.CGColor;
    self.rightBtn.layer.borderWidth = 0.5;
    [self.rightBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)rightBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tableCellRightButtonClickWithIndexpath:)]) {
        [_delegate tableCellRightButtonClickWithIndexpath:self.indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.font = Font(12);
        _bottomLabel.textColor = BlackLeverColor3;
    }
    return _bottomLabel;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabel.font = Font(16);
        _topLabel.textColor = BlackLeverColor5;
    }
    return _topLabel;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _rightBtn.titleLabel.font = Font(16);
        _rightBtn.layer.cornerRadius = 15;
        _rightBtn.enabled = NO;
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = BlackLeverColor2;
    }
    return _bottomView;
}
@end
