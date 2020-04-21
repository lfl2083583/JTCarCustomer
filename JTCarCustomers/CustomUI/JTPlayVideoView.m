//
//  JTPlayVideoView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTPlayVideoView.h"

@interface JTPlayVideoView ()

@end

@implementation JTPlayVideoView

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)videoUrl videoPath:(NSString *)videoPath coverUrl:(NSString *)coverUrl coverPath:(NSString *)coverPath
{
    self = [super initWithFrame:frame];
    if (self) {
        _videoUrl = videoUrl;
        _videoPath = videoPath;
        _coverUrl = coverUrl;
        _coverPath = coverPath;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.moviePlayer.view];
    if (!self.isAutoPlay) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.coverPath]) {
            [self.coverImage setImage:[UIImage imageNamed:self.coverPath]];
        }
        else
        {
            [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.coverUrl]];
        }
        [self addSubview:self.coverImage];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.moviePlayer];
}

- (void)setVideoPath:(NSString *)videoPath
{
    _videoPath = videoPath;
    [self startPlay];
}

- (void)startPlay
{
    if (_delegate && [_delegate respondsToSelector:@selector(playLoad)]) {
        [_delegate playLoad];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
        [self videoPlay];
    }
    else
    {
        __weak typeof(self) weakself = self;
        [[NIMSDK sharedSDK].resourceManager download:self.videoUrl filepath:self.videoPath progress:^(float progress) {
            [[HUDTool shareHUDTool] showHint:@"加载中" progress:progress yOffset:0];
        } completion:^(NSError *error) {
            if (!error) {
                [weakself videoPlay];
            }
            else
            {
                [[HUDTool shareHUDTool] showHint:@"下载失败，请检查网络"];
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(playFail)]) {
                    [weakself.delegate playFail];
                }
            }
        }];
    }
}

- (void)videoPlay
{
    if (_delegate && [_delegate respondsToSelector:@selector(playStart)]) {
        [_delegate playStart];
    }
    [self.coverImage setHidden:YES];
    [self.moviePlayer setContentURL:[NSURL fileURLWithPath:self.videoPath]];
    [self.moviePlayer play];
}

- (void)stopPlay
{
    [self.moviePlayer stop];
}

- (void)stopPause
{
    [self.moviePlayer pause];
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    if (self.moviePlayer == notification.object)
    {
        NSDictionary *notificationUserInfo = [notification userInfo];
        NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        MPMovieFinishReason reason = [resultValue intValue];
        if (reason == MPMovieFinishReasonPlaybackError)
        {
            NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
            NSString *errorTip = [NSString stringWithFormat:@"播放失败: %@", [mediaPlayerError localizedDescription]];
            if (errorTip) {
                [[HUDTool shareHUDTool] showHint:errorTip];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(playFail)]) {
                [_delegate playFail];
            }
        }
        else
        {
            if (self.isLoopPlay) {
                [self startPlay];
            }
            else
            {
                if (_delegate && [_delegate respondsToSelector:@selector(playEnd)]) {
                    [_delegate playEnd];
                }
            }
        }
    }
}

- (void)moviePlayStateChanged:(NSNotification *)notification
{
    if (self.moviePlayer == notification.object)
    {
        switch (self.moviePlayer.playbackState)
        {
            case MPMoviePlaybackStatePlaying:
                break;
            case MPMoviePlaybackStatePaused:
            case MPMoviePlaybackStateStopped:
            case MPMoviePlaybackStateInterrupted:
            case MPMoviePlaybackStateSeekingBackward:
            case MPMoviePlaybackStateSeekingForward:
                break;
        }
    }
}

- (MPMoviePlayerController *)moviePlayer {
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        _moviePlayer.view.frame = self.bounds;
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _moviePlayer.fullscreen = YES;
    }
    return _moviePlayer;
}

- (UIImageView *)coverImage
{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImage.contentMode = UIViewContentModeScaleAspectFit;
        _coverImage.clipsToBounds = YES;
    }
    return _coverImage;
}

@end
