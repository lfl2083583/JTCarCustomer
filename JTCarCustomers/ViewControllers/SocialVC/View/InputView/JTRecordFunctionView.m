//
//  JTRecordFunctionView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTRecordFunctionView.h"
#import "UIImage+Chat.h"

@interface JTRecordFunctionView ()

@end

@implementation JTRecordFunctionView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTRecordFunctionDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:delegate];
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.spectrumView];
    [self.spectrumView setHidden:YES];
    [self addSubview:self.promptLB];
    [self.promptLB setText:@"按住说话"];
    [self addSubview:self.recordIV];
    [self addSubview:self.cancelIV];
    [self.cancelIV setHidden:YES];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCameraButtonEvent:)];
    longPress.minimumPressDuration = 0.1f;
    [self addGestureRecognizer:longPress];
}

- (void)longPressCameraButtonEvent:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    CGPoint point = [longPressGestureRecognizer locationInView:self];
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(self.recordIV.frame, point) && self.state != JTAudioRecordStateRecording) {
            [self setState:JTAudioRecordStateRecording];
            [self willRecordingStateUI];
        }
    }
    else if (longPressGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if ([NIMSDK sharedSDK].mediaManager.isRecording) {
            if (CGRectContainsPoint(self.cancelIV.frame, point) && self.state == JTAudioRecordStateRecording) {
                [self cancelRecordingStateUI];
            }
            else
            {
                [self didRecordingStateUI];
            }
        }
    }
    else if (longPressGestureRecognizer.state == UIGestureRecognizerStateCancelled ||
             longPressGestureRecognizer.state == UIGestureRecognizerStateEnded ||
             longPressGestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        if (CGRectContainsPoint(self.cancelIV.frame, point) && self.state == JTAudioRecordStateRecording) {
            self.state = JTAudioRecordStateCanceling;
        }
        else
        {
            self.state = JTAudioRecordStateEnd;
        }
        [self endRecordingStateUI];
    }
}

- (void)willRecordingStateUI
{
    self.spectrumView.hidden = NO;
    self.spectrumView.currentTime = 0;
    self.promptLB.hidden = YES;
    self.recordIV.image = [UIImage jt_imageInKit:@"icon_voice_selected"];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.15 animations:^{
        weakself.recordIV.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.15 animations:^{
                weakself.recordIV.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }
    }];
    self.cancelIV.hidden = NO;
}

- (void)didRecordingStateUI
{
    CGPoint cancelCenter = self.cancelIV.center;
    self.spectrumView.hidden = NO;
    self.promptLB.hidden = YES;
    self.promptLB.text = @"按住说话";
    self.cancelIV.image = [UIImage jt_imageInKit:@"icon_delete_normal"];
    self.cancelIV.size = CGSizeMake(50, 50);
    self.cancelIV.center = cancelCenter;
    self.cancelIV.hidden = NO;
}

- (void)cancelRecordingStateUI
{
    CGPoint cancelCenter = self.cancelIV.center;
    self.spectrumView.hidden = YES;
    self.promptLB.hidden = NO;
    self.promptLB.text = @"松手取消发送";
    self.cancelIV.image = [UIImage jt_imageInKit:@"icon_delete_selected"];
    self.cancelIV.size = CGSizeMake(60, 60);
    self.cancelIV.center = cancelCenter;
    self.cancelIV.hidden = NO;
}

- (void)endRecordingStateUI
{
    self.spectrumView.hidden = YES;
    self.spectrumView.currentTime = 0;
    self.promptLB.hidden = NO;
    self.promptLB.text = @"按住说话";
    self.recordIV.image = [UIImage jt_imageInKit:@"icon_voice_normal"];
    CGPoint cancelCenter = self.cancelIV.center;
    self.cancelIV.image = [UIImage jt_imageInKit:@"icon_delete_normal"];
    self.cancelIV.size = CGSizeMake(50, 50);
    self.cancelIV.center = cancelCenter;
    self.cancelIV.hidden = YES;
}

- (void)setState:(JTAudioRecordState)state
{
    if (_state != state) {
        _state = state;
        if (_delegate && [_delegate respondsToSelector:@selector(recordFunctionView:changeState:)]) {
            [_delegate recordFunctionView:self changeState:state];
        }
    }
}

- (JTSpectrumView *)spectrumView
{
    if (!_spectrumView) {
        _spectrumView = [[JTSpectrumView alloc] initWithFrame:CGRectMake((self.width-140)/2, 20, 140, 30) numberOfItems:20 itemColor:BlueLeverColor1 textColor:BlackLeverColor3];
        _spectrumView.level = 0;
        _spectrumView.currentTime = 0;
    }
    return _spectrumView;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] initWithFrame:self.spectrumView.frame];
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.font = Font(15);
        _promptLB.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLB;
}

- (UIImageView *)recordIV
{
    if (!_recordIV) {
        _recordIV = [[UIImageView alloc] init];
        _recordIV.image = [UIImage jt_imageInKit:@"icon_voice_normal"];
        _recordIV.size = CGSizeMake(110, 110);
        _recordIV.center = self.center;
    }
    return _recordIV;
}

- (UIImageView *)cancelIV
{
    if (!_cancelIV) {
        _cancelIV = [[UIImageView alloc] init];
        _cancelIV.image = [UIImage jt_imageInKit:@"icon_delete_normal"];
        _cancelIV.size = CGSizeMake(50, 50);
        _cancelIV.center = CGPointMake(self.width*5/6, self.height/4);
    }
    return _cancelIV;
}

@end
