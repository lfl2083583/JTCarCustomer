//
//  JTInputEmojiCollectionViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputEmojiCollectionViewCell.h"

@implementation JTInputEmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.emoji];
    }
    return self;
}

- (UIImageView *)emoji
{
    if (!_emoji) {
        _emoji = [[UIImageView alloc] init];
        _emoji.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _emoji;
}

@end
