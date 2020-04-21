//
//  JTRecordFunctionView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTSpectrumView.h"

@class JTRecordFunctionView;

typedef NS_ENUM(NSInteger, JTAudioRecordState) {
    JTAudioRecordStateNone,           // 无状态
    JTAudioRecordStateRecording,      // 录音中
    JTAudioRecordStateCanceling,      // 取消录音
    JTAudioRecordStateEnd             // 录音结束
};

@protocol JTRecordFunctionDelegate <NSObject>

@optional

- (void)recordFunctionView:(JTRecordFunctionView *)recordFunctionView changeState:(JTAudioRecordState)state;

@end

@interface JTRecordFunctionView : UIView

@property (strong, nonatomic) JTSpectrumView *spectrumView;
@property (strong, nonatomic) UILabel *promptLB;
@property (strong, nonatomic) UIImageView *recordIV;
@property (strong, nonatomic) UIImageView *cancelIV;

@property (weak, nonatomic) id<JTRecordFunctionDelegate> delegate;
@property (assign, nonatomic) JTAudioRecordState state;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTRecordFunctionDelegate>)delegate;
//将要进入录音状态
- (void)willRecordingStateUI;
//进入录音状态
- (void)didRecordingStateUI;
//取消录音状态
- (void)cancelRecordingStateUI;
//结束录制状态
- (void)endRecordingStateUI;
@end
