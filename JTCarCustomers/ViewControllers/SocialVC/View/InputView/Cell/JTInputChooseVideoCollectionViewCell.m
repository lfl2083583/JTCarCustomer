//
//  JTInputChooseVideoCollectionViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputChooseVideoCollectionViewCell.h"
#import "UIImage+Chat.h"

@implementation JTInputChooseVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.markIV];
        [self addSubview:self.timeLB];
    }
    return self;
}

- (void)layoutSubviews
{
    self.markIV.frame = CGRectMake(10, self.height-25, 18, 18);
    [super layoutSubviews];
}

- (UIImageView *)markIV
{
    if (!_markIV) {
        _markIV = [[UIImageView alloc] init];
        _markIV.image = [UIImage jt_imageInKit:@"icon_video_white_small"];
        _markIV.frame = CGRectMake(10, self.height-25, 18, 18);
    }
    return _markIV;
}

- (UILabel *)timeLB
{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] init];
        _timeLB.font = Font(14);
        _timeLB.textColor = WhiteColor;
        _timeLB.textAlignment = NSTextAlignmentRight;
        _timeLB.frame = CGRectMake(self.markIV.right+5, self.height-25, self.width-self.markIV.right-15, 18);
    }
    return _timeLB;
}
@end
