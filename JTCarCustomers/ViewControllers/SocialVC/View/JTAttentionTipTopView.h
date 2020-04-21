//
//  JTAttentionTipTopView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTAttentionTipTopViewDelegate <NSObject>

- (void)attentionTipTopViewToCancel:(id)attentionTipTopView;
- (void)attentionTipTopViewToAttention:(id)attentionTipTopView;

@end

@interface JTAttentionTipTopView : UIView

@property (copy, nonatomic) NSString *prompt;
@property (weak, nonatomic) id<JTAttentionTipTopViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTAttentionTipTopViewDelegate>)delegate;
@end
