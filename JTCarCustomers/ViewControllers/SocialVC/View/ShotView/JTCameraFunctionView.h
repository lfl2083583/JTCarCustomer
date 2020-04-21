//
//  JTCameraFunctionView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCameraFunctionDelegate.h"

@interface JTCameraFunctionView : UIView

/**
 *  设置进度条的录制视频时长百分比 = 当前录制时间 / 最大录制时间
 */
@property (nonatomic, assign) CGFloat maxRecorderDuration;

@property (nonatomic, weak) id<JTCameraFunctionDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCameraFunctionDelegate>)delegate maxRecorderDuration:(CGFloat)maxRecorderDuration;

@end
