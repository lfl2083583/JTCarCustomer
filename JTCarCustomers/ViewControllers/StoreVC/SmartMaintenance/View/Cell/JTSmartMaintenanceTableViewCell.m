//
//  JTSmartMaintenanceTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSmartMaintenanceTableViewCell.h"

@implementation JTSmartMaintenanceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.checkBox];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.discribLB];
        [self.contentView addSubview:self.commodityFeeLB];
        [self.contentView addSubview:self.manhourFeeLB];
        [self.contentView addSubview:self.horizonView];
        
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
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-60);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.commodityFeeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(2.5);
        }];
        
        [self.manhourFeeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.top.equalTo(weakSelf.commodityFeeLB.mas_bottom).offset(2.5);
        }];
        
        [self.discribLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(30);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.top.equalTo(weakSelf.manhourFeeLB.mas_bottom).offset(10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        }];
        
        [self.horizonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-30);
            make.centerY.equalTo(weakSelf.titleLB.mas_centerY);
        }];
    }
    return self;
}

- (void)setMaintenance:(id)maintenance {
    _maintenance = maintenance;
    if (maintenance && [maintenance isKindOfClass:[NSDictionary class]]) {
        self.titleLB.text = [maintenance objectForKey:@"service_name"];
        self.discribLB.text = [maintenance objectForKey:@"introduce"];
        if ([maintenance objectForKey:@"goods_price"]) {
            NSString *commodityFee = [NSString stringWithFormat:@"商品：%@", [maintenance objectForKey:@"goods_price"]];
            self.commodityFeeLB.text = commodityFee;
            [Utility richTextLabel:self.commodityFeeLB fontNumber:Font(16) andRange:NSMakeRange(3, commodityFee.length-3) andColor:RedLeverColor1];
        } else {
            self.commodityFeeLB.text = @"";
        }
        
        if ([maintenance objectForKey:@"hours_price"]) {
            NSString *manhourFee = [NSString stringWithFormat:@"工时：%@", [maintenance objectForKey:@"hours_price"]];
            self.manhourFeeLB.text = manhourFee;
            [Utility richTextLabel:self.manhourFeeLB fontNumber:Font(16) andRange:NSMakeRange(3, manhourFee.length-3) andColor:RedLeverColor1];
        } else {
            self.manhourFeeLB.text = @"";
        }
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

- (UIImageView *)checkBox {
    if (!_checkBox) {
        _checkBox = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 22, 22)];
    }
    return _checkBox;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [self createLBWithFrame:CGRectZero font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textColor:BlackLeverColor6];
    }
    return _titleLB;
}

- (UILabel *)discribLB {
    if (!_discribLB) {
        _discribLB = [self createLBWithFrame:CGRectZero font:Font(12) textColor:BlackLeverColor3];
        _discribLB.numberOfLines = 0;
    }
    return _discribLB;
}

- (UILabel *)commodityFeeLB {
    if (!_commodityFeeLB) {
        _commodityFeeLB = [self createLBWithFrame:CGRectZero font:Font(12) textColor:BlackLeverColor3];
    }
    return _commodityFeeLB;
}

- (UILabel *)manhourFeeLB {
    if (!_manhourFeeLB) {
        _manhourFeeLB = [self createLBWithFrame:CGRectZero font:Font(12) textColor:BlackLeverColor3];
    }
    return _manhourFeeLB;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
    }
    return _bottomView;
}

- (UIView *)horizonView {
    if (!_horizonView) {
        _horizonView = [[UIView alloc] init];
        _horizonView.backgroundColor = BlackLeverColor2;
    }
    return _horizonView;
}

- (UILabel *)createLBWithFrame:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = font;
    label.textColor = textColor;
    return label;
}


@end
