//
//  JTStoreCommentClassTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreCommentClassTableViewCell.h"

@implementation JTStoreCommentClassTableViewCell

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
    [self.contentView addSubview:self.button_1];
    [self.contentView addSubview:self.button_2];
    [self.contentView addSubview:self.button_3];
    [self.contentView addSubview:self.button_4];
}

- (void)buttonClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(storeCommentClassTableViewCell:didSelectIndex:)]) {
        [_delegate storeCommentClassTableViewCell:self didSelectIndex:sender.tag];
    }
}

- (void)setType:(NSInteger)type
{
    _type = type;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag == type) {
                view.backgroundColor = BlueLeverColor4;
                view.layer.borderColor = [UIColor clearColor].CGColor;
                [(UIButton *)view setSelected:YES];
            }
            else
            {
                view.backgroundColor = BlackLeverColor1;
                view.layer.borderColor = BlackLeverColor2.CGColor;
                [(UIButton *)view setSelected:NO];
            }
        }
    }
}

- (UIButton *)button_1
{
    if (!_button_1) {
        _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_1 setTitle:@"全部" forState:UIControlStateNormal];
        [_button_1 setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_button_1 setTitleColor:BlueLeverColor1 forState:UIControlStateSelected];
        _button_1.titleLabel.font = Font(12);
        _button_1.layer.cornerRadius = 4;
        _button_1.layer.borderWidth = .5;
        _button_1.tag = 1;
        _button_1.frame = CGRectMake(15, 10, (App_Frame_Width-60)/4, 30);
        [_button_1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_1;
}

- (UIButton *)button_2
{
    if (!_button_2) {
        _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_2 setTitle:@"好评" forState:UIControlStateNormal];
        [_button_2 setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_button_2 setTitleColor:BlueLeverColor1 forState:UIControlStateSelected];
        _button_2.titleLabel.font = Font(12);
        _button_2.layer.cornerRadius = 4;
        _button_2.layer.borderWidth = .5;
        _button_2.tag = 2;
        _button_2.frame = CGRectMake(self.button_1.right+10, self.button_1.top, self.button_1.width, self.button_1.height);
        [_button_2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_2;
}

- (UIButton *)button_3
{
    if (!_button_3) {
        _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_3 setTitle:@"差评" forState:UIControlStateNormal];
        [_button_3 setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_button_3 setTitleColor:BlueLeverColor1 forState:UIControlStateSelected];
        _button_3.titleLabel.font = Font(12);
        _button_3.layer.cornerRadius = 4;
        _button_3.layer.borderWidth = .5;
        _button_3.tag = 3;
        _button_3.frame = CGRectMake(self.button_2.right+10, self.button_2.top, self.button_2.width, self.button_2.height);
        [_button_3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_3;
}

- (UIButton *)button_4
{
    if (!_button_4) {
        _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_4 setTitle:@"有图" forState:UIControlStateNormal];
        [_button_4 setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_button_4 setTitleColor:BlueLeverColor1 forState:UIControlStateSelected];
        _button_4.titleLabel.font = Font(12);
        _button_4.layer.cornerRadius = 4;
        _button_4.layer.borderWidth = .5;
        _button_4.tag = 4;
        _button_4.frame = CGRectMake(self.button_3.right+10, self.button_3.top, self.button_3.width, self.button_3.height);
        [_button_4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button_4;
}

@end
