//
//  JTMaintenanceEditTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIImage+Extension.h"
#import "JTMaintenanceEditTableViewCell.h"

@implementation JTMaintenanceReusableview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, App_Frame_Width-22, 20)];
        self.titleLB.font = Font(14);
        self.titleLB.textColor = BlackLeverColor6;
        [self addSubview:self.titleLB];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

@end

@implementation JTMaintenanceEditColectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLB];
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 1;
        self.layer.borderColor = BlackLeverColor2.CGColor;
    }
    return self;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.frame = self.bounds;
        _titleLB.font = Font(14);
        _titleLB.textColor = BlackLeverColor3;
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end

@interface JTMaintenanceEditTableViewCell ()


@end

@implementation JTMaintenanceEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
