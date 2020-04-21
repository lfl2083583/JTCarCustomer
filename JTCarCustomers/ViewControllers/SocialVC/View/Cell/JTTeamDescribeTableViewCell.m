//
//  JTTeamDescribeTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamDescribeTableViewCell.h"

@implementation JTTeamDescribeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.topLB];
        [self.contentView addSubview:self.bottomLB];
        
        __weak typeof(self)weakSelf = self;
        [self.topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(22);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-22);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(13);
        }];
        [self.bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(22);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-22);
            make.top.equalTo(weakSelf.topLB.mas_bottom).offset(5);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-13);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configTableViewCellTitle:(NSString *)title subtitle:(NSString *)subtitle {
    self.topLB.text = title;
    self.bottomLB.text=  subtitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLB.font = Font(16);
        _topLB.numberOfLines = 0;
        _topLB.textColor = BlackLeverColor5;
        [_topLB sizeToFit];
    }
    return _topLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLB.font = Font(15);
        _bottomLB.numberOfLines = 0;
        _bottomLB.textColor = BlackLeverColor3;
        [_bottomLB sizeToFit];
    }
    return _bottomLB;
}

@end
