//
//  JTOrderLiveTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderLiveTableViewCell.h"

@implementation JTOrderLiveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.playBtn];
        
        __weak typeof(self)weakSelf = self;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        }];
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(10);
            make.height.mas_equalTo((App_Frame_Width-40)*(22/33.0));
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerX.equalTo(weakSelf.coverView.mas_centerX);
            make.centerY.equalTo(weakSelf.coverView.mas_centerY);
        }];
        
        
    }
    return self;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.text = @"实时工位直播";
    }
    return _titleLB;
}

- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
        _coverView.backgroundColor = UIColorFromRGB(0xd8d8d8);
    }
    return _coverView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:[UIImage imageNamed:@"bt_play"] forState:UIControlStateNormal];
    }
    return _playBtn;
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
