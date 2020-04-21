//
//  JTSessionAudioTableViewCell.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"
#import "JTBadgeView.h"
#import "UIImage+Chat.h"
#import "JTAudioCenter.h"

static NSString *sessionAudioIdentifier = @"JTSessionAudioTableViewCell";

@interface JTSessionAudioTableViewCell : JTSessionTableViewCell <NIMMediaManagerDelegate>

@property (nonatomic, strong) UIImageView *voiceImageView;

@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) JTBadgeView *audioPlayedIcon; // 语音未读红点

- (void)setPlaying:(BOOL)isPlaying;

@end
