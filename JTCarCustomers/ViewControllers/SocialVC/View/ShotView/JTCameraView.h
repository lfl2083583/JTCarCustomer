//
//  JTCameraView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTCameraView : UIView

@property (assign, nonatomic) CGFloat minDuration;
@property (assign, nonatomic) CGFloat maxDuration;

- (instancetype)initWithFrame:(CGRect)frame minDuration:(CGFloat)minDuration maxDuration:(CGFloat)maxDuration;

/**
 开始预览
 */
- (void)startPreview;

/**
 停止预览
 */
- (void)stopPreview;

/**
 摄像头闪光
 */
- (void)flashCamera;

/**
 摄像头翻转
 */
- (void)modeCamera;

/**
 拍照

 @param completionImageHandler handler description
 */
- (void)photographWithCompletionImageHandler:(void (^)(UIImage *image))completionImageHandler;

/**
 开始录制
 */
- (void)startVideoRecorder;

/**
 停止录制

 @param recorderDuration 录制时间
 @param completionVideoHandler completionHandler description
 */
- (void)stopVideoRecorder:(CGFloat)recorderDuration completionVideoHandler:(void (^)(NSString *outPath))completionVideoHandler;
@end
