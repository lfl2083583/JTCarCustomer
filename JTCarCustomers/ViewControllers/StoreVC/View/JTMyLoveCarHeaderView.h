//
//  JTMyLoveCarHeaderView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTMyLoveCarHeaderView;

@protocol JTMyLoveCarHeaderViewDelegate <NSObject>

- (void)myLoveCarHeaderView:(JTMyLoveCarHeaderView *)myLoveCarHeaderView didScrollToIndex:(NSInteger)currentIndex;

@end

@interface JTMyLoveCarHeaderView : UIView

@property (weak, nonatomic) id<JTMyLoveCarHeaderViewDelegate> delegate;

- (instancetype)initWithMyDelegate:(id<JTMyLoveCarHeaderViewDelegate>)delegate;

- (void)reloadData:(NSArray *)dataArray scrollToIndex:(NSInteger)index;
@end
