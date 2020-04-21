//
//  UIView+Spring.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Spring)

- (void)presentView:(UIView *_Nonnull)viewToPresent animated:(BOOL)flag completion:(void (^_Nullable)(void))completion;
- (void)dismissViewAnimated:(BOOL)flag completion:(void (^_Nullable)(void))completion;
- (void)pushView:(UIView *_Nullable)view animated:(BOOL)animated;

@end
