//
//  JTActivityCardView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define Card_Inset_Margin 10
#define BottomCardInsetVerticalMargin 10
#define BottomCardInsetHorizontalMargin 15
#define Randio 820/620.0
#import "JTActivityCardView.h"

@interface JTActivityCardView () <UIGestureRecognizerDelegate>
{
    CGFloat originalX;
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tap;
}
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) UIPanGestureRecognizerDirection guesterDirection;
@property (nonatomic, strong) NSArray *colorsArray;
@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) NSMutableArray *originalArray;
@property (nonatomic, assign) UIEdgeInsets topCardInset;
@property (nonatomic, assign) CGFloat cardLeftMargin;
@property (nonatomic, assign) CGFloat cardRightMargin;
@property (nonatomic, assign) CGFloat cardTopMargin;
@property (nonatomic, assign) CGFloat cardBottomMargin;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isAnimationing;

@end

@implementation JTActivityCardView

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = RGBCOLOR(219, 219, 219, 1);
    }
    return _maskView;
}

- (void)setTopCardInset:(UIEdgeInsets)topCardInset {
    _topCardInset = topCardInset;
    _cardLeftMargin = topCardInset.left;
    _cardRightMargin = topCardInset.right;
    _cardTopMargin = topCardInset.top;
    _cardBottomMargin = topCardInset.bottom;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topCardInset = UIEdgeInsetsMake(10, 20, 20+kBottomBarHeight, 20);
        [self setupViews];
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

- (void)reloadData {
    UIImageView *imageView = self.viewsArray[0];
    NSDictionary *source = self.dataArray[self.page];
    CGRect rect = [self.originalArray[0] CGRectValue];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[source[@"image"] avatarHandleWithSize:CGSizeMake(rect.size.width*3, rect.size.height*3)]]];
}

- (void)setupViews {
    CGFloat width1 = self.width-BottomCardInsetHorizontalMargin*2-_cardLeftMargin-_cardRightMargin;
    CGRect rect1 = CGRectMake(_cardLeftMargin, _cardTopMargin, width1, Randio*width1);
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:rect1];
    imageView1.backgroundColor = RGBCOLOR(219, 219, 219, 1);
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    
    CGFloat width2 = CGRectGetWidth(imageView1.frame)-2*BottomCardInsetHorizontalMargin;
    CGRect rect2 = CGRectMake(CGRectGetMaxX(imageView1.frame)+BottomCardInsetHorizontalMargin-width2, CGRectGetMinY(imageView1.frame)+BottomCardInsetVerticalMargin, width2, CGRectGetHeight(imageView1.frame)-2*BottomCardInsetVerticalMargin);
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:rect2];
    imageView2.backgroundColor = RGBCOLOR(219, 219, 219, 0.8);
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    
    CGFloat width3 = CGRectGetWidth(imageView2.frame)-2*BottomCardInsetHorizontalMargin;
    CGRect rect3 = CGRectMake(CGRectGetMaxX(imageView2.frame)+BottomCardInsetHorizontalMargin-width3, CGRectGetMinY(imageView2.frame)+BottomCardInsetVerticalMargin, width3, CGRectGetHeight(imageView2.frame)-2*BottomCardInsetVerticalMargin);
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:rect3];
    imageView3.backgroundColor = RGBCOLOR(219, 219, 219, 0.6);
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.clipsToBounds = YES;
    
    CGRect rect4 = CGRectMake(-CGRectGetWidth(imageView1.frame), _cardTopMargin, CGRectGetWidth(imageView1.frame), CGRectGetHeight(imageView1.frame));
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:rect4];
    imageView4.backgroundColor = RGBCOLOR(219, 219, 219, 0.4);
    imageView4.contentMode = UIViewContentModeScaleAspectFill;
    imageView4.clipsToBounds = YES;
    
    [self addSubview:imageView4];
    [self addSubview:imageView3];
    [self addSubview:imageView2];
    [self addSubview:imageView1];
    
    NSValue *value1 = [NSValue valueWithCGRect:rect1];
    NSValue *value2 = [NSValue valueWithCGRect:rect2];
    NSValue *value3 = [NSValue valueWithCGRect:rect3];
    NSValue *value4 = [NSValue valueWithCGRect:rect4];
    
    originalX = -CGRectGetWidth(imageView1.frame);
    _viewsArray = [NSMutableArray arrayWithArray:@[imageView1, imageView2, imageView3, imageView4]];
    _originalArray = [NSMutableArray arrayWithArray:@[value1, value2, value3, value4]];
    _colorsArray = @[RGBCOLOR(219, 219, 219, 1),
                     RGBCOLOR(219, 219, 219, 0.8),
                     RGBCOLOR(219, 219, 219, 0.6),
                     RGBCOLOR(219, 219, 219, 0.4)];
}

