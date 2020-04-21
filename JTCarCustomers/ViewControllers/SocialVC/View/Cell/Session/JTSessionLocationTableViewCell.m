//
//  JTSessionLocationTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionLocationTableViewCell.h"

@implementation JTSessionLocationTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.photo];
    [self.contentView addSubview:self.titleLB];
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

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = BlackLeverColor5;
        _titleLB.font = Font(12);
    }
    return _titleLB;
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
        NIMLocationObject *locationObject = (NIMLocationObject *)self.model.message.messageObject;
        [self.photo sd_setImageWithURL:[NSURL URLWithString:[self getBaiduAdrPicForLat:locationObject.latitude lng:locationObject.longitude]]];
        self.titleLB.text = [locationObject.title componentsSeparatedByString:@"&&&&&&"][0];
        
        if (self.isOutgoingMessage) {
            self.photo.frame = CGRectMake(self.bubbleImageView.left, self.bubbleImageView.top, self.bubbleImageView.width-5, self.bubbleImageView.height-30);
            self.titleLB.frame = CGRectMake(self.bubbleImageView.left, self.bubbleImageView.bottom-30, self.bubbleImageView.width-5, 30);
        }
        else
        {
            self.photo.frame = CGRectMake(self.bubbleImageView.left+5, self.bubbleImageView.top, self.bubbleImageView.width-5, self.bubbleImageView.height-30);
            self.titleLB.frame = CGRectMake(self.bubbleImageView.left+5, self.bubbleImageView.bottom-30, self.bubbleImageView.width-5, 30);
        }
        UIBezierPath *photoMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.photo.bounds
                                                            byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                                  cornerRadii:CGSizeMake(4.0f, 4.0f)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.photo.bounds;
        maskLayer.path = photoMaskPath.CGPath;
        self.photo.layer.mask = maskLayer;
        
        UIBezierPath *titleMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.titleLB.bounds
                                                            byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                                  cornerRadii:CGSizeMake(4.0f, 4.0f)];
        CAShapeLayer *titleMaskLayer = [[CAShapeLayer alloc] init];
        titleMaskLayer.frame = self.titleLB.bounds;
        titleMaskLayer.path = titleMaskPath.CGPath;
        self.titleLB.layer.mask = titleMaskLayer;
        self.titleLB.layer.borderWidth = .5f;
        self.titleLB.layer.borderColor = BlackLeverColor2.CGColor;
    }
}

- (NSString *)getBaiduAdrPicForLat:(CGFloat)lat lng:(CGFloat)lng {
    return [NSString stringWithFormat:@"%@?markers=mid,0xFF0000,A:%f,%f&key=%@", LBS_Static, lng, lat, LBS_Key];
}

@end
