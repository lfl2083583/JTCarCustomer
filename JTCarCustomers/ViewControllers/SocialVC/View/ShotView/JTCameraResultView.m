//
//  JTCameraResultView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCameraResultView.h"
#import "JTPlayVideoView.h"

@interface JTCameraResultView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) JTPlayVideoView *playVideoView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *remakeBT;
@property (nonatomic, strong) UIButton *sendBT;

@end

@implementation JTCameraResultView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCameraResultDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setHidden:YES];
        [self setDelegate:delegate];
        [self addSubview:self.imageView];
        [self addSubview:self.playVideoView];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.remakeBT];
        [self.bottomView addSubview:self.sendBT];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    [self setHidden:NO];
    [self.imageView setHidden:NO];
    [self.playVideoView setHidden:YES];
    [self.imageView setImage:image];
    [self setCameraResultType:JTCameraResultTypeImage];
}

- (void)setVideoPath:(NSString *)videoPath
{
    [self setHidden:NO];
    [self.imageView setHidden:YES];
    [self.playVideoView setHidden:NO];
    [self.playVideoView setVideoPath:videoPath];
    [self setCameraResultType:JTCameraResultTypeVideo];
}

- (void)clear
{
    [self setHidden:YES];
    if (self.playVideoView.moviePlayer.isPreparedToPlay) {
        [self.playVideoView stopPlay];
    }
}

- (void)remakeClick:(id)sender
{
    [self clear];
    if (_delegate && [_delegate respondsToSelector:@selector(remake)]) {
        [_delegate remake];
    }
}

- (void)sendClick:(id)sender
{
    [self clear];
    if (self.cameraResultType == JTCameraResultTypeImage) {
        if (_delegate && [_delegate respondsToSelector:@selector(sendImage:)]) {
            [_delegate sendImage:self.imageView.image];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(sendVideo:)]) {
            [_delegate sendVideo:self.playVideoView.videoPath];
        }
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (JTPlayVideoView *)playVideoView
{
    if (!_playVideoView) {
        _playVideoView = [[JTPlayVideoView alloc] initWithFrame:self.bounds];
        _playVideoView.isLoopPlay = YES;
        _playVideoView.isAutoPlay = YES;
    }
    return _playVideoView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-50, self.width, 50)];
        _bottomView.backgroundColor = UIColorFromRGBoraAlpha(0x000000, .5);
    }
    return _bottomView;
}

- (UIButton *)remakeBT
{
    if (!_remakeBT) {
        _remakeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remakeBT setTitle:@"重拍" forState:UIControlStateNormal];
        [_remakeBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_remakeBT.titleLabel setFont:Font(15)];
        [_remakeBT addTarget:self action:@selector(remakeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_remakeBT setFrame:CGRectMake(0, 0, 70, self.bottomView.height)];
    }
    return _remakeBT;
}

- (UIButton *)sendBT
{
    if (!_sendBT) {
        _sendBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBT setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_sendBT setBackgroundColor:BlueLeverColor1];
        [_sendBT.titleLabel setFont:Font(15)];
        [_sendBT addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBT setSize:CGSizeMake(70, 30)];
        [_sendBT setRight:self.bottomView.width-15];
        [_sendBT setCenterY:self.bottomView.height/2];
        [_sendBT.layer setCornerRadius:15.0f];
    }
    return _sendBT;
}

@end
