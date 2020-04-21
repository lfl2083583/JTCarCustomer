//
//  JTTalentTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTalentTableViewCell.h"

@implementation JTTalentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.topLB];
        [self.contentView addSubview:self.centerLB];
        [self.contentView addSubview:self.bottomLB];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addSubview:self.identificateView];
        
        __weak typeof(self)weakSelf = self;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(12);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-12);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bottomView.mas_left).offset(25);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self.topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.avatarView.mas_right).offset(20);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(23);
            make.height.mas_equalTo(21);
        }];
        
        [self.centerLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.avatarView.mas_right).offset(20);
            make.top.equalTo(weakSelf.topLB.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-60);
            make.height.mas_equalTo(17);
        }];
        
        [self.bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bottomView.mas_left).offset(25);
            make.top.equalTo(weakSelf.avatarView.mas_bottom).offset(10);
            make.right.equalTo(weakSelf.bottomView.mas_right).offset(-25);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-16);
            
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(48, 40));
            make.top.equalTo(weakSelf.contentView.mas_top).offset(5);
            make.right.equalTo(weakSelf.bottomView.mas_right).offset(-5);
        }];
        
        [self.identificateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.left.equalTo(weakSelf.topLB.mas_right).offset(5);
            make.centerY.equalTo(weakSelf.topLB.mas_centerY);
        }];
        self.backgroundColor = BlackLeverColor1;
    }
    return self;
}

- (void)configTalentTableViewCellWithTalentInfo:(id)talentInfo indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    if (talentInfo && [talentInfo isKindOfClass:[NSDictionary class]]) {
        [self.avatarView setAvatarByUrlString:[talentInfo[@"avatar"] avatarHandleWithSquare:120] defaultImage:[UIImage imageNamed:@"nav_default"]];
        [self.identificateView setImage:[UIImage imageNamed:@"icon_identification"]];
        self.topLB.text = [NSString stringWithFormat:@"%@",talentInfo[@"name"]];
        NSString *content = [NSString stringWithFormat:@"综合评分：%@分  %@",talentInfo[@"praise"],talentInfo[@"duty_time"]];
        NSString *serveTime = [NSString stringWithFormat:@"%@",talentInfo[@"duty_time"]];
        [self.centerLB setText:content];
        [Utility richTextLabel:self.centerLB fontNumber:Font(12) andRange:NSMakeRange(content.length-serveTime.length, serveTime.length) andColor:BlackLeverColor3];
        [self.bottomLB setText:[NSString stringWithFormat:@"%@",talentInfo[@"introduce"]]];
    }
}

- (void)rightBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(talentTableViewCellDialogBoxClick:)]) {
        [_delegate talentTableViewCellDialogBoxClick:self.indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)identificateView {
    if (!_identificateView) {
        _identificateView = [[UIImageView alloc] init];
    }
    return _identificateView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (ZTCirlceImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatarView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.layer.cornerRadius = 4;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLB.font = Font(18);
        _topLB.textColor = BlackLeverColor5;
    }
    return _topLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLB.font = Font(12);
        _bottomLB.textColor = BlackLeverColor3;
        _bottomLB.numberOfLines = 0;
    }
    return _bottomLB;
}

- (UILabel *)centerLB {
    if (!_centerLB) {
        _centerLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _centerLB.font = Font(12);
        _centerLB.textColor = UIColorFromRGB(0xfc9153);
    }
    return _centerLB;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightBtn setImage:[UIImage imageNamed:@"talent_dialog"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
