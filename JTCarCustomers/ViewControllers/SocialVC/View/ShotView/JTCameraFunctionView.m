//
//  JTCameraFunctionView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCameraFunctionView.h"
#import "JTCameraButton.h"

@interface JTCameraFunctionView ()

@property (nonatomic, strong) UIButton *closeBT;
@property (nonatomic, strong) UIButton *flashBT;
@property (nonatomic, strong) UIButton *modeBT;

@property (nonatomic, strong) JTCameraButton *cameraBT;
@property (nonatomic, strong) UILabel *promptLB;

@end

@implementation JTCameraFunctionView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCameraFunctionDelegate>)delegate maxRecorderDuration:(CGFloat)maxRecorderDuration
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setDelegate:delegate];
        [self setMaxRecorderDuration:maxRecorderDuration];
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.closeBT];
    [self addSubview:self.flashBT];
    [self addSubview:self.modeBT];
    [self addSubview:self.cameraBT];
    [self addSubview:self.promptLB];
}

- (void)closeClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(closeCamera)]) {
        [_delegate closeCamera];
    }
}

- (void)flashClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(flashCamera)]) {
        [_delegate flashCamera];
    }
}

- (void)modeClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(modeCamera)]) {
        [_delegate modeCamera];
    }
}

- (UIButton *)closeBT
{
    if (!_closeBT) {
        _closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBT.size = self.cameraBT.size;
        [_closeBT setImage:[UIImage imageNamed:@"bt_camera_close"] forState:UIControlStateNormal];
        [_closeBT addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBT;
}

- (UIButton *)flashBT
{
    if (!_flashBT) {
        _flashBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashBT.size = self.closeBT.size;
        _flashBT.right = self.modeBT.left+15;
        [_flashBT setImage:[UIImage imageNamed:@"bt_camera_flash"] forState:UIControlStateNormal];
        [_flashBT setImage:[UIImage imageNamed:@"bt_camera_flash_selected"] forState:UIControlStateSelected];
        [_flashBT addTarget:self action:@selector(flashClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashBT;
}

- (UIButton *)modeBT
{
    if (!_modeBT) {
        _modeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _modeBT.size = self.flashBT.size;
        _modeBT.right = self.right;
        [_modeBT setImage:[UIImage imageNamed:@"bt_camera_mode"] forState:UIControlStateNormal];
        [_modeBT addTarget:self action:@selector(modeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeBT;
}

- (JTCameraButton *)cameraBT
{
    if (!_cameraBT) {
        _cameraBT = [[JTCameraButton alloc] initWithDelegate:self.delegate maxRecorderDuration:10];
        _cameraBT.center = CGPointMake(self.centerX, self.bottom-70-self.cameraBT.height/2);
    }
    return _cameraBT;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] initWithFrame:CGRectMake(0, self.cameraBT.bottom + 35, self.width, 20)];
        _promptLB.textAlignment = NSTextAlignmentCenter;
        _promptLB.text = @"点击拍照  长按小视频";
        _promptLB.textColor = WhiteColor;
        _promptLB.font = Font(15);
    }
    return _promptLB;
}

@end
