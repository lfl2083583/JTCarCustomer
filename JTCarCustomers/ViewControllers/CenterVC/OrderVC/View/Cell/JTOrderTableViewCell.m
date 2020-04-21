//
//  JTOrderTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderTableViewCell.h"

@implementation JTOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.detailLB];
        [self.contentView addSubview:self.timeLB];
        [self.contentView addSubview:self.statusLB];
        
        __weak typeof(self)weakSelf = self;
        self.contentView.backgroundColor = BlackLeverColor1;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
            make.height.mas_equalTo(30);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        }];
        
        [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(5);
        }];
        
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.top.equalTo(weakSelf.detailLB.mas_bottom).offset(5);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        }];
        
        [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.centerY.equalTo(weakSelf.titleLB.mas_centerY);
        }];
        
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self.titleLB setText:@"   拖车   "];
    [self.detailLB setText:@"奥迪Q52017款2.0 TFSI  手自一体 40 TFSI动感型 粤B 36888"];
    [self.timeLB setText:@"2018-03-24  15:00"];
    [self.statusLB setText:@"预约失败"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [self createLabel:Font(16) textcolor:BlueLeverColor1];
        _titleLB.backgroundColor = UIColorFromRGB(0xe8edff);
        _titleLB.layer.cornerRadius = 15;
        _titleLB.layer.masksToBounds = YES;
    }
    return _titleLB;
}

- (UILabel *)detailLB {
    if (!_detailLB) {
        _detailLB = [self createLabel:Font(14) textcolor:BlackLeverColor5];
        _detailLB.numberOfLines = 0;
    }
    return _detailLB;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [self createLabel:Font(14) textcolor:BlackLeverColor3];
    }
    return _timeLB;
}

- (UILabel *)statusLB {
    if (!_statusLB) {
        _statusLB = [self createLabel:Font(14) textcolor:RedLeverColor1];
    }
    return _statusLB;
}

- (UILabel *)createLabel:(UIFont *)font textcolor:(UIColor *)textcolor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textcolor;
    return label;
}

@end
