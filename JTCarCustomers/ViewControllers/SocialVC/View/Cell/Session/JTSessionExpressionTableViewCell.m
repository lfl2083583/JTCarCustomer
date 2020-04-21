//
//  JTSessionExpressionTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionExpressionTableViewCell.h"

@implementation JTSessionExpressionTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self.contentView addSubview:self.photo];
}

- (FLAnimatedImageView *)photo
{
    if (!_photo) {
        _photo = [[FLAnimatedImageView alloc] init];
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
        NIMCustomObject *customObject = (NIMCustomObject *)self.message.messageObject;
        id attachment = customObject.attachment;
        if ([attachment isKindOfClass:[JTExpressionAttachment class]]) {
            BOOL isGif = [[(JTExpressionAttachment *)attachment expressionUrl] hasSuffix:@"gif"];
            NSURL *url;
            if (isGif) {
                url = [NSURL URLWithString:[(JTExpressionAttachment *)attachment expressionUrl]];
            }
            else
            {
                url = [NSURL URLWithString:[[(JTExpressionAttachment *)attachment expressionUrl] avatarHandleWithSize:CGSizeMake(self.model.contentSize.width*2, self.model.contentSize.height*2)]];
            }
            [self.photo sd_setImageWithURL:url placeholderImage:nil];
        }
        
        self.photo.frame = CGRectMake(self.bubbleImageView.left + 2, self.bubbleImageView.top + 2, self.model.contentSize.width - 4, self.model.contentSize.height - 4);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.photo.bounds
                                                       byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft)
                                                             cornerRadii:CGSizeMake(16.0f, 16.0f)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.photo.bounds;
        maskLayer.path = maskPath.CGPath;
        self.photo.layer.mask = maskLayer;
    }
}

@end
