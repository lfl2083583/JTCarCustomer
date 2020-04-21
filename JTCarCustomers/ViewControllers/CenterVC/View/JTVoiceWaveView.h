//
//  JTVoiceWaveView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTVoiceWaveView : UIView

/**
 动画时间
 */
@property (nonatomic, assign) CGFloat duration;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)startAnimation;

- (void)stopAnimation;

- (void)pauseAnimation;

- (void)resumeAnimation;

@end
