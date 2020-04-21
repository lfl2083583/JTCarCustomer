//
//  JTOrderRescueServiceTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderRescueServiceTableViewCell.h"

@implementation JTOrderRescueServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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

//- (UILabel *)titleLB {
//    if (!_titleLB) {
//        _titleLB = [[UILabel alloc] init];
//    }
//    return _titleLB;
//}

- (UILabel *)addressLB {
    if (!_addressLB) {
        _addressLB = [[UILabel alloc] init];
        _addressLB.textColor = BlackLeverColor3;
        _addressLB.font = Font(16);
    }
    return _addressLB;
}

- (UILabel *)serviceLB {
    if (!_serviceLB) {
        _serviceLB = [[UILabel alloc] init];
        _serviceLB.textColor = BlackLeverColor3;
        _serviceLB.font = Font(16);
    }
    return _serviceLB;
}

- (UILabel *)timeLB {
    if (_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.textColor = BlackLeverColor3;
        _timeLB.font = Font(16);
    }
    return _timeLB;
}

- (UILabel *)timeContentLB {
    if (!_timeContentLB) {
        _timeContentLB = [[UILabel alloc] init];
        _timeContentLB.textColor = BlackLeverColor6;
        _timeContentLB.font = Font(16);
    }
    return _timeContentLB;
}

- (UILabel *)addressContentLB {
    if (!_addressContentLB) {
        _addressContentLB = [[UILabel alloc] init];
        _addressContentLB.textColor = BlackLeverColor6;
        _addressContentLB.font = Font(16);
    }
    return _addressContentLB;
}

- (UILabel *)serviceContentLB {
    if (!_serviceContentLB) {
        _serviceContentLB = [[UILabel alloc] init];
        _serviceContentLB.textColor = BlackLeverColor6;
        _serviceContentLB.font = Font(16);
    }
    return _serviceContentLB;
}

@end
