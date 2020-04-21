//
//  JTCarCertificationLicenseTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarCertificationLicenseTableViewCell.h"

@implementation JTCarCertificationLicenseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.siteBtn];
        [self.contentView addSubview:self.licenseTF];
        
        __weak typeof(self)weakSelf = self;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(22);
            make.height.mas_equalTo(20);
        }];
        
        [self.siteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(35, 20));
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(5);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-22);
        }];
        
        [self.licenseTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.siteBtn.mas_right).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(weakSelf.siteBtn.mas_centerY);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)siteBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCarSite:indexPath:)]) {
        [_delegate chooseCarSite:self indexPath:self.indexPath];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(carCertificationLicenseShouldBeginEditing:indexPath:)]) {
        [_delegate carCertificationLicenseShouldBeginEditing:textField indexPath:self.indexPath];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(carCertificationLicenseDidEndChangeEditing:indexPath:)]) {
        [_delegate carCertificationLicenseDidEndChangeEditing:textField indexPath:self.indexPath];
    }
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(14);
        _titleLB.textColor = BlackLeverColor3;
    }
    return _titleLB;
}

- (UIButton *)siteBtn {
    if (!_siteBtn) {
        _siteBtn = [[UIButton alloc] init];
        _siteBtn.titleLabel.font = Font(16);
        [_siteBtn setTitleColor:BlackLeverColor6 forState:UIControlStateNormal];
        [_siteBtn setTitle:@"粤" forState:UIControlStateNormal];
        [_siteBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        [_siteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [_siteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        [_siteBtn addTarget:self action:@selector(siteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _siteBtn;
}

- (UITextField *)licenseTF {
    if (!_licenseTF) {
        _licenseTF = [[UITextField alloc] init];
        _licenseTF.font = Font(16);
        _licenseTF.textColor = BlackLeverColor6;
        _licenseTF.delegate = self;
    }
    return _licenseTF;
}

@end
