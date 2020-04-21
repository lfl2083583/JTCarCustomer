//
//  JTFlowView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTFlowView.h"

@implementation JTFlowView

- (instancetype)initImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = imageArray;
        _titleArray = titleArray;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = WhiteColor;
    CGFloat originX = 36;
    CGFloat xspace = (App_Frame_Width-originX*2-40*self.titleArray.count)/(self.titleArray.count-1);
    for (int i = 0; i < self.titleArray.count; i++) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(originX+(xspace+40)*i, 20, 40, 40)];
        iconView.image = [UIImage imageNamed:self.imageArray[i]];
        [self addSubview:iconView];
        
        UILabel *contentLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame)+8, 80, 20)];
        contentLB.font = Font(14);
        contentLB.tag = 10+i;
        contentLB.textColor = BlackLeverColor3;
        contentLB.text = self.titleArray[i];
        contentLB.textAlignment = NSTextAlignmentCenter;
        contentLB.centerX = iconView.centerX;
        [self addSubview:contentLB];
        
        if (i != self.titleArray.count-1) {
            UIImageView *dashView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame), CGRectGetMidY(iconView.frame)-0.5, xspace, 1)];
            dashView.tag = 20+i;
            [self addSubview:dashView];
            [self drawDashLine:dashView lineLength:3 lineSpacing:2 lineColor:BlackLeverColor2];
        }
    }
}

- (void)setCurrentFlow:(NSInteger)currentFlow {
    _currentFlow = currentFlow;
    if (currentFlow < self.titleArray.count) {
        for (int i = 0; i < currentFlow; i++) {
            UILabel *contentLabel = [self viewWithTag:10+i];
            contentLabel.textColor = BlackLeverColor6;
            UIImageView *imageView = [self viewWithTag:20+i];
            if (imageView) {
                [self drawDashLine:imageView lineLength:3 lineSpacing:2 lineColor:BlueLeverColor1];
            }
        }
    }
}

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame)/2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
