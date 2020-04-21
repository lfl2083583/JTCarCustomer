//
//  JTCameraButton.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCameraButton.h"

// 默认按钮大小
#define CAMERABUTTONWIDTH 75
#define CAMERABUTTONHEIGHT 75

#define TOUCHVIEWWIDTH 55
#define TOUCHVIEWHEIGHT 55

// 录制时按钮的缩放比
#define SHOOTCAMERABUTTONSCALE 1.6f
#define SHOOTTOUCHVIEWSCALE 0.5f

// 录制按钮动画轨道宽度
#define PROGRESSLINEWIDTH 3

// 录制视频前的动画时间
#define START_VIDEO_ANIMATION_DURATION 0.3f

// 定时器记录视频间隔
#define TIMER_INTERVAL 0.01f

@interface JTCameraButton ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) double currentRecorderDuration;
@property (assign, nonatomic) CGFloat progressPercentage;

@property (strong, nonatomic) UIView *touchView;
@property (strong, nonatomic) CAShapeLayer *trackLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;

@end

@implementation JTCameraButton

#pragma mark - 点击事件与长按事件

- (instancetype)initWithDelegate:(id<JTCameraFunctionDelegate>)delegate maxRecorderDuration:(CGFloat)maxRecorderDuration
{
    self = [super init];
    if (self) {
        [self setSize:CGSizeMake(CAMERABUTTONWIDTH, CAMERABUTTONHEIGHT)];
        [self.layer setCornerRadius:CAMERABUTTONWIDTH/2];
        [self setBackgroundColor:BlackLeverColor1];
        [self setDelegate:delegate];
        [self setMaxRecorderDuration:maxRecorderDuration];
        [self setCurrentRecorderDuration:0];
        [self addSubview:self.touchView];
        [self initCircleAnimationLayer];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCameraButtonEvent:)]];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCameraButtonEvent:)]];
    }
    return self;
}

- (void)tapCameraButtonEvent:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(photograph)]) {
        [_delegate photograph];
    }
}

- (void)longPressCameraButtonEvent:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self longPressGestureRecognizerstart];
    }
    else if (longPressGestureRecognizer.state == UIGestureRecognizerStateCancelled ||
             longPressGestureRecognizer.state == UIGestureRecognizerStateEnded ||
             longPressGestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        [self longPressGestureRecognizerStop];
    }
}

/**
 开始长按
 */
- (void)longPressGestureRecognizerstart
{
    if (_delegate && [_delegate respondsToSelector:@selector(startVideoRecorder)]) {
        [_delegate startVideoRecorder];
        [self startShootAnimationWithDuration:START_VIDEO_ANIMATION_DURATION];
        
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_VIDEO_ANIMATION_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself startTime];
        });
    }
}

/**
 结束长按
 */
- (void)longPressGestureRecognizerStop
{
    if (_delegate && [_delegate respondsToSelector:@selector(stopVideoRecorder:)]) {
        [_delegate stopVideoRecorder:self.currentRecorderDuration];
        [self stopShootAnimation];
        [self stopTime];
    }
}

#pragma mark - 录制视频按钮动画

// 初始化按钮路径
- (void)initCircleAnimationLayer
{
    float centerX = self.bounds.size.width / 2.0;
    float centerY = self.bounds.size.height / 2.0;
    //半径
    float radius = (self.bounds.size.width - PROGRESSLINEWIDTH) / 2.0;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f * M_PI) endAngle:(1.5f * M_PI) clockwise:YES];
    
    //添加背景圆环
    CAShapeLayer *_backLayer = [CAShapeLayer layer];
    _backLayer.frame = self.bounds;
    _backLayer.fillColor =  [[UIColor clearColor] CGColor];
    _backLayer.strokeColor  = WhiteColor.CGColor;
    _backLayer.lineWidth = PROGRESSLINEWIDTH;
    _backLayer.path = [path CGPath];
    _backLayer.strokeEnd = 1;
    [self.layer addSublayer:_backLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapSquare;//kCALineCapRound;
    _progressLayer.lineWidth = PROGRESSLINEWIDTH;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //设置渐变颜色
    CAGradientLayer *_gradientLayer =  [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[BlueLeverColor2 CGColor], (id)[BlueLeverColor1 CGColor],  nil]];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [_gradientLayer setMask:_progressLayer];     //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
}

// 设置按钮百分比
- (void)setProgressPercentage:(CGFloat)progressPercentage
{
    _progressPercentage = progressPercentage;
    _progressLayer.strokeEnd = progressPercentage;
    [_progressLayer removeAllAnimations];
}

/**
 开始计时
 */
- (void)startTime
{
    [self stopTime];
    self.currentRecorderDuration = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)updateTime
{
    if (self.currentRecorderDuration > self.maxRecorderDuration) {
        [self longPressGestureRecognizerStop];
    }
    self.currentRecorderDuration += TIMER_INTERVAL;
    self.progressPercentage = self.currentRecorderDuration/self.maxRecorderDuration;
}

/**
 结束计时
 */
- (void)stopTime
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        [self setTimer:nil];
    }
    self.progressPercentage = 0.0;
}

/**
 *  开始录制前的准备动画
 */
- (void)startShootAnimationWithDuration:(NSTimeInterval)duration
{
    __weak typeof(self) weakself = self;
    
    [UIView animateWithDuration:duration animations:^{
        
        weakself.transform = CGAffineTransformMakeScale(SHOOTCAMERABUTTONSCALE, SHOOTCAMERABUTTONSCALE);
        weakself.touchView.transform = CGAffineTransformMakeScale(SHOOTTOUCHVIEWSCALE, SHOOTTOUCHVIEWSCALE);
        
    } completion:^(BOOL finished) {
    }];
}

/**
 *  结束摄影动画
 */
- (void)stopShootAnimation
{
    self.transform = CGAffineTransformIdentity;
    self.touchView.transform = CGAffineTransformIdentity;
}

- (UIView *)touchView
{
    if (!_touchView) {
        _touchView = [[UIView alloc] init];
        _touchView.size = CGSizeMake(TOUCHVIEWWIDTH, TOUCHVIEWHEIGHT);
        _touchView.center = self.center;
        _touchView.layer.cornerRadius = TOUCHVIEWWIDTH/2;
        _touchView.layer.backgroundColor = WhiteColor.CGColor;
    }
    return _touchView;
}

- (void)dealloc
{
    [self stopTime];
}

@end
