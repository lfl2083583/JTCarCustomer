//
//  JTInputVoiceContainerView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputVoiceContainerView.h"
#import "JTRecordFunctionView.h"
#import <AVFoundation/AVFoundation.h>
#import "JTInputGlobal.h"

@interface JTInputVoiceContainerView () <JTRecordFunctionDelegate, NIMMediaManagerDelegate>

@property (strong, nonatomic) JTRecordFunctionView *recordFunctionView;

@end

@implementation JTInputVoiceContainerView

- (void)dealloc
{
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputActionDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _inputConfig = config;
        _delegate = delegate;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
}

- (void)setup
{
    [self addSubview:self.recordFunctionView];
}

#pragma mark - JTRecordFunctionDelegate
- (void)recordFunctionView:(JTRecordFunctionView *)recordFunctionView changeState:(JTAudioRecordState)state
{
    switch (state) {
        case JTAudioRecordStateNone:
        {
            [[NIMSDK sharedSDK].mediaManager stopRecord];
        }
            break;
        case JTAudioRecordStateRecording:
        {
            NIMAudioType type = NIMAudioTypeAAC;
            if ([self.inputConfig respondsToSelector:@selector(recordType)])
            {
                type = [self.inputConfig recordType];
            }
            [[[NIMSDK sharedSDK] mediaManager] addDelegate:self];
            [[[NIMSDK sharedSDK] mediaManager] record:type duration:10];
        }
            break;
        case JTAudioRecordStateCanceling:
        {
            [[NIMSDK sharedSDK].mediaManager cancelRecord];
        }
            break;
        case JTAudioRecordStateEnd:
        {
            [[NIMSDK sharedSDK].mediaManager stopRecord];
        }
            break;
        default:
            break;
    }
}

#pragma mark - NIMMediaManagerDelegate
- (void)recordAudio:(nullable NSString *)filePath didCompletedWithError:(nullable NSError *)error
{
    if (!error) {
        if ([self recordFileCanBeSend:filePath]) {
            if (_delegate && [_delegate respondsToSelector:@selector(onSendAudioPath:)]) {
                [_delegate onSendAudioPath:filePath];
                [self.recordFunctionView endRecordingStateUI];
            }
        } else {
            [[HUDTool shareHUDTool] showHint:@"录音时间太短"];
        }
    } else {
        [[HUDTool shareHUDTool] showHint:@"录音失败"];
    }
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime
{
    [self.recordFunctionView.spectrumView setCurrentTime:currentTime];
}

- (void)recordAudioInterruptionBegin
{
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (void)recordAudioInterruptionEnd
{
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 1;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, input_containerHeight);
}

- (JTRecordFunctionView *)recordFunctionView
{
    if (!_recordFunctionView) {
        _recordFunctionView = [[JTRecordFunctionView alloc] initWithFrame:self.bounds delegate:self];
    }
    return _recordFunctionView;
}

@end
