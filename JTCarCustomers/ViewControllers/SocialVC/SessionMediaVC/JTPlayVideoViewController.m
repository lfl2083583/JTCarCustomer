//
//  JTPlayVideoViewController.m
//  JTSocial
//
//  Created by apple on 2017/7/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTPlayVideoViewController.h"
#import "CLAlertController.h"

@interface JTPlayVideoViewController ()

@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *coverPath;
@property (nonatomic, copy) void (^longPressBlock)(UIViewController *viewController);
@property (nonatomic, strong) UIButton *playBT;
@property (nonatomic, strong) UIButton *closeBT;

@end

@implementation JTPlayVideoViewController

- (instancetype)initWithVideoUrl:(NSString *)videoUrl videoPath:(NSString *)videoPath coverUrl:(NSString *)coverUrl coverPath:(NSString *)coverPath longPressBlock:(void (^ _Nullable)(UIViewController *))longPressBlock {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _videoUrl = videoUrl;
        _videoPath = videoPath;
        _coverUrl = coverUrl;
        _coverPath = coverPath;
        _longPressBlock = longPressBlock;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.playVideoView];
    [self.view addSubview:self.closeBT];
    [self.view addSubview:self.playBT];
    
    if (self.longPressBlock) {
        [self.playVideoView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)]];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
            self.longPressBlock(self);
        }
    }
}

- (void)playClick:(id)sender
{
    [self.playVideoView startPlay];
}

- (void)closeClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playLoad
{
    self.playBT.hidden = YES;
}

- (void)playStart
{
    self.playBT.hidden = YES;
}

- (void)playEnd
{
    self.playBT.hidden = NO;
}

- (void)playFail
{
    self.playBT.hidden = NO;
}

- (JTPlayVideoView *)playVideoView
{
    if (!_playVideoView) {
        _playVideoView = [[JTPlayVideoView alloc] initWithFrame:self.view.bounds videoUrl:self.videoUrl videoPath:self.videoPath coverUrl:self.coverUrl coverPath:self.coverPath];
        _playVideoView.delegate = self;
    }
    return _playVideoView;
}

- (UIButton *)playBT
{
    if (!_playBT) {
        _playBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBT setImage:[UIImage imageNamed:@"bt_play"] forState:UIControlStateNormal];
        _playBT.size = CGSizeMake(100, 100);
        _playBT.center = self.view.center;
        [_playBT addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBT;
}

- (UIButton *)closeBT
{
    if (!_closeBT) {
        _closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBT setImage:[UIImage imageNamed:@"bt_white_close"] forState:UIControlStateNormal];
        _closeBT.frame = CGRectMake(0, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        [_closeBT addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBT;
}

@end
