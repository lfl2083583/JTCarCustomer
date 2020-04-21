//
//  JTAliasKeyboard.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTAliasKeyboard : UIView

@property (copy, nonatomic) void (^cancelBlock)(void);
@property (copy, nonatomic) void (^choiceBlock)(NSString *alias);

- (void)showInView:(UIView *)view choiceBlock:(void (^)(NSString *alias))choiceBlock;
- (void)hide;

@end
