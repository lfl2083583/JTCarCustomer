//
//  JTInputExpressionCollectionViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputExpressionCollectionViewCell.h"
#import "JTInputGlobal.h"

@implementation JTInputExpressionCollectionViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.title.length == 0) {
        self.imageView.center = CGPointMake(self.width/2, self.height/2);
    }
    else if (self.imageUrlString.length == 0 && self.imageView.image == nil) {
        self.titleLB.center = CGPointMake(self.width/2, self.height/2);
    }
    else
    {
        self.imageView.frame = CGRectMake((JTKit_PhotoCellWidth-JTKit_PhotoImageWidth)/2, 0, JTKit_PhotoImageWidth, JTKit_PhotoImageHeight);
        self.titleLB.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), JTKit_PhotoCellWidth, JTKit_PhotoCellHeight-JTKit_PhotoImageHeight);
    }
}

- (void)setImageUrlString:(NSString *)imageUrlString
{
    _imageUrlString = imageUrlString;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString avatarHandleWithSquare:120]]];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLB.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLB];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.frame = CGRectMake((JTKit_PhotoCellWidth-JTKit_PhotoImageWidth)/2, 0, JTKit_PhotoImageWidth, JTKit_PhotoImageHeight);
    }
    return _imageView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(14);
        _titleLB.textColor = BlackLeverColor3;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), JTKit_PhotoCellWidth, JTKit_PhotoCellHeight-JTKit_PhotoImageHeight);
    }
    return _titleLB;
}

@end
