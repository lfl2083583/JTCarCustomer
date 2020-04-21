//
//  JTImageCollectionViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTImageCollectionViewCell.h"

@implementation JTImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLB];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake((self.width-30)/2, 16, 30, 30);
    }
    return _imageView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = BlackLeverColor5;
        _titleLB.font = Font(12);
        _titleLB.frame = CGRectMake(0, 48, self.width, 15);
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}
@end
