//
//  JTGenderGradeImageView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTGenderGradeImageView.h"

@interface JTGenderGradeImageView ()

@property (nonatomic, strong) UIImageView *leftImgeView;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation JTGenderGradeImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.leftImgeView];
    [self addSubview:self.rightLabel];
    self.backgroundColor = UIColorFromRGB(0xFF6264);
    
    __weak typeof (self)weakSelf = self;
    [self.leftImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImgeView.mas_right).offset(2);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (![self.subviews containsObject:self.leftImgeView]) {
        [self setupUI];
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)configGenderView:(NIMUserGender)gender grade:(NSInteger)grade {
    if (gender == NIMUserGenderMale) {
        self.leftImgeView.image = [UIImage imageNamed:@"user_boy_icon"];
    }else{
       self.leftImgeView.image = [UIImage imageNamed:@"user_girl_icon"];
    }
    self.rightLabel.text = [NSString stringWithFormat:@"%ld",grade];
}

- (UIImageView *)leftImgeView {
    if (!_leftImgeView) {
        _leftImgeView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftImgeView.contentMode = UIViewContentModeScaleAspectFit;
        _leftImgeView.image = [UIImage imageNamed:@"user_boy_icon"];
    }
    return _leftImgeView;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textColor = WhiteColor;
        _rightLabel.font = Font(10);
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.text = @"0";
    }
    return _rightLabel;
}

@end
