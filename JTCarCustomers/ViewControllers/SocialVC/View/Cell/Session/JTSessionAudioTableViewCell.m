//
//  JTSessionAudioTableViewCell.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionAudioTableViewCell.h"

@implementation JTSessionAudioTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.voiceImageView];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.audioPlayedIcon];
    [[NIMSDK sharedSDK].mediaManager addDelegate:self];
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

- (UIImageView *)voiceImageView
{
    if (!_voiceImageView) {
        _voiceImageView = [[UIImageView alloc] initWithImage:[UIImage jt_imageInKit:@"icon_receiver_voice_playing.png"]];
    }
    return _voiceImageView;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = Font(JTMessageTextFont);
    }
    return _durationLabel;
}

- (JTBadgeView *)audioPlayedIcon
{
    if (!_audioPlayedIcon) {
        _audioPlayedIcon = [JTBadgeView viewWithBadgeTip:@""];
    }
    return _audioPlayedIcon;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.model) {
        NIMAudioObject *audioObject = (NIMAudioObject *)self.message.messageObject;
        self.durationLabel.text = [NSString stringWithFormat:@"%zd\"",(audioObject.duration+500)/1000];//四舍五入
        [self.durationLabel sizeToFit];
        [self.audioPlayedIcon setHidden:[self unreadHidden]];
        
        if (self.isOutgoingMessage) {
            
            _voiceImageView.image = [UIImage jt_imageInKit:@"icon_sender_voice_playing.png"];
            NSArray * animateNames = @[@"icon_sender_voice_playing_001.png",@"icon_sender_voice_playing_002.png",@"icon_sender_voice_playing_003.png"];
            NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
            for (NSString * animateName in animateNames) {
                UIImage * animateImage = [UIImage jt_imageInKit:animateName];
                [animationImages addObject:animateImage];
            }
            _voiceImageView.animationImages = animationImages;
            _voiceImageView.animationDuration = 1.0;
            
            _voiceImageView.right = self.bubbleImageView.right - 20;
            _durationLabel.right = self.bubbleImageView.right - 45;
            _audioPlayedIcon.right = self.bubbleImageView.left - 8;
            
            _durationLabel.textColor = BlueLeverColor1;
        }
        else
        {
            _voiceImageView.image = [UIImage jt_imageInKit:@"icon_receiver_voice_playing.png"];
            NSArray * animateNames = @[@"icon_receiver_voice_playing_001.png",@"icon_receiver_voice_playing_002.png",@"icon_receiver_voice_playing_003.png"];
            NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
            for (NSString * animateName in animateNames) {
                UIImage * animateImage = [UIImage jt_imageInKit:animateName];
                [animationImages addObject:animateImage];
            }
            _voiceImageView.animationImages = animationImages;
            _voiceImageView.animationDuration = 1.0;
            
            _voiceImageView.left = self.bubbleImageView.left + 20;
            _durationLabel.left = self.bubbleImageView.left + 45;
            _audioPlayedIcon.left = self.bubbleImageView.right + 8;
            
            _durationLabel.textColor = BlackLeverColor5;
        }
        
        _voiceImageView.centerY = self.bubbleImageView.centerY;
        _durationLabel.centerY = self.bubbleImageView.centerY;
        _audioPlayedIcon.top = self.bubbleImageView.top;
    }
}

- (BOOL)unreadHidden {
    return self.model.message.isOutgoingMsg || self.message.isPlayed;
}

- (void)onValidTouchUpInside:(id)sender
{
    if ([[NIMSDK sharedSDK].mediaManager isPlaying]) {
        [self setPlaying:NO];
    }
    [super onValidTouchUpInside:sender];
}

- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    if(filePath && !error) {
        [self setPlaying:self.isPlaying];
        if (self.isPlaying) {
            [self.audioPlayedIcon setHidden:[self unreadHidden]];
        }
    }
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    [self setPlaying:NO];
}

- (void)setPlaying:(BOOL)isPlaying
{
    if (isPlaying)
    {
        [self.voiceImageView startAnimating];
    }
    else
    {
        [self.voiceImageView stopAnimating];
    }
}

- (BOOL)isPlaying
{
    //对比是否是同一条消息，严格同一条，不能是相同ID，防止进了会话又进云端消息界面，导致同一个ID的云消息也在动画
    return [JTAudioCenter instance].currentPlayingMessage == self.model.message;
}


@end
