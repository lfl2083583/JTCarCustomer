//
//  JTActivityDetailBottomView.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTActivityDetailBottomViewDelegate <NSObject>

- (void)joinActivityTeam;

- (void)commentActivity;

- (void)collectActivity;

- (void)forwardActivity;

@end

@interface JTActivityDetailBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (nonatomic, weak) id<JTActivityDetailBottomViewDelegate>delegate;

@end
