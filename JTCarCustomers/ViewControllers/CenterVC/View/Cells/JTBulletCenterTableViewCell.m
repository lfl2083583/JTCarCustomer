//
//  JTBulletCenterTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBulletCenterTableViewCell.h"

@implementation JTBulletCenterItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"itemID"    : @"barrage_id",
             @"avatarUrl" : @"avatar",
             @"content"   : @"message",
             };
}

@end

@implementation JTBulletCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.checkBox];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.rightLB];
        
        __weak typeof(self)weakSelf = self;
        [self.checkBox mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(40);
            make.right.equalTo(weakSelf.rightLB.mas_right).offset(10);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bottomView.mas_left).offset(2.5);
            make.top.equalTo(weakSelf.bottomView.mas_top).offset(2.5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).offset(5);
            make.left.equalTo(weakSelf.avatarView.mas_right).offset(10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-5);
        }];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)checkBox {
    if (!_checkBox) {
        _checkBox = [[UIImageView alloc] initWithFrame:CGRectZero];
        _checkBox.image = [UIImage imageNamed:@"icon_accessory_normal"];
    }
    return _checkBox;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.layer.cornerRadius = 6;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UILabel *)rightLB {
    if (!_rightLB) {
        _rightLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLB.numberOfLines = 0;
        _rightLB.textColor = BlackLeverColor3;
        _rightLB.font = Font(16);
        [_rightLB sizeToFit];
    }
    return _rightLB;
}

- (ZTCirlceImageView *)avatarView {
    if (!_avatarView) {
        _avatarView  = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatarView;
}

@end
