//
//  JTOrderServiceTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderServiceTableViewCell.h"

@implementation JTOrderServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.subtitleLB];
        
        __weak typeof(self)weakSelf = self;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.subtitleLB.mas_left).offset(-5);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(107);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
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

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor3;
        _titleLB.font = Font(14);
    }
    return _titleLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.textColor = BlackLeverColor6;
        _subtitleLB.font = Font(14);
    }
    return _subtitleLB;
}

@end
