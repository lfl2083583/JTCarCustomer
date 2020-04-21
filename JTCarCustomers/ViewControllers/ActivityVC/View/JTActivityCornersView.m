//
//  JTCornersView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityCornersView.h"

@implementation JTActivityCornersView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(14, 14)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
