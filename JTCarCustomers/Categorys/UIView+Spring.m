//
//  UIView+Spring.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "UIView+Spring.h"

@implementation UIView (Spring)

- (void)presentView:(UIView *_Nonnull)viewToPresent animated:(BOOL)flag completion:(void (^ _Nullable)(void))completion
{
    [self addSubview:viewToPresent];
    if (flag) {
        UIView *subview = [viewToPresent.subviews firstObject];
        if (subview) {
            [UIView animateWithDuration:0.10
                             animations:^{
                                 // 第二步： 以动画的形式将view慢慢放大至原始大小的1.05倍
                                 subview.transform =
                                 CGAffineTransformScale(CGAffineTransformIdentity, 1.02, 1.02);
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.05
                                                  animations:^{
                                                      // 第三步： 以动画的形式将view恢复至原始大小
                                                      subview.transform = CGAffineTransformIdentity;
                                                      if (completion) {
                                                          completion();
                                                      }
                                                  }];
                             }];
        }
    }
    else
    {
        if (completion) {
            completion();
        }
    }
}

- (void)dismissViewAnimated:(BOOL)flag completion:(void (^ _Nullable)(void))completion
{
    [self setHidden:YES];
    [self removeFromSuperview];
    if (completion) {
        completion();
    }
}

- (void)pushView:(UIView *_Nullable)view animated:(BOOL)animated
{
    view.center = CGPointMake(self.centerX+App_Frame_Width, self.centerY);
    [self.superview addSubview:view];
    if (animated) {
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.15
                         animations:^{
                             view.centerX -= App_Frame_Width;
                             weakself.centerX -= App_Frame_Width;
                         }];
    }
    else
    {
        view.centerX -= App_Frame_Width;
        self.centerX -= App_Frame_Width;
    }
}
@end
