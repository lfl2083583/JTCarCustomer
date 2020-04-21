//
//  JTCameraButton.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCameraFunctionDelegate.h"

@interface JTCameraButton : UIView

/**
 *  设置进度条的录制视频时长百分比 = 当前录制时间 / 最大录制时间
 */
@property (nonatomic, assign) CGFloat maxRecorderDuration;

@property (nonatomic, weak) id<JTCameraFunctionDelegate> delegate;

- (instancetype)initWithDelegate:(id<JTCameraFunctionDelegate>)delegate maxRecorderDuration:(CGFloat)maxRecorderDuration;

/**
 *  开始录制前的准备动画
 */
- (void)startShootAnimationWithDuration:(NSTimeInterval)duration;

/**
 *  结束摄影动画
 */
- (void)stopShootAnimation;


@end
