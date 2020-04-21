//
//  JTBaseSpringView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Spring.h"

@interface JTSpringRootView : UIView

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *closeBT;

@end

@interface JTBaseSpringView : UIView

@property (strong, nonatomic) JTSpringRootView *rootView;

- (instancetype)initWithContentView:(UIView *)contentView;

@end
