//
//  JTHotCarBrandView.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTHotCarBrandView.h"
#import "UIButton+WebCache.h"

@implementation JTHotCarBrandView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTHotCarBrandViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    if (!_dataArray || ![_dataArray isEqual:dataArray]) {
        _dataArray = dataArray;
        if (self.subviews.count > 0) {
            for (UIView *view in self.subviews) {
                [view removeFromSuperview];
            }
        }
        CGFloat itemWidth = 60, itemHeight = 60, itemTop = 15;
        CGFloat space = (self.width - 5 * itemWidth) / 5;
        CGFloat itemLeft = space/2;
        for (NSInteger index = 0; index < self.dataArray.count; index ++) {
            NSDictionary *source = [self.dataArray objectAtIndex:index];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(itemLeft, itemTop, itemWidth, itemHeight);
            [button setTitle:source[@"name"] forState:UIControlStateNormal];
            [button setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
            [button.titleLabel setFont:Font(14)];
            [button setTag:index];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
            [self addSubview:button];
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(button.left + (button.width-30)/2, button.top, 30, 30)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:[source[@"img"] avatarHandleWithSquare:60]]];
            [self addSubview:imageview];
            
            itemLeft = CGRectGetMaxX(button.frame) + space;
            if ((itemLeft + itemWidth) > self.width) {
                itemLeft = space/2;
                itemTop = CGRectGetMaxY(button.frame) + 15;
            }
        }
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(hotCarBrandView:didSelectAtSoucre:)]) {
        [_delegate hotCarBrandView:self didSelectAtSoucre:self.dataArray[sender.tag]];
    }
}

@end
