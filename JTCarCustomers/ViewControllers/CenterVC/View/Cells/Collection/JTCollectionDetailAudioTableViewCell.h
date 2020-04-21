//
//  JTCollectionDetailAudioTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTVoiceWaveView.h"
#import "JTCollectionTableViewCell.h"

static NSString *const collectionDetailAudioIdentifier = @"JTCollectionDetailAudioTableViewCell";

@interface JTCollectionDetailAudioTableViewCell : JTCollectionTableViewCell

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UILabel *durationLB;
@property (strong, nonatomic) JTVoiceWaveView *waveView;
@property (strong, nonatomic) UIView *tapeView;

@end
