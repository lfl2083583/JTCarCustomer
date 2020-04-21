//
//  JTSwitchDetailTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSwitchDetailTableViewCell.h"

@implementation JTSwitchDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initSubview];
    }
    return self;
}

- (void)swClick:(UISwitch *)sender
{
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(switchDetailTableViewCell:didChangeRowAtIndexPath:atValue:)]) {
        [_delegate switchDetailTableViewCell:self didChangeRowAtIndexPath:self.indexPath atValue:sender.isOn];
    }
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.frame = CGRectMake(self.sw.left-115, 0, 100, self.frame.size.height);
    }
    return _detailLB;
}

- (UISwitch *)sw
{
    if (!_sw) {
        _sw = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-66, (self.frame.size.height-31)/2, 51, 31)];
        _sw.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_sw addTarget:self action:@selector(swClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _sw;
}

- (void)initSubview
{
    [self addSubview:self.detailLB];
    [self addSubview:self.sw];
}

@end
