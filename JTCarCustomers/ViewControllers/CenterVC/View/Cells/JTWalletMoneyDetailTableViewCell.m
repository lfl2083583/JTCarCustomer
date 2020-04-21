//
//  JTWalletMoneyDetailTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTWalletMoneyDetailTableViewCell.h"

@implementation JTWalletMoneyDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.leftTopLB];
        [self.contentView addSubview:self.leftBottomLB];
        [self.contentView addSubview:self.rightTopLB];
        [self.contentView addSubview:self.rightBottomLB];
        
        __weak typeof(self)weakSelf = self;
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [self.leftTopLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftImageView.mas_right).offset(20);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.height.mas_equalTo(22);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-100);
        }];
        [self.leftBottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftImageView.mas_right).offset(20);
            make.top.equalTo(weakSelf.leftTopLB.mas_bottom);
            make.height.mas_equalTo(17);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-100);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        }];
        [self.rightTopLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(22);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-18);
            make.centerY.equalTo(weakSelf.leftTopLB.mas_centerY);
            make.left.equalTo(weakSelf.leftTopLB.mas_right);
        }];
        [self.rightBottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-18);
            make.centerY.equalTo(weakSelf.leftBottomLB.mas_centerY);
            make.left.equalTo(weakSelf.leftBottomLB.mas_right);
        }];
    }
    return self;
}

- (void)configWalletMoneyDetailTableViewCellWithInfo:(id)info {
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[info[@"ico"] avatarHandleWithSquare:60]]];
    self.leftTopLB.text = info[@"log_name"];
    self.leftBottomLB.text = info[@"create_time"];
    self.rightTopLB.text = [NSString stringWithFormat:@"%.2f",[info[@"number"] floatValue]*[info[@"incType"] floatValue]];
    self.rightBottomLB.text = @"溜车币";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _leftImageView;
}

- (UILabel *)leftTopLB {
    if (!_leftTopLB) {
        _leftTopLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftTopLB.font = Font(16);
        _leftTopLB.textColor = BlackLeverColor5;
    }
    return _leftTopLB;
}

- (UILabel *)leftBottomLB {
    if (!_leftBottomLB) {
        _leftBottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftBottomLB.font = Font(12);
        _leftBottomLB.textColor = BlackLeverColor3;
    }
    return _leftBottomLB;
}

- (UILabel *)rightTopLB {
    if (!_rightTopLB) {
        _rightTopLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightTopLB.font = Font(18);
        _rightTopLB.textColor = BlackLeverColor5;
        _rightTopLB.textAlignment = NSTextAlignmentRight;
        
    }
    return _rightTopLB;
}

- (UILabel *)rightBottomLB {
    if (!_rightBottomLB) {
        _rightBottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightBottomLB.font = Font(12);
        _rightBottomLB.textColor = BlackLeverColor3;
        _rightBottomLB.textAlignment = NSTextAlignmentRight;
    }
    return _rightBottomLB;
}

@end
