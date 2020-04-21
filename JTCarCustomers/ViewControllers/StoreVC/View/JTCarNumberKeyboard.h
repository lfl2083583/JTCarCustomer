//
//  JTCarNumberKeyboard.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTCarNumberKeyboard;

@protocol JTCarNumberKeyboardDelegate <NSObject>

- (void)carNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard didChangeText:(NSString *)text;
- (void)cancelInCarNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard;
@end

@interface JTCarNumberKeyboard : UIView

@property (strong, nonatomic) NSMutableString *text;
@property (weak, nonatomic) id<JTCarNumberKeyboardDelegate> delegate;

@end
