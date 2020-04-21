//
//  JTOrderExtensionTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderExtensionTableViewCell.h"

@implementation JTOrderExtensionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];
        
        __weak typeof(self)weakself = self;
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.contentView.mas_left).offset(15);
            make.top.equalTo(weakself.contentView.mas_top).offset(13);
            make.width.mas_equalTo((App_Frame_Width-45)/2.0);
            make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-13);
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.leftBtn.mas_right).offset(15);
            make.right.equalTo(weakself.contentView.mas_right).offset(-15);
            make.top.equalTo(weakself.contentView.mas_top).offset(13);
            make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-13);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.layer.cornerRadius = 4;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.backgroundColor = BlueLeverColor2;
        _leftBtn.titleLabel.numberOfLines = 0;
        _leftBtn.titleLabel.font = Font(14);
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_leftBtn setTitle:@"接车记录\n暂未开放  敬请期待" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [Utility richTextLabel:_leftBtn.titleLabel fontNumber:Font(16) andRange:[@"接车记录\n暂未开放  敬请期待" rangeOfString:@"接车记录"] andColor:WhiteColor];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.layer.cornerRadius = 4;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.backgroundColor = UIColorFromRGB(0xfbd249);
        _rightBtn.titleLabel.numberOfLines = 0;
        _rightBtn.titleLabel.font = Font(14);
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rightBtn setTitle:@"检测报告\n暂未开放  敬请期待" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [Utility richTextLabel:_rightBtn.titleLabel fontNumber:Font(16) andRange:[@"检测报告\n暂未开放  敬请期待" rangeOfString:@"检测报告"] andColor:WhiteColor];
    }
    return _rightBtn;
}

@end
