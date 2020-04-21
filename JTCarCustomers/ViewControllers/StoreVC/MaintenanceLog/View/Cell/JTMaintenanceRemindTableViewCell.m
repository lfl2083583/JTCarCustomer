//
//  JTMaintenanceRemindTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMaintenanceRemindTableViewCell.h"

@interface JTMaintenanceRemindTableViewCell ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation JTMaintenanceRemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.lastMaintenanceLB];
        [self.contentView addSubview:self.nextMaintenanceLB];
        [self.contentView addSubview:self.remainLB];
        [self.contentView addSubview:self.horizontalView];
        [self.contentView addSubview:self.suggestTitleLB];
        [self.contentView addSubview:self.suggestContentLB];
        [self.contentView addSubview:self.smartMaintenanceBtn];
        
        __weak typeof(self)weakSelf = self;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BlackLeverColor1;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(40);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
            make.height.mas_equalTo(25);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
        }];
        
        [self.lastMaintenanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            make.right.equalTo(weakSelf.titleLB.mas_right);
        }];
        
        [self.nextMaintenanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.top.equalTo(weakSelf.lastMaintenanceLB.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            make.right.equalTo(weakSelf.titleLB.mas_right);
        }];
        
        [self.remainLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.top.equalTo(weakSelf.nextMaintenanceLB.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            make.right.equalTo(weakSelf.titleLB.mas_right);
        }];
        
        [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
            make.top.equalTo(weakSelf.remainLB.mas_bottom).offset(10);
            make.height.mas_equalTo(0.5);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
        }];
        
        [self.suggestTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.top.equalTo(weakSelf.horizontalView.mas_bottom).offset(10);
        }];
        
        [self.suggestContentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(110);
            make.top.equalTo(weakSelf.horizontalView.mas_bottom).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
        }];
        
        [self.smartMaintenanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(40);
            make.top.equalTo(weakSelf.suggestContentLB.mas_bottom).offset(15);
            make.height.mas_equalTo(45);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-40);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
        }];
    }
    return self;
}

- (void)setRemindData:(id)remindData {
    _remindData = remindData;
    if (remindData && [remindData isKindOfClass:[NSDictionary class]]) {
        self.titleLB.text = @"保养提醒";
        NSDictionary *lastDict = [remindData objectForKey:@"last"];
        self.lastMaintenanceLB.text = [NSString stringWithFormat:@"上次保养      %@KM  %@", lastDict[@"mileage"], lastDict[@"maintain_time"]];
        NSDictionary *nextDict = [remindData objectForKey:@"next"];
        NSString *nextMaintenance = [NSString stringWithFormat:@"预计下次保养   %@KM  %@", nextDict[@"mileage"], nextDict[@"maintain_time"]];
        NSString *nextRangeStr = [NSString stringWithFormat:@"%@KM  %@", nextDict[@"mileage"], nextDict[@"maintain_time"]];
        self.nextMaintenanceLB.text = nextMaintenance;
        [Utility richTextLabel:self.nextMaintenanceLB fontNumber:Font(14) andRange:[nextMaintenance rangeOfString:nextRangeStr] andColor:BlueLeverColor1];
        NSString *remainStr = [NSString stringWithFormat:@"还剩   %@", nextDict[@"time_str"]];
        self.remainLB.text = remainStr;
        [Utility richTextLabel:self.remainLB fontNumber:Font(14) andRange:[remainStr rangeOfString:nextDict[@"time_str"]] andColor:BlueLeverColor1];
        self.suggestTitleLB.text = @"建义项目";
        NSArray *maintenanceList = [remindData objectForKey:@"maintain"];
        
        [self.datas removeAllObjects];
        for (NSDictionary *dict in maintenanceList) {
            [self.datas addObject:[dict objectForKey:@"maintenance_name"]];
        }
        NSString *suggest = [self.datas componentsJoinedByString:@"，"];

        self.suggestContentLB.text = suggest;
    }
}

- (void)smartMaintenanceBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(smartMaintenancePlan)]) {
        [_delegate smartMaintenancePlan];
    }
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [self createLBWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18] textColor:BlackLeverColor6];
    }
    return _titleLB;
}

- (UILabel *)lastMaintenanceLB {
    if (!_lastMaintenanceLB) {
        _lastMaintenanceLB = [self createLBWithFont:Font(14) textColor:BlackLeverColor3];
    }
    return _lastMaintenanceLB;
}

- (UILabel *)nextMaintenanceLB {
    if (!_nextMaintenanceLB) {
        _nextMaintenanceLB = [self createLBWithFont:Font(14) textColor:BlackLeverColor3];
    }
    return _nextMaintenanceLB;
}

- (UILabel *)remainLB {
    if (!_remainLB) {
        _remainLB = [self createLBWithFont:Font(14) textColor:BlackLeverColor3];
    }
    return _remainLB;
}

- (UILabel *)suggestTitleLB {
    if (!_suggestTitleLB) {
        _suggestTitleLB = [self createLBWithFont:Font(14) textColor:BlackLeverColor3];
    }
    return _suggestTitleLB;
}

- (UILabel *)suggestContentLB {
    if (!_suggestContentLB) {
        _suggestContentLB = [self createLBWithFont:Font(14) textColor:BlackLeverColor3];
        _suggestContentLB.numberOfLines = 0;
        _suggestContentLB.preferredMaxLayoutWidth = (App_Frame_Width - 140);
        [_suggestContentLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _suggestContentLB;
}

- (UIView *)horizontalView {
    if (!_horizontalView) {
        _horizontalView = [[UIView alloc] init];
        _horizontalView.backgroundColor = BlackLeverColor2;
    }
    return _horizontalView;
}

- (UIButton *)smartMaintenanceBtn {
    if (!_smartMaintenanceBtn) {
        _smartMaintenanceBtn = [[UIButton alloc] init];
        _smartMaintenanceBtn.backgroundColor = BlueLeverColor1;
        _smartMaintenanceBtn.titleLabel.font = Font(16);
        _smartMaintenanceBtn.layer.cornerRadius = 4;
        _smartMaintenanceBtn.layer.masksToBounds = YES;
        [_smartMaintenanceBtn setTitle:@"查看智能保养方案" forState:UIControlStateNormal];
        [_smartMaintenanceBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_smartMaintenanceBtn addTarget:self action:@selector(smartMaintenanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smartMaintenanceBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (UILabel *)createLBWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    return label;
}
@end
