//
//  JTSegmentalView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/14.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSegmentalView.h"
@interface JTSegmentalView ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation JTSegmentalView

- (NSMutableArray *)views {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

- (instancetype _Nullable )initWithFrame:(CGRect)frame titles:(nullable NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    for (int i = 0; i < self.titles.count; i++) {
        CGFloat width = self.bounds.size.width / self.titles.count;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * i, 0, width, self.bounds.size.height)];
        button.tag = i;
        button.titleLabel.font = Font(18);
        button.layer.cornerRadius = self.bounds.size.height / 2.0;
        button.layer.masksToBounds = YES;
        [button setTitleColor:WhiteColor forState:UIControlStateSelected];
        [button setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage graphicsImageWithColor:UIColorFromRGB(0xdfdfdf) rect:button.bounds] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage graphicsImageWithColor:BlueLeverColor1 rect:button.bounds] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.views addObject:button];
        [self addSubview:button];
    }
    
    UIButton *seletedBtn = [self.views firstObject];
    seletedBtn.selected = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.bounds.size.height,self.bounds.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.backgroundColor = UIColorFromRGB(0xdfdfdf);
}

- (void)buttonClick:(UIButton *)sender {
    for (UIButton *button in self.views) {
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
