//
//  JTActivityCardView.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionUp,
    UIPanGestureRecognizerDirectionDown,
    UIPanGestureRecognizerDirectionLeft,
    UIPanGestureRecognizerDirectionRight
};


#import <UIKit/UIKit.h>

@protocol JTActivityCardViewDelegate <NSObject>

- (void)cardView:(UIView *)cardView topCardClick:(id)cardInfo;

- (void)cardViewSwipeTopIndex:(NSInteger)index;

- (void)cardViewSwipeBeginRefreshData;

@end

@interface JTActivityCardView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id<JTActivityCardViewDelegate>delegate;

- (void)reloadData;

@end
