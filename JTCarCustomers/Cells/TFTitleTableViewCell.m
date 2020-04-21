//
//  TFTitleTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "TFTitleTableViewCell.h"

@implementation TFTitleTableViewCell

- (void)initSubview
{
    [super initSubview];
    [self addSubview:self.titleLB];
    
    self.titleLB.frame = CGRectMake(16, 0, 150, self.height);
    self.contentTF.frame = CGRectMake(self.titleLB.right, 0, kScreenWidth-self.titleLB.right - 33, self.height);
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor5;
    }
    return _titleLB;
}
@end
