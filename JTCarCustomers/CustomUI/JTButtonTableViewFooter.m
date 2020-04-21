//
//  JTButtonTableViewFooter.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTButtonTableViewFooter.h"

@implementation JTButtonTableViewFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSInteger leftSpace = 35;   // 左边间隙
    NSInteger rightSpace = 35;  // 右边间隙
    NSInteger topSpace = 30;    // 上边间隙
    NSInteger bottomSpace = 30; // 下边间隙
    NSInteger space = 20;       // 间隙
    
    CGFloat left = leftSpace, top = topSpace;
    CGFloat height = 45;
    CGFloat width = (App_Frame_Width - leftSpace - rightSpace - (self.column - 1) * space) / self.column;
    for (UIButton *button in self.buttons) {
        [button setFrame:CGRectMake(left, top, width, height)];
        [self addSubview:button];
        left = CGRectGetMaxX(button.frame) + space;
        if ((left + width) > App_Frame_Width) {
            left = leftSpace;
            top = CGRectGetMaxY(button.frame) + space;
        }
    }
    CGFloat maxHeight = CGRectGetMaxY([[self.buttons lastObject] frame]) + bottomSpace;
    self.frame = CGRectMake(0, 0, App_Frame_Width, maxHeight);
}

@end
