//
//  ZTTableViewHeaderFooterView.m
//  JTSocial
//
//  Created by apple on 2017/6/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "ZTTableViewHeaderFooterView.h"

@implementation ZTTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.promptLB];
    }
    return self;
}

- (void)layoutSubviews
{
    self.promptLB.frame = CGRectMake(15, 5, self.bounds.size.width-30, self.bounds.size.height-10);
    [super layoutSubviews];
}

- (ZTAlignmentLabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[ZTAlignmentLabel alloc] init];
        _promptLB.font = Font(14);
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.numberOfLines = 0;
    }
    return _promptLB;
}


@end
