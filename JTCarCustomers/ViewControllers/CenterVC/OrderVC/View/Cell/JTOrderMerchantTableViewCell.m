//
//  JTOrderMerchantTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderMerchantTableViewCell.h"

@implementation JTOrderMerchantTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.merchantName];
        [self.contentView addSubview:self.merchantAddress];
        [self.contentView addSubview:self.merchantDistance];
        [self.contentView addSubview:self.merchantNav];
        
        __weak typeof(self)weakSelf = self;
        [self.merchantName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-80);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(13);
        }];
        
        [self.merchantAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-80);
            make.top.equalTo(weakSelf.merchantName.mas_bottom).offset(5);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-13);
        }];
        
        [self.merchantNav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-40);
            make.bottom.equalTo(weakSelf.merchantDistance.mas_top).offset(-7);
        }];
        
        [self.merchantDistance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.merchantAddress.mas_centerY);
            make.centerX.equalTo(weakSelf.merchantNav.mas_centerX);
        }];
        
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self.merchantName setText:@"深圳爱车吧名车服务中心"];
    [self.merchantAddress setText:@"深圳市龙华新区东环二好46号心眼里"];
    [self.merchantDistance setText:@"距您1.93km"];
    
}

- (UILabel *)merchantName {
    if (!_merchantName) {
        _merchantName = [[UILabel alloc] init];
        _merchantName.font = Font(16);
        _merchantName.textColor = BlackLeverColor6;
    }
    return _merchantName;
}

- (UILabel *)merchantAddress {
    if (!_merchantAddress) {
        _merchantAddress = [[UILabel alloc] init];
        _merchantAddress.font = Font(14);
        _merchantAddress.textColor = BlackLeverColor3;
    }
    return _merchantAddress;
}

- (UILabel *)merchantDistance {
    if (!_merchantDistance) {
        _merchantDistance = [[UILabel alloc] init];
        _merchantDistance.font = Font(12);
        _merchantDistance.textColor = BlackLeverColor3;
        _merchantDistance.textAlignment = NSTextAlignmentCenter;
    }
    return _merchantDistance;
}

- (UIButton *)merchantNav {
    if (!_merchantNav) {
        _merchantNav = [[UIButton alloc] init];
        [_merchantNav setImage:[UIImage imageNamed:@"icon_navigation"] forState:UIControlStateNormal];
    }
    return _merchantNav;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
