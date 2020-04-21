//
//  JTVoiceWaveView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTVoiceWaveView.h"

@interface JTVoiceWaveView ()


@end

@implementation JTVoiceWaveView

{
    UIView *_bottomView;
    CALayer *_maskLayer;
}

- (void)dealloc {
    [_maskLayer removeAllAnimations];
    [_maskLayer removeFromSuperlayer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubview];
    }
    return self;
}

- (void)setDuration:(CGFloat)duration {
    _duration = duration;
}

- (void)configSubview {
    
    UIImage *image2 = [UIImage imageNamed:@"icon_audio_gray"];
    _bottomView = [[UIView alloc] init];
    [self addSubview:_bottomView];
    _bottomView.frame = CGRectMake(0, 0, 72, 25);
    _bottomView.backgroundColor = [UIColor colorWithPatternImage:image2];
}

- (void)startAnimation {
    
    [_maskLayer removeAllAnimations];
    [_maskLayer removeFromSuperlayer];
    
    UIImage *image3 = [UIImage imageNamed:@"icon_audio_blue"];
    _maskLayer = [CALayer new];
    _maskLayer.frame = CGRectMake(0, 0, 0, 0);
    _maskLayer.backgroundColor = [UIColor colorWithPatternImage:image3].CGColor;
    
    [_bottomView.layer addSublayer:_maskLayer];
    
    //CABasicAnimation进行实例化并指定Layer的属性作为关键路径进行注册
    CABasicAnimation *widthAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    //所改变属性的起始值
    widthAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 25)];
    //所改变属性的结束时的值
    widthAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0 ,0, self.bounds.size.width, 25)];
    
    //CABasicAnimation进行实例化并指定Layer的属性作为关键路径进行注册
    CABasicAnimation *aniAnchorPoint = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    //所改变属性的起始值
    aniAnchorPoint.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    //所改变属性的结束时的值
    aniAnchorPoint.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    //创建组合动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[widthAnimation, aniAnchorPoint];
    group.duration = self.duration;
    //设置动画的执行次数
    group.repeatCount = 0;
    //添加组合动画
    [_maskLayer addAnimation:group forKey:@"coverScroll"];
}

//暂停动画
- (void)pauseAnimation {
    //（0-5）
    //开始时间：0
    //    myView.layer.beginTime
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [_maskLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    _maskLayer.timeOffset = pauseTime;
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    _maskLayer.speed = 0;
    
}

//恢复动画
- (void)resumeAnimation {
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = _maskLayer.timeOffset;
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    [_maskLayer setTimeOffset:0];
    [_maskLayer setBeginTime:begin];
    _maskLayer.speed = 1;
}

- (void)stopAnimation {
    [_maskLayer removeAllAnimations];
    [_maskLayer removeFromSuperlayer];
}

@end
