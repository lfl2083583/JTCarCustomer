//
//  JTPersonalTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTPersonalTableViewCell.h"

@implementation JTPersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupData{
    UILabel *leftLabel = [self.contentView viewWithTag:10];
    UILabel *bottomLabel = [self.contentView viewWithTag:30];
    UIImageView *rightImgView = [self.contentView viewWithTag:20];
    leftLabel.text = [JTUserInfo shareUserInfo].userName;
    NSString *sign = @"还未填写个性签名，介绍下自己吧~";
    if ([JTUserInfo shareUserInfo].userSign && [[JTUserInfo shareUserInfo].userSign isKindOfClass:[NSString class]] && [JTUserInfo shareUserInfo].userSign.length) {
        sign = [JTUserInfo shareUserInfo].userSign;
    }
    bottomLabel.text = sign;
    [rightImgView sd_setImageWithURL:[NSURL URLWithString:[JTUserInfo shareUserInfo].userAvatar] placeholderImage:[UIImage imageNamed:@"login_sex_boys"]];
}

@end
