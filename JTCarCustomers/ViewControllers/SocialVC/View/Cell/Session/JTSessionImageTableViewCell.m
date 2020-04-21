//
//  JTSessionImageTableViewCell.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionImageTableViewCell.h"

@implementation JTSessionImageTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.photo];
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
        if (self.message.messageType == NIMMessageTypeImage) {
            NIMImageObject *imageObject = (NIMImageObject *)self.message.messageObject;
            self.photo.image = [UIImage imageWithContentsOfFile:imageObject.thumbPath];
        }
        else if (self.message.messageType == NIMMessageTypeCustom)
        {
            NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
            if ([object.attachment isKindOfClass:[JTImageAttachment class]]) {
                JTImageAttachment *attachment = (JTImageAttachment *)object.attachment;
                [self.photo sd_setImageWithURL:[NSURL URLWithString:[attachment.imageUrl avatarHandleWithSize:CGSizeMake(self.model.contentSize.width*2, self.model.contentSize.height*2)]]];
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
    }
}

@end
