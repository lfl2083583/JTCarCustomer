//
//  ZTSegmentedControl.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/12.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTSegmentedControl.h"

@interface ZTSegmentedControl ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *verticalView;

@end

@implementation ZTSegmentedControl

- (void)setHorizonLineColor:(UIColor *)horizonLineColor {
    _horizonLineColor = horizonLineColor;
    _bottomView.backgroundColor = horizonLineColor;
}

- (void)setShowHorizonLine:(BOOL)showHorizonLine {
    _showHorizonLine = showHorizonLine;
    [self addSubview:self.bottomView];
}

- (void)setVerticalLineColor:(UIColor *)verticalLineColor {
    _verticalLineColor = verticalLineColor;
    _verticalView.backgroundColor = verticalLineColor;
}

- (void)setShowVerticalLine:(BOOL)showVerticalLine {
    _showVerticalLine = showVerticalLine;
    [self addSubview:self.verticalView];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, CGRectGetWidth(self.frame), 0.5)];
        _bottomView.backgroundColor = BlackLeverColor2;
    }
    return _bottomView;
}

- (UIView *)verticalView {
    if (!_verticalView) {
        _verticalView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-1)/2.0, 10, 1,  CGRectGetHeight(self.frame)-20)];
        _verticalView.backgroundColor = BlackLeverColor2;
    }
    return _verticalView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    NSInteger count = self.sectionTitles.count;
    CGFloat width = CGRectGetWidth(self.bounds)/count;
    if (self.indexClick) {
        self.indexClick((point.x)/width);
    }
}

@end
