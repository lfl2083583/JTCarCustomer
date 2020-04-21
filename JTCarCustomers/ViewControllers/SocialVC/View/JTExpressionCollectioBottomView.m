//
//  JTExpressionCollectioBottomView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionCollectioBottomView.h"

@implementation JTExpressionCollectioBottomView

- (instancetype)initWithDelegate:(id<JTExpressionCollectioBottomViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        [self setFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, kBottomBarHeight)];
        [self addSubview:self.preInducedBT];
        [self addSubview:self.deleteBT];
    }
    return self;
}

- (void)show
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.top = APP_Frame_Height-weakself.height;
    } completion:nil];
}

- (void)hide
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.top = APP_Frame_Height;
    } completion:nil];
}

- (UIButton *)preInducedBT
{
    if (!_preInducedBT) {
        _preInducedBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preInducedBT setTitle:@"移动最前" forState:UIControlStateNormal];
        [_preInducedBT setTitleColor:BlackLeverColor6 forState:UIControlStateNormal];
        [_preInducedBT.titleLabel setFont:Font(16)];
        [_preInducedBT addTarget:self action:@selector(preInduceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_preInducedBT setFrame:CGRectMake(16, 0, 150, 49)];
        [_preInducedBT setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _preInducedBT;
}

- (UIButton *)deleteBT
{
    if (!_deleteBT) {
        _deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBT setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBT setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_deleteBT.titleLabel setFont:Font(16)];
        [_deleteBT addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBT setFrame:CGRectMake(self.width-165, 0, 150, 49)];
        [_deleteBT setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _deleteBT;
}

- (void)preInduceClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(expressionCollectioBottomView:expressionCollectioOperationType:)]) {
        [_delegate expressionCollectioBottomView:self expressionCollectioOperationType:JTExpressionCollectioOperationTypePreInduced];
    }
}

- (void)deleteClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(expressionCollectioBottomView:expressionCollectioOperationType:)]) {
        [_delegate expressionCollectioBottomView:self expressionCollectioOperationType:JTExpressionCollectioOperationTypeDelete];
    }
}

@end
