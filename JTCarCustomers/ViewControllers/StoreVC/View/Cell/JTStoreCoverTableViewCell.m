//
//  JTStoreCoverTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreCoverTableViewCell.h"

@implementation JTStoreCoverTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.scrollview];
}

- (void)setCoverImages:(NSArray *)coverImages
{
    if (!_coverImages || ![_coverImages isEqualToArray:coverImages]) {
        _coverImages = coverImages;
        for (UIView *view in self.scrollview.subviews) {
            [view setHidden:YES];
            [view removeFromSuperview];
        }
        CGFloat offsetX = 0;
        for (NSString *url in _coverImages) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(offsetX, 0, 100, 56);
            [imageV sd_setImageWithURL:[NSURL URLWithString:[url avatarHandleWithSize:CGSizeMake(imageV.width*2, imageV.height*2)]]];
            [self.scrollview addSubview:imageV];
            offsetX = CGRectGetMaxX(imageV.frame)+5;
        }
        self.scrollview.contentSize = CGSizeMake(offsetX, 0);
    }
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.frame = CGRectMake(15, 10, App_Frame_Width-30, 20);
        _titleLB.text = @"商家环境";
    }
    return _titleLB;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(15, self.titleLB.bottom+10, App_Frame_Width-30, 56)];
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
    }
    return _scrollview;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
