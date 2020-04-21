//
//  JTCameraFunctionDelegate.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JTCameraFunctionDelegate <NSObject>

@optional

- (void)closeCamera;

- (void)flashCamera;

- (void)modeCamera;

/**
 拍照
 */
- (void)photograph;

/**
 录制视频开始
 */
- (void)startVideoRecorder;

/**
 录制视频结束
 */
- (void)stopVideoRecorder:(CGFloat)recorderDuration;

@end
