//
//  JTBaseSpringView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBaseSpringView.h"

@interface JTSpringRootView ()

@property (assign, nonatomic) float keyboardHeight;

@end

@implementation JTSpringRootView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

#pragma mark - UIKeyboardNotification
- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    if (!self.window) {
        return;//如果当前vc不是堆栈的top vc，则不需要监听
    }
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = endFrame.size.height;
}

- (void)setKeyboardHeight:(float)keyboardHeight
{
    self.center = CGPointMake(self.superview.centerX, (self.superview.height-keyboardHeight)/2);
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self setup];
    }
}

- (void)setup
{
    [self addSubview:self.closeBT];
    CGFloat maxWidth = self.closeBT.width, maxHeight = self.closeBT.height;
    if (self.contentView) {
        [self addSubview:self.contentView];
        maxWidth = MAX(self.contentView.width, maxWidth);
        maxHeight = maxHeight + 30 + self.contentView.height;
    }
    self.size = CGSizeMake(maxWidth, maxHeight);
    self.center = CGPointMake(self.superview.centerX, (self.superview.height-self.keyboardHeight)/2);
    self.contentView.left = 0;
    self.contentView.top = 0;
    self.closeBT.centerX = maxWidth/2;
    self.closeBT.top = self.contentView.bottom + 30;
}

- (void)closeClick:(id)sender
{
    [self.superview dismissViewAnimated:YES completion:^{
        
    }];
}

- (UIButton *)closeBT
{
    if (!_closeBT) {
        _closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBT setImage:[UIImage imageNamed:@"bt_spring_close"] forState:UIControlStateNormal];
        [_closeBT addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBT setSize:CGSizeMake(35, 35)];
    }
    return _closeBT;
}

@end

@implementation JTBaseSpringView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView
{
    self = [super initWithFrame:SC_DEVICE_BOUNDS];
    if (self) {
        [self.rootView setContentView:contentView];
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.rootView];
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
}

- (JTSpringRootView *)rootView
{
    if (!_rootView) {
        _rootView = [[JTSpringRootView alloc] init];
        _rootView.backgroundColor = [UIColor clearColor];
    }
    return _rootView;
}

@end
