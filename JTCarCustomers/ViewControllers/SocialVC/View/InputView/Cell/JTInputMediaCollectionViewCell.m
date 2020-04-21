//
//  JTInputMediaCollectionViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputMediaCollectionViewCell.h"

@implementation JTInputMediaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.button];
    }
    return self;
}

- (ZTButtonExt *)button
{
    if (!_button) {
        _button = [ZTButtonExt buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = Font(12);
        [_button setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        _button.userInteractionEnabled = NO;
        _button.frame = self.bounds;
        _button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _button;
}
@end
