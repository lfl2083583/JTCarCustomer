//
//  JTTFTitleTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTFTitleTableViewCell.h"

@interface JTTFTitleTableViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JTTFTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITextField *rightField = [self.contentView viewWithTag:31];
    [rightField addTarget:self action:@selector(rightFieldChange:) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)rightFieldChange:(UITextField *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(titleTableViewCellTfChanged:indexPath:)]) {
        [_delegate titleTableViewCellTfChanged:sender.text indexPath:self.indexPath];
    }
}

- (void)configCellTitle:(NSString *)title subtitle:(NSString *)subtitle placeHolder:(NSString *)placeHolder indexPath:(NSIndexPath *)indexPath textfieldEnable:(BOOL)flag{
    
    UILabel *leftLabel = [self.contentView viewWithTag:30];
    UITextField *rightField = [self.contentView viewWithTag:31];
    leftLabel.text = title;
    rightField.placeholder = placeHolder;
    self.indexPath = indexPath;
    rightField.enabled = flag;
    if (subtitle && [subtitle isKindOfClass:[NSString class]] && subtitle.length) {
        rightField.text = subtitle;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