#pragma mark  UITouch | UIPanGestureRecognizer
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = [_originalArray[0] CGRectValue];
    if (touch.tapCount == 1 && CGRectContainsPoint(rect, point) && self.dataArray && self.dataArray.count) {
        UIImageView *imageView = self.viewsArray[0];
        if (_delegate && [_delegate respondsToSelector:@selector(cardView:topCardClick:)]) {
            [_delegate cardView:imageView topCardClick:self.dataArray[self.page]];
        }
    }
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recognizer {

    if (self.isAnimationing) {
        return;
    }
    CGPoint tranPoint=[recognizer translationInView:self];
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (direction == UIPanGestureRecognizerDirectionUndefined)
            {
                CGPoint velocity = [recognizer velocityInView:self];
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                else
                {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                        if (self.page > 0) {
                            UIImageView *imageView1 = self.viewsArray[0];
                            UIImageView *imageView4 = self.viewsArray[3];
                            self.maskView.frame = imageView1.frame;
                            [self bringSubviewToFront:imageView4];
                            [self insertSubview:self.maskView aboveSubview:imageView1];
                            NSDictionary *source = self.dataArray[self.page-1];
                            CGRect rect = [self.originalArray[0] CGRectValue];
                            [imageView4 sd_setImageWithURL:[NSURL URLWithString:[source[@"image"] avatarHandleWithSize:CGSizeMake(rect.size.width*3, rect.size.height*3)]]];
                        }
                    }
                    else
                    {
                        direction = UIPanGestureRecognizerDirectionLeft;
                        if (self.page < self.dataArray.count-1) {
                            UIImageView *imageView1 = self.viewsArray[0];
                            UIImageView *imageView2 = self.viewsArray[1];
                            self.maskView.frame = imageView2.frame;
                            [self insertSubview:self.maskView belowSubview:imageView1];
                            NSDictionary *source = self.dataArray[self.page+1];
                            CGRect rect = [self.originalArray[1] CGRectValue];
                            [imageView2 sd_setImageWithURL:[NSURL URLWithString:[source[@"image"] avatarHandleWithSize:CGSizeMake(rect.size.width*3, rect.size.height*3)]]];
                        }
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp:
                {
                    self.guesterDirection = UIPanGestureRecognizerDirectionUp;
                    break;
                }
                case UIPanGestureRecognizerDirectionDown:
                {
                    self.guesterDirection = UIPanGestureRecognizerDirectionDown;
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft:
                {
                    if (self.dataArray && self.page < self.dataArray.count-1) {
                        self.guesterDirection = UIPanGestureRecognizerDirectionLeft;
                        self.maskView.alpha = MAX((self.width-70+tranPoint.x), 0)/(self.width-70);
                        UIImageView *imageView1 = self.viewsArray[0];
                        [imageView1 setX:20+tranPoint.x];
                    }
                    else if (self.dataArray && self.page == self.dataArray.count-1)
                    {
                        self.guesterDirection = UIPanGestureRecognizerDirectionLeft;
                        UIImageView *imageView1 = self.viewsArray[0];
                        [imageView1 setX:20+MAX(tranPoint.x, -20)];
                    }
                    break;
                }
                case UIPanGestureRecognizerDirectionRight:
                {
                    
                    if (self.page == 0) {
                        self.guesterDirection = UIPanGestureRecognizerDirectionRight;
                        UIImageView *imageView1 = self.viewsArray[0];
                        [imageView1 setX:20+MIN(tranPoint.x, 20)];
                    }
                    else if (self.page > 0)
                    {
                        self.guesterDirection = UIPanGestureRecognizerDirectionRight;
                        UIImageView *imageView4 = self.viewsArray[3];
                        [imageView4 setX:originalX+tranPoint.x];
                        self.maskView.alpha = tranPoint.x/(self.width-70);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            direction = UIPanGestureRecognizerDirectionUndefined;
            [self swipeDirectionAction];
            break;
        }
        default:
            break;
    }
}

- (void)swipeDirectionAction {
    UIImageView *image1 = self.viewsArray[0];
    UIImageView *image2 = self.viewsArray[1];
    UIImageView *image3 = self.viewsArray[2];
    UIImageView *image4 = self.viewsArray[3];
    CGRect rect1 = [self.originalArray[0] CGRectValue];
    CGRect rect2 = [self.originalArray[1] CGRectValue];
    CGRect rect3 = [self.originalArray[2] CGRectValue];
    CGRect rect4 = [self.originalArray[3] CGRectValue];
    
    if (self.guesterDirection == UIPanGestureRecognizerDirectionLeft && self.dataArray && self.page < self.dataArray.count-1)
    {
        [self.maskView removeFromSuperview];
        self.page++;
        self.isAnimationing = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [image1 setFrame:rect4];
            [image2 setFrame:rect1];
            [image3 setFrame:rect2];
        } completion:^(BOOL finished) {
            [image4 setFrame:rect3];
            [self.viewsArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [self.viewsArray exchangeObjectAtIndex:1 withObjectAtIndex:2];
            [self.viewsArray exchangeObjectAtIndex:2 withObjectAtIndex:3];
            UIImageView *newImage1 = self.viewsArray[0];
            UIImageView *newImage2 = self.viewsArray[1];
            UIImageView *newImage3 = self.viewsArray[2];
            UIImageView *newImage4 = self.viewsArray[3];
            [self insertSubview:newImage1 atIndex:3];
            [self insertSubview:newImage2 atIndex:2];
            [self insertSubview:newImage3 atIndex:1];
            [self insertSubview:newImage4 atIndex:0];
            newImage1.backgroundColor = self.colorsArray[0];
            newImage2.backgroundColor = self.colorsArray[1];
            newImage3.backgroundColor = self.colorsArray[2];
            newImage4.backgroundColor = self.colorsArray[3];
            newImage2.image = nil;
            newImage3.image = nil;
            self.isAnimationing = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(cardViewSwipeTopIndex:)]) {
                [_delegate cardViewSwipeTopIndex:self.page];
            }
        }];
    }
    else if (self.guesterDirection == UIPanGestureRecognizerDirectionLeft && self.dataArray && self.page == self.dataArray.count-1)
    {
        self.isAnimationing = YES;
        UIImageView *image1 = self.viewsArray[0];
        [UIView animateWithDuration:0.2 animations:^{
            [image1 setX:20];
        } completion:^(BOOL finished) {
            self.isAnimationing = NO;
        }];
    }
    else if (self.guesterDirection == UIPanGestureRecognizerDirectionRight && self.page == 0)
    {
        self.isAnimationing = YES;
        UIImageView *image1 = self.viewsArray[0];
        [UIView animateWithDuration:0.2 animations:^{
            [image1 setX:20];
        } completion:^(BOOL finished) {
            self.isAnimationing = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(cardViewSwipeBeginRefreshData)]) {
                [_delegate cardViewSwipeBeginRefreshData];
            }
        }];
    }
    else if (self.guesterDirection == UIPanGestureRecognizerDirectionRight && self.page > 0)
    {
        [self.maskView removeFromSuperview];
        self.page--;
        self.isAnimationing = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [image4 setFrame:rect1];
            [image1 setFrame:rect2];
            [image2 setFrame:rect3];
        } completion:^(BOOL finished) {
            [image3 setFrame:rect4];
            UIImageView *image4 = self.viewsArray[3];
            [self.viewsArray removeObject:image4];
            [self.viewsArray insertObject:image4 atIndex:0];
            UIImageView *newImage1 = self.viewsArray[0];
            UIImageView *newImage2 = self.viewsArray[1];
            UIImageView *newImage3 = self.viewsArray[2];
            UIImageView *newImage4 = self.viewsArray[3];
            [self insertSubview:newImage1 atIndex:3];
            [self insertSubview:newImage2 atIndex:2];
            [self insertSubview:newImage3 atIndex:1];
            [self insertSubview:newImage4 atIndex:0];
            newImage1.backgroundColor = self.colorsArray[0];
            newImage2.backgroundColor = self.colorsArray[1];
            newImage3.backgroundColor = self.colorsArray[2];
            newImage4.backgroundColor = self.colorsArray[3];
            newImage2.image = nil;
            newImage3.image = nil;
            self.isAnimationing = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(cardViewSwipeTopIndex:)]) {
                [_delegate cardViewSwipeTopIndex:self.page];
            }
        }];
    }
}



@end
