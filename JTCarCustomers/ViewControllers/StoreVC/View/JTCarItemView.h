//
//  JTCarItemView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTCarItemView;

@protocol JTCarItemViewDelegate <NSObject>

- (void)carItemView:(JTCarItemView *)carItemView carOperationType:(JTCarOperationType)carOperationType;

@end

@interface JTCarItemView : UIView

@property (weak, nonatomic) id<JTCarItemViewDelegate> delegate;
@property (copy, nonatomic) JTCarModel *model;
@property (assign, nonatomic) BOOL isHideSubView;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCarItemViewDelegate>)delegate;

@end
