//
//  JTStarView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStarView.h"

static CGFloat const imgWidth = 30;
static CGFloat const kSpace = 10;
static NSInteger const kImageViewTag = 10000;
static NSInteger const kMaxStar = 5;

@implementation JTPaddingButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL hit = [super pointInside:point withEvent:event];
    if (hit == NO)
    {
        if (point.x > -_exWidth && point.x-CGRectGetMaxX(self.bounds) <= _exWidth && fabs(point.y - CGRectGetMidY(self.bounds)) <= CGRectGetHeight(self.bounds)/2 + _exWidth)
        {
            return YES;
        }
    }
    return hit;
}

@end


@implementation JTStarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        for (NSInteger i = 0; i < kMaxStar; i++)
        {
            JTPaddingButton *button = [JTPaddingButton new];
            button.exWidth = 5;
            [button setImage:[UIImage imageNamed:@"evaluate_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"evaluate_normal"] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:@"evaluate_highlight"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = kImageViewTag+i;
            [self addSubview:button];
            __weak typeof(self)weakSelf = self;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.mas_left).with.offset((self.width-190)/2.0+kSpace*i+imgWidth*i);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
            }];
        }
        
    }
    return self;
}

- (void)setForSelect:(BOOL)forSelect
{
    for (NSInteger i = 0; i < kMaxStar; i++)
    {
        UIButton *view = [self viewWithTag:kImageViewTag + i];
        view.userInteractionEnabled = forSelect;
    }
}


- (void)markStar:(NSInteger)star
{
    for (NSInteger i = 0; i < kMaxStar; i++)
    {
        UIButton *view = [self viewWithTag:kImageViewTag + i];
        view.selected = i < star;
    }
}

- (void)onButtonPress:(UIButton *)button
{
    NSInteger star = button.tag-kImageViewTag + 1;
    [self markStar:star];
    if (self.onStart) {
        self.onStart(star);
    }
}

@end
