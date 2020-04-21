//
//  JTChoosePhotoCollectionViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTChoosePhotoCollectionViewCell.h"

@implementation JTChoosePhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.photo];
        [self addSubview:self.markIcon];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.markIcon setFrame:CGRectMake(self.width-44, 0, 44, 44)];
    [super layoutSubviews];
}

- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc] init];
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.frame = self.bounds;
        _photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _photo;
}

- (UIImageView *)markIcon
{
    if (!_markIcon) {
        _markIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-44, 0, 44, 44)];
        _markIcon.image = [UIImage imageNamed:@"icon_accessory_normal"];
        _markIcon.contentMode = UIViewContentModeCenter;
        _markIcon.hidden = YES;
    }
    return _markIcon;
}

@end
