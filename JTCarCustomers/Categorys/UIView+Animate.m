//
//  UIView+Animation.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)showPop
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.10
                     animations:^{
                         // 第二步： 以动画的形式将view慢慢放大至原始大小的1.05倍
                         weakself.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.02, 1.02);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.05
                                          animations:^{
                                              // 第三步： 以动画的形式将view恢复至原始大小
                                              weakself.transform = CGAffineTransformIdentity;
                                          }];
                     }];
}

- (void)hidePop
{
    [self setHidden:YES];
}
@end
