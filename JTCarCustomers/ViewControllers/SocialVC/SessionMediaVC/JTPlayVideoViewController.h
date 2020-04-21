//
//  JTPlayVideoViewController.h
//  JTSocial
//
//  Created by apple on 2017/7/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTPlayVideoView.h"

@interface JTPlayVideoViewController : UIViewController <JTPlayVideoViewDelegate>

@property (nonatomic, strong) JTPlayVideoView *playVideoView;

- (instancetype)initWithVideoUrl:(NSString *)videoUrl videoPath:(NSString *)videoPath coverUrl:(NSString *)coverUrl coverPath:(NSString *)coverPath longPressBlock:(void (^_Nullable)(UIViewController *viewController))longPressBlock;

@end
