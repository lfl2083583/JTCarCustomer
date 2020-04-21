//
//  JTSpectrumView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSpectrumView.h"

@interface JTSpectrumView ()

@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) NSMutableArray *levels;
@property (nonatomic, strong) NSMutableArray *itemLineLayers;

@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) CGFloat lineWidth;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation JTSpectrumView

- (instancetype)initWithFrame:(CGRect)frame numberOfItems:(NSUInteger)numberOfItems itemColor:(UIColor *)itemColor textColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfItems = numberOfItems;
        _itemColor = itemColor;
        _textColor = textColor;
        [self setup];
    }
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self setLevel:-160];
        [self start];
    }
    else
    {
        [self setLevel:-160];
        [self stop];
    }
}

- (void)setup
{
    [self addSubview:self.timeLB];
    
    self.itemHeight = CGRectGetHeight(self.bounds);
    self.itemWidth = CGRectGetWidth(self.bounds);
    self.lineWidth = (self.itemWidth - self.timeLB.width) / 2.f / self.numberOfItems;
    
    for (int i = 0 ; i < self.numberOfItems / 2 ; i++) {
        [self.levels addObject:@(0)];
    }
    
    for (CAShapeLayer *itemLine in self.itemLineLayers) {
        [itemLine removeFromSuperlayer];
    }

    for (int i = 0; i < self.numberOfItems; i++) {
        CAShapeLayer *itemLine = [CAShapeLayer layer];
        itemLine.lineCap       = kCALineCapButt;
        itemLine.lineJoin      = kCALineJoinRound;
        itemLine.strokeColor   = [[UIColor clearColor] CGColor];
        itemLine.fillColor     = [[UIColor clearColor] CGColor];
        itemLine.strokeColor   = [self.itemColor CGColor];
        itemLine.lineWidth     = self.lineWidth;
        
        [self.layer addSublayer:itemLine];
        [self.itemLineLayers addObject:itemLine];
    }
}

- (void)updateItems {
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    int lineOffset = self.lineWidth * 2.f;
    
    int leftX = (self.itemWidth - self.timeLB.width + self.lineWidth) / 2.f;
    int rightX = (self.itemWidth + self.timeLB.width - self.lineWidth) / 2.f;
    
    for(int i = 0; i < self.numberOfItems / 2; i++) {
        
        CGFloat lineHeight = self.lineWidth + [self.levels[i] floatValue] * self.lineWidth / 2.f;
        CGFloat lineTop = (self.itemHeight - lineHeight) / 2.f;
        CGFloat lineBottom = (self.itemHeight + lineHeight) / 2.f;
        
        leftX -= lineOffset;
        
        UIBezierPath *linePathLeft = [UIBezierPath bezierPath];
        [linePathLeft moveToPoint:CGPointMake(leftX, lineTop)];
        [linePathLeft addLineToPoint:CGPointMake(leftX, lineBottom)];
        CAShapeLayer *itemLine2 = [self.itemLineLayers objectAtIndex:i + self.numberOfItems / 2];
        itemLine2.path = [linePathLeft CGPath];
        
        rightX += lineOffset;
        
        UIBezierPath *linePathRight = [UIBezierPath bezierPath];
        [linePathRight moveToPoint:CGPointMake(rightX, lineTop)];
        [linePathRight addLineToPoint:CGPointMake(rightX, lineBottom)];
        CAShapeLayer *itemLine = [self.itemLineLayers objectAtIndex:i];
        itemLine.path = [linePathRight CGPath];
    }
    
    UIGraphicsEndImageContext();
}

- (void)setLevel:(CGFloat)level
{
    if (level != 0) {
        _level = level;
        
        level = (level+37.5)*3.2;
        if (level < 0) level = 0;
        
        [self.levels removeObjectAtIndex:self.numberOfItems/2-1];
        [self.levels insertObject:@(level / 6.f) atIndex:0];
        
        [self updateItems];
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    _timeLB.text = [NSString stringWithFormat:@"0:%02d", (int)currentTime];
}

- (void)updateVoicePower
{
    if ([NIMSDK sharedSDK].mediaManager.isRecording) {
        self.level = [[NIMSDK sharedSDK].mediaManager recordAveragePower];
    }
}

- (UILabel *)timeLB
{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.textColor = self.textColor;
        _timeLB.font = Font(15);
        _timeLB.textAlignment = NSTextAlignmentCenter;
        _timeLB.frame = CGRectMake((self.width-60)/2, 0, 60, self.height);
    }
    return _timeLB;
}

- (NSMutableArray *)levels
{
    if (!_levels) {
        _levels = [NSMutableArray array];
    }
    return _levels;
}

- (NSMutableArray *)itemLineLayers
{
    if (!_itemLineLayers) {
        _itemLineLayers = [NSMutableArray array];
    }
    return _itemLineLayers;
}

- (void)start {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateVoicePower)];
        self.displayLink.frameInterval = 3.f;
    }
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [self.displayLink invalidate];
    [self setDisplayLink:nil];
}

@end
