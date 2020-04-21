//
//  JTUserInfoCollectionViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTUserInfoCollectionViewCell.h"

@interface JTUserInfoCollectionViewCell () <UIGestureRecognizerDelegate>


@end

@implementation JTUserInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bottomImgeView];
        [self addSubview:self.topImgeView];
        
        UILongPressGestureRecognizer * longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bottomImgeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 44) / 2.0, (self.height - 44) / 2.0, 44, 44)];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (void)gestureAction:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewImgeViewDrag:)]) {
        [self.delegate collectionViewImgeViewDrag:gestureRecognizer];
    }
}

- (UIImageView *)topImgeView {
    if (!_topImgeView) {
        _topImgeView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _topImgeView;
}

- (UIImageView *)bottomImgeView {
    if (!_bottomImgeView) {
        _bottomImgeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 44) / 2.0, (self.height - 44) / 2.0, 44, 44)];
        _bottomImgeView.image = [UIImage imageNamed:@"photo_add_icon"];
    }
    return _bottomImgeView;
}

@end
