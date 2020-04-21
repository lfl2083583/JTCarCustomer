//
//  JTPlayVideoView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol JTPlayVideoViewDelegate <NSObject>
- (void)playLoad;  // 播放加载
- (void)playStart; // 播放开始
- (void)playEnd;   // 播放结束
- (void)playFail;  // 播放失败
@end

@interface JTPlayVideoView : UIView

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *coverPath;
@property (nonatomic, assign) BOOL isLoopPlay;
@property (nonatomic, assign) BOOL isAutoPlay;
@property (nonatomic, assign) id<JTPlayVideoViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)videoUrl videoPath:(NSString *)videoPath coverUrl:(NSString *)coverUrl coverPath:(NSString *)coverPath;

- (void)startPlay;
- (void)stopPlay;
- (void)stopPause;
@end
