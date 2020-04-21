//
//  ZTStarView.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTStarView.h"

@interface ZTStarView ()

@property (nonatomic, readwrite) int numberOfStar;
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation ZTStarView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStar:kStarNumber];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNumberOfStar:kStarNumber];
    [self commonInit];
}

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number {
    self = [super initWithFrame:frame];
    if (self) {
        self.starImageNormal = kStarImageNormal;
        self.starImageHighlight = kStarImageHighlight;
        _numberOfStar = number;
    }
    return self;
}

- (UIView *)starBackgroundView
{
    if (!_starBackgroundView) {
        _starBackgroundView = [self buidlStarViewWithImageName:self.starImageNormal];
    }
    return _starBackgroundView;
}

- (UIView *)starForegroundView
{
    if (!_starForegroundView) {
        _starForegroundView = [self buidlStarViewWithImageName:self.starImageHighlight];
    }
    return _starForegroundView;
}

- (void)didMoveToWindow
{
    if (self.window) {
        [self commonInit];
    }
}

- (void)commonInit {
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate {
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0) {
        score = 0;
    }
    if (score > 1) {
        score = 1;
    }
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate){
        [UIView animateWithDuration:0.2 animations:^{
            [self changeStarForegroundViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion){
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Touche Event

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point)) {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [UIView animateWithDuration:0.2 animations:^{
        [self changeStarForegroundViewWithPoint:point];
    }];
}

#pragma mark - Buidl Star View

/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName {
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat space = (frame.size.width - image.size.width * kStarNumber) / 4;
    for (int i = 0; i < self.numberOfStar; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * (image.size.width + space), (frame.size.height - image.size.height) / 2, image.size.width, image.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point{
    CGPoint p = point;
    
    if (p.x < 0) {
        p.x = 0;
    }
    if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starView: score:)]) {
        [self.delegate starView:self score:score];
    }
}

@end
