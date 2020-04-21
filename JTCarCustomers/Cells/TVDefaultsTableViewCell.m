//
//  TVDefaultsTableViewCell.m
//  StockMobile
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TVDefaultsTableViewCell.h"

@implementation TVDefaultsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    self.contentTV = [[GCPlaceholderTextView alloc] init];
    self.contentTV.font = Font(15);
    self.contentTV.frame = CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height);
    self.contentTV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    self.contentTV.textColor = BlackLeverColor5;
    [self addSubview:self.contentTV];
    self.contentTV.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.delegate respondsToSelector:@selector(textUI:startEditingAtIndexPath:)]) {
        [self.delegate textUI:textView startEditingAtIndexPath:self.indexPath];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    if ([self.delegate respondsToSelector:@selector(text:changeEditingAtIndexPath:)]) {
        [self.delegate text:textView changeEditingAtIndexPath:self.indexPath];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textUI:stopEditingAtIndexPath:)]) {
        [self.delegate textUI:textView stopEditingAtIndexPath:self.indexPath];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([self.delegate respondsToSelector:@selector(textUI:shouldReturnAtIndexPath:)]) {
        [self.delegate textUI:textView shouldReturnAtIndexPath:self.indexPath];
    }
    return YES;
}

- (void)clear
{
    self.contentTV.text = @"";
}
@end
