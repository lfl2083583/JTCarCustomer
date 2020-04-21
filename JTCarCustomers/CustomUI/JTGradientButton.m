//
//  JTGradientButton.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTGradientButton.h"

@implementation JTGradientButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cornerRadius = -1;
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    JTGradientButton *button = [super buttonWithType:buttonType];
    button.cornerRadius = -1;
    return button;
}

- (void)drawRect:(CGRect)rect {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)BlueLeverColor2.CGColor, (__bridge id)BlueLeverColor1.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    gradientLayer.cornerRadius = (self.cornerRadius == -1) ? (self.bounds.size.height/2) : self.cornerRadius;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
