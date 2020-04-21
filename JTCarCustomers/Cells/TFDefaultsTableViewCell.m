//
//  TFDefaultsTableViewCell.m
//  StockMobile
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TFDefaultsTableViewCell.h"

@implementation TFDefaultsTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setInputMax:MAX_CANON];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initSubview];
    }
    return self;
}

- (UITextField *)contentTF
{
    if (!_contentTF) {
        _contentTF = [[UITextField alloc] init];
        _contentTF.font = Font(16);
        _contentTF.textColor = BlackLeverColor5;
        _contentTF.frame = CGRectMake(15, 0, App_Frame_Width-30, self.height);
    }
    return _contentTF;
}

- (void)initSubview
{
    [self addSubview:self.contentTF];
    [self.contentTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)textFieldEditChanged:(UITextField *)textField {
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > self.inputMax) {
                textField.text = [toBeString substringToIndex:self.inputMax];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else {
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        if (toBeString.length > self.inputMax) {
            textField.text = [toBeString substringToIndex:self.inputMax];
        }
    }
    if ([self.delegate respondsToSelector:@selector(text:changeEditingAtIndexPath:)]) {
        [self.delegate text:textField.text changeEditingAtIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)clear
{
    self.contentTF.text = @"";
}
@end
