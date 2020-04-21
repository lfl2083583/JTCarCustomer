//
//  JTMaintenanceLogTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMaintenanceLogTableViewCell.h"

@implementation JTMaintenanceLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.cicleView];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.subtitleLB];
        [self.contentView addSubview:self.resourceLB];
        
        self.contentView.backgroundColor = BlackLeverColor1;
        __weak typeof(self)weakSelf = self;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.contentView.mas_top);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.cicleView.mas_right).offset(15);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
            make.height.mas_equalTo(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
        }];
        
        [self.cicleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
            make.size.mas_equalTo(CGSizeMake(8, 8));
            make.centerY.equalTo(weakSelf.titleLB.mas_centerY);
        }];
        
        [self.subtitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.right.equalTo(weakSelf.titleLB.mas_right);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(10);
        }];
        
        [self.resourceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.right.equalTo(weakSelf.titleLB.mas_right);
            make.top.equalTo(weakSelf.subtitleLB.mas_bottom).offset(5);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
        }];
    }
    return self;
}

- (void)setItem:(id)item {
    _item = item;
    if (item && [item isKindOfClass:[NSDictionary class]]) {
        NSString *maintainTime = [item objectForKey:@"maintain_time_str"];
        NSInteger maintainType = [[item objectForKey:@"maintain_type"] integerValue];
        NSArray *serviceArray = [item objectForKey:@"service"];
        NSMutableArray *muarray = [NSMutableArray array];
        for (NSDictionary *dictionary in serviceArray) {
            [muarray addObject:[dictionary objectForKey:@"service_name"]];
        }
        
        NSString *title = [NSString stringWithFormat:@"%@   %@KM",maintainTime, [item objectForKey:@"mileage"]];
        NSString *rangeStr = [NSString stringWithFormat:@"%@KM", [item objectForKey:@"mileage"]];
        self.titleLB.text = title;
        self.subtitleLB.text = [muarray componentsJoinedByString:@"，"];
        self.resourceLB.text = (maintainType == 2)?@"来自手动添加":@"来自系统添加";
        [Utility richTextLabel:self.titleLB fontNumber:Font(16) andRange:[title rangeOfString:rangeStr] andColor:BlueLeverColor1];
    }
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

- (UIView *)cicleView {
    if (!_cicleView) {
        _cicleView = [[UIView alloc] init];
        _cicleView.backgroundColor = UIColorFromRGB(0xffa056);
        _cicleView.layer.cornerRadius = 4;
        _cicleView.layer.masksToBounds = YES;
    }
    return _cicleView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _titleLB.textColor = BlackLeverColor6;
    }
    return _titleLB;
}

- (UILabel *)subtitleLB {
    if (!_subtitleLB) {
        _subtitleLB = [[UILabel alloc] init];
        _subtitleLB.font = Font(14);
        _subtitleLB.textColor = BlackLeverColor5;
        _subtitleLB.numberOfLines = 0;
    }
    return _subtitleLB;
}

- (UILabel *)resourceLB {
    if (!_resourceLB) {
        _resourceLB = [[UILabel alloc] init];
        _resourceLB.font = Font(12);
        _resourceLB.textColor = BlackLeverColor3;
    }
    return _resourceLB;
}

@end
