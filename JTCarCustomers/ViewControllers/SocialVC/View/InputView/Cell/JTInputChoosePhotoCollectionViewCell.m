//
//  JTInputChoosePhotoCollectionViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputChoosePhotoCollectionViewCell.h"
#import "UIImage+Chat.h"

@implementation JTInputChoosePhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bottomIV];
        [self addSubview:self.choiceBT];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.choiceBT setFrame:CGRectMake(self.width-44, 0, 44, 44)];;
    [super layoutSubviews];
}

- (UIImageView *)bottomIV
{
    if (!_bottomIV) {
        _bottomIV = [[UIImageView alloc] init];
        _bottomIV.frame = self.bounds;
        _bottomIV.image = [[UIImage jt_imageInKit:@"bg_photo_load"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        _bottomIV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _bottomIV;
}

- (UIButton *)choiceBT
{
    if (!_choiceBT) {
        _choiceBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBT setImage:[UIImage imageNamed:@"icon_accessory_normal"] forState:UIControlStateNormal];
        [_choiceBT setImage:[UIImage imageNamed:@"icon_accessory_selected"] forState:UIControlStateSelected];
        _choiceBT.frame = CGRectMake(self.width-44, 0, 44, 44);
        _choiceBT.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [_choiceBT addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceBT;
}

- (void)choiceClick:(id)sender
{
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock();
    }
}

@end
