//
//  JTCollectionDetailAudioTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTColectionTool.h"
#import "JTCollectionDetailAudioTableViewCell.h"
@interface JTCollectionDetailAudioTableViewCell ()

{
    NSTimer * timer;
}
@property (nonatomic ,assign) double time;
@property (nonatomic ,assign) BOOL isSetPause;

@end

@implementation JTCollectionDetailAudioTableViewCell

- (void)dealloc {
    [timer invalidate];
    timer = nil;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:[UIImage imageNamed:@"icon_voice_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"icon_voice_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UILabel *)durationLB
{
    if (!_durationLB) {
        _durationLB = [[UILabel alloc] init];
        _durationLB.font = Font(16);
        _durationLB.textColor = BlackLeverColor5;
    }
    return _durationLB;
}

- (JTVoiceWaveView *)waveView
{
    if (!_waveView) {
        _waveView = [[JTVoiceWaveView alloc] init];
    }
    return _waveView;
}

- (UIView *)tapeView {
    if (!_tapeView) {
        _tapeView = [[UIView alloc] init];
        _tapeView.backgroundColor = BlackLeverColor1;
    }
    return _tapeView;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.avatarView];
    [self.bottomView addSubview:self.nameLB];
    [self.bottomView addSubview:self.genderView];
    [self.bottomView addSubview:self.horizontalView];
    [self.bottomView addSubview:self.tapeView];
    [self.tapeView addSubview:self.playBtn];
    [self.tapeView addSubview:self.durationLB];
    [self.tapeView addSubview:self.waveView];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.avatarView.mas_right).offset(10);
        make.centerY.equalTo(weakself.avatarView.mas_centerY);
    }];
    
    [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(16);
        make.right.equalTo(weakself.mas_right).offset(-16);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(weakself.avatarView.mas_bottom).offset(10);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.tapeView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(24, 32));
        make.centerY.equalTo(weakself.tapeView.mas_centerY);
    }];
    
    [self.durationLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.playBtn.mas_right).with.offset(10);
        make.centerY.equalTo(weakself.tapeView.mas_centerY);
    }];
    
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 25));
        make.centerY.equalTo(weakself.tapeView.mas_centerY);
        make.left.equalTo(weakself.tapeView.mas_left).with.offset(100);
    }];
    
    [self.tapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.right.equalTo(@-16);
        make.top.equalTo(weakself.horizontalView.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *voiceUrl = [self.model.contentDic objectForKey:@"url"];
    NSString *voiceTime = [self.model.contentDic objectForKey:@"duration"];
    double voicetime = [voiceTime floatValue];
    if (sender.selected) {
        if (voiceUrl) {
            [JTColectionTool playWithURL:voiceUrl delegate:nil];
            
        }
        if (!_isSetPause) {
            _time = voicetime;
            [_waveView startAnimation];
        } else {
           [_waveView resumeAnimation];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/24 target:self selector:@selector(repeat:) userInfo:nil repeats:YES];
    } else {
        [JTColectionTool pause];
        [_waveView pauseAnimation];
        _isSetPause = YES;
        [timer invalidate];
        timer = nil;
    }
}

- (void)repeat:(NSTimer*)tr
{
    NSString *voiceTime = [self.model.contentDic objectForKey:@"duration"];
    double voicetime = [voiceTime floatValue];
    if (_time <= 0) {
        
        _time = voicetime;
        NSString * time = nil;
        if (_time > 9) {
            time = [NSString stringWithFormat:@"%.f", _time];
        } else {
            time = [NSString stringWithFormat:@"0%.f", _time];
        }
        [self.durationLB setText:[NSString stringWithFormat:@"00:%@",time]];
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [JTColectionTool cancel];
        [self.waveView stopAnimation];
        self.playBtn.selected = NO;
    } else {
        double t = (double)1/(double)24;
        _time = _time - t;
        NSString * time = nil;
        if (_time > 9) {
            time = [NSString stringWithFormat:@"%.f", ceil(_time)];
        } else {
            time = [NSString stringWithFormat:@"0%.f", ceil(_time)];
        }
        [self.durationLB setText:[NSString stringWithFormat:@"00:%@",time]];
    }
}


- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSString *voiceTime = [model.contentDic objectForKey:@"duration"];
    self.waveView.duration = [voiceTime floatValue];
    double voicetime = [voiceTime floatValue];
    NSString * time = nil;
    if (voicetime > 9) {
        time = [NSString stringWithFormat:@"%.f", voicetime];
    } else {
        time = [NSString stringWithFormat:@"0%.f", voicetime];
    }
    [self.durationLB setText:[NSString stringWithFormat:@"00:%@",time]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
