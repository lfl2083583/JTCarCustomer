//
//  ZTCicleLabel.m
//  JTCarCustomers
//
//  Created by liufulin on 2019/3/21.
//  Copyright © 2019 JTTeam. All rights reserved.
//

#import "ZTCicleLabel.h"

@implementation ZTCicleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _maskLayer = [CAShapeLayer layer];
        [self.layer setMask:_maskLayer];
        self.borderPath = [UIBezierPath bezierPath];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    
    [super layoutSubviews];
    // 遮罩层frame
    self.maskLayer.frame = self.bounds;
    // 设置path起点
    [self.borderPath moveToPoint:CGPointMake(0, 10)];    // 左上角的圆角
    [self.borderPath addQuadCurveToPoint:CGPointMake(10, 0) controlPoint:CGPointMake(0, 0)];    //直线，到右上角
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];    //直线，到右下角
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height-10)];    //右下角的圆角
    [self.borderPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width-10, self.bounds.size.height) controlPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];    //底部的小三角形
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0 +5, self.bounds.size.height)];
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height - 5)];
    [self.borderPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0 -5, self.bounds.size.height)];    //直线到左下角
    [self.borderPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];    //直线，回到起点
    [self.borderPath addLineToPoint:CGPointMake(0, 10)];
    // 将这个path赋值给maskLayer的path
    self.maskLayer.path = self.borderPath.CGPath;
}
@end
