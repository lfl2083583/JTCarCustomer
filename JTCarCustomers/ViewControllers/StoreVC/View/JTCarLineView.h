//
//  JTCarLineView.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTCarLineView;

@protocol JTCarLineViewDelegate <NSObject>

- (void)carLineView:(JTCarLineView *)carLineView didSelectAtSoucre:(NSDictionary *)source;

@end

@interface JTCarLineView : UIView

@property (weak, nonatomic) id<JTCarLineViewDelegate> delegate;
@property (copy, nonatomic) NSArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCarLineViewDelegate>)delegate;
- (void)showDataArray:(NSArray *)dataArray;
- (void)hide;
@end
