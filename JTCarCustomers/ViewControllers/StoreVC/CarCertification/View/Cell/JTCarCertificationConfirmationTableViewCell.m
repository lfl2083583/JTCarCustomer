//
//  JTCarCertificationConfirmationTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarCertificationConfirmationTableViewCell.h"

@interface JTCarCertificationConfirmationTableViewCell () <UITextFieldDelegate>

@end

@implementation JTCarCertificationConfirmationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.detailTF];
        
        __weak typeof(self)weakSelf = self;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(22);
            make.height.mas_equalTo(20);
        }];
        
        [self.detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLB.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(20);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(5);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-22);
        }];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(textUI:startEditingAtIndexPath:)]) {
        [_delegate textUI:textField startEditingAtIndexPath:self.indexPath];
    }
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(14);
        _titleLB.textColor = BlackLeverColor3;
    }
    return _titleLB;
}

- (UITextField *)detailTF {
    if (!_detailTF) {
        _detailTF = [[UITextField alloc] init];
        _detailTF.font = Font(16);
        _detailTF.textColor = BlackLeverColor6;
        _detailTF.delegate = self;
    }
    return _detailTF;
}

@end
