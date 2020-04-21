//
//  JTExpressionCollectioBottomView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTExpressionCollectioOperationType)
{
    JTExpressionCollectioOperationTypePreInduced,
    JTExpressionCollectioOperationTypeDelete,
};


@class JTExpressionCollectioBottomView;

@protocol JTExpressionCollectioBottomViewDelegate <NSObject>

- (void)expressionCollectioBottomView:(JTExpressionCollectioBottomView *)expressionCollectioBottomView expressionCollectioOperationType:(JTExpressionCollectioOperationType)expressionCollectioOperationType;

@end

@interface JTExpressionCollectioBottomView : UIView

@property (strong, nonatomic) UIButton *preInducedBT;
@property (strong, nonatomic) UIButton *deleteBT;
@property (weak, nonatomic) id<JTExpressionCollectioBottomViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<JTExpressionCollectioBottomViewDelegate>)delegate;
- (void)show;
- (void)hide;
@end
