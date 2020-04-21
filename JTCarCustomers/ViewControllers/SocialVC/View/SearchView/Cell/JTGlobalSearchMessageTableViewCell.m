//
//  JTGlobalSearchMessageTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTGlobalSearchMessageTableViewCell.h"

@implementation JTGlobalSearchMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImageView = [[ZTCirlceImageView alloc] init];
        self.nameLabel = [self createLabelWithTextColor:BlackLeverColor6 textAlignment:NSTextAlignmentLeft textFont:Font(18)];
        self.messageLabel = [self createLabelWithTextColor:BlackLeverColor3 textAlignment:NSTextAlignmentLeft textFont:Font(14)];
        self.timeLabel = [self createLabelWithTextColor:BlackLeverColor3 textAlignment:NSTextAlignmentRight textFont:Font(12)];
        self.horizontalView = [[UIView alloc] init];
        self.horizontalView.backgroundColor = BlackLeverColor2;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.horizontalView];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.top.equalTo(self.avatarImageView.mas_top).offset(5);
            make.right.equalTo(self.timeLabel.mas_left).offset(-5);
            make.height.mas_equalTo(20);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.right.equalTo(@(0));
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)createLabelWithTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment textFont:(UIFont *)textFont {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.font = textFont;
    return label;
}

@end
