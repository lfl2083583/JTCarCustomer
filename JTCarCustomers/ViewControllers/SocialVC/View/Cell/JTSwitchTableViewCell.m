//
//  JTSwitchTableViewCell.m
//  JTCarCustomers
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSwitchTableViewCell.h"

@implementation JTSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setTextColor:BlackLeverColor5];
        [self.textLabel setFont:Font(15)];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initSubview];
    }
    return self;
}

- (void)swClick:(UISwitch *)sender
{
    if (_indexPath && _delegate && [_delegate respondsToSelector:@selector(switchTableViewCell:didChangeRowAtIndexPath:atValue:)]) {
        [_delegate switchTableViewCell:self didChangeRowAtIndexPath:self.indexPath atValue:sender.isOn];
    }
}

- (UISwitch *)sw
{
    if (!_sw) {
        _sw = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-66, (self.frame.size.height-31)/2, 51, 31)];
        [_sw setOnTintColor:BlueLeverColor1];
        _sw.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_sw addTarget:self action:@selector(swClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _sw;
}

- (void)initSubview
{
    [self addSubview:self.sw];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
