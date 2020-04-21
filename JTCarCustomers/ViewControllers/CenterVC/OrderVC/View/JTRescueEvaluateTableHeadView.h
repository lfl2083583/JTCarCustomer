//
//  JTRescueEvaluateTableHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTRescueEvaluateTableHeadViewDelegate <NSObject>

@optional
- (void)evaluateBtnClick:(NSInteger)flag;

@end

@interface JTRescueEvaluateTableHeadView : UIView

@property (nonatomic, weak) id <JTRescueEvaluateTableHeadViewDelegate>delegate;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *titleLB;

@property (nonatomic, copy) NSString *str1;

@end
