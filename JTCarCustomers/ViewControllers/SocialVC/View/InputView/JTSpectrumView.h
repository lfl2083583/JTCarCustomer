//
//  JTSpectrumView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTSpectrumView : UIView

@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, copy) UIColor *itemColor;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic, assign) CGFloat level;
@property (nonatomic, assign) NSTimeInterval currentTime;

- (instancetype)initWithFrame:(CGRect)frame numberOfItems:(NSUInteger)numberOfItems itemColor:(UIColor *)itemColor textColor:(UIColor *)textColor;

@end
