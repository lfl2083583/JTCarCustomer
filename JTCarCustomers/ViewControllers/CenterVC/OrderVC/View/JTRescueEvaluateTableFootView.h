//
//  JTRescueEvaluateTableFootView.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTRescueEvaluateTableFootViewDelegate <NSObject>

@optional
- (void)evaluateTableFootViewCheckBoxIsSeleted:(BOOL)flag;

@end

@interface JTRescueEvaluateTableFootView : UIView

@property (nonatomic, weak) id<JTRescueEvaluateTableFootViewDelegate>delegate;

@end
