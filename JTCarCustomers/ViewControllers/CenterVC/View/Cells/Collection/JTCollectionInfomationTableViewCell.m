//
//  JTCollectionInfomationTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionInfomationTableViewCell.h"

@implementation JTCollectionInfomationTableViewCell

- (UIImageView *)contentImage
{
    if (!_contentImage) {
        _contentImage = [[UIImageView alloc] init];
        _contentImage.contentMode = UIViewContentModeScaleAspectFill;
        _contentImage.clipsToBounds = YES;
    }
    return _contentImage;
}

- (UILabel *)infomationTitle {
    if (!_infomationTitle) {
        _infomationTitle = [[UILabel alloc] init];
        _infomationTitle.font = Font(16);
        _infomationTitle.textColor = BlackLeverColor6;
    }
    return _infomationTitle;
}

- (UILabel *)infomationDetail {
    if (!_infomationDetail) {
        _infomationDetail = [[UILabel alloc] init];
        _infomationDetail.font = Font(14);
        _infomationDetail.numberOfLines = 2;
        _infomationDetail.textColor = BlackLeverColor3;
    }
    return _infomationDetail;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.contentImage];
    [self.bottomView addSubview:self.infomationTitle];
    [self.bottomView addSubview:self.infomationDetail];
}

- (void)setViewAtuoLayout
{
    [super setViewAtuoLayout];
    __weak typeof(self) weakself = self;
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLB.mas_left);
        make.top.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(weakself.titleLB.mas_top).with.offset(-10);
    }];
    
    [self.infomationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.top.equalTo(@(26));
        make.right.equalTo(weakself.mas_right).offset(-18);
        make.height.mas_equalTo(20);
    }];
    
    [self.infomationDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.right.equalTo(weakself.mas_right).offset(-18);
        make.top.equalTo(weakself.infomationTitle.mas_bottom).offset(10);
    }];
    
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSString *url = [model.infoDic objectForKey:@"image"] ? [model.infoDic objectForKey:@"image"] : @"";
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:[url avatarHandleWithSize:CGSizeMake(160, 160)]]];
    [self.infomationTitle setText:[model.infoDic objectForKey:@"title"]];
    [self.infomationDetail setText:[model.infoDic objectForKey:@"content"]];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
