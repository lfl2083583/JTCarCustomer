//
//  JTSessionVideoTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionVideoTableViewCell.h"
#import "UIImage+Chat.h"

@implementation JTSessionVideoTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.photo];
    [self.contentView addSubview:self.playIcon];
}

- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc] init];
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.clipsToBounds = YES;
    }
    return _photo;
}

- (UIImageView *)playIcon
{
    if (!_playIcon) {
        _playIcon = [[UIImageView alloc] init];
        _playIcon.size = CGSizeMake(35, 35);
        _playIcon.image = [UIImage jt_imageInKit:@"icon_play_normal"];
    }
    return _playIcon;
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
        if (self.message.messageType == NIMMessageTypeVideo) {
            NIMVideoObject *videoObject = (NIMVideoObject *)self.message.messageObject;
            self.photo.image = [UIImage imageWithContentsOfFile:videoObject.coverPath];
        }
        else if (self.message.messageType == NIMMessageTypeCustom)
        {
            NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
            if ([object.attachment isKindOfClass:[JTVideoAttachment class]]) {
                JTVideoAttachment *attachment = (JTVideoAttachment *)object.attachment;
                NSString *avatarUrlString = [attachment.videoCoverUrl stringByAppendingString:[NSString stringWithFormat:@"?imageView&thumbnail=%ldz%ld", (long)self.model.contentSize.width*2, (long)self.model.contentSize.height*2]];
                [self.photo sd_setImageWithURL:[NSURL URLWithString:avatarUrlString]];
            }
        }
    
        self.photo.frame = CGRectMake(self.bubbleImageView.left, self.bubbleImageView.top, self.bubbleImageView.width, self.bubbleImageView.height);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.photo.bounds
                                                       byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(4.0f, 4.0f)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.photo.bounds;
        maskLayer.path = maskPath.CGPath;
        self.photo.layer.mask = maskLayer;
        self.playIcon.center = self.bubbleImageView.center;
    }
}
@end
