//
//  JTMaintenanceExplainTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMaintenanceExplainTableViewCell.h"

@implementation JTMaintenanceExplainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topLB];
        [self.contentView addSubview:self.bottomLB];
        [self.contentView addSubview:self.rightBtn];
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

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, App_Frame_Width-80, 20)];
        _topLB.font = Font(16);
        _topLB.textColor = BlackLeverColor6;
        _topLB.text = @"小保养服务";
    }
    return _topLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.topLB.frame), App_Frame_Width-85, 20)];
        _bottomLB.font = Font(12);
        _bottomLB.textColor = BlackLeverColor3;
        _bottomLB.text = @"5000KM或6个月/次";
    }
    return _bottomLB;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(App_Frame_Width-70, 0, 60, 60)];
        _rightBtn.titleLabel.font = Font(14);
        [_rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_rightBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    return _rightBtn;
}

@end
