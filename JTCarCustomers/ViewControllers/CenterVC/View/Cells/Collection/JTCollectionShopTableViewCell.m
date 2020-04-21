//
//  JTcollectionShopTableViewCell.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionShopTableViewCell.h"

@implementation JTCollectionShopTableViewCell

- (UIImageView *)contentImage
{
    if (!_contentImage) {
        _contentImage = [[UIImageView alloc] init];
        _contentImage.contentMode = UIViewContentModeScaleAspectFill;
        _contentImage.clipsToBounds = YES;
    }
    return _contentImage;
}

- (UILabel *)shopNameLB {
    if (!_shopNameLB) {
        _shopNameLB = [[UILabel alloc] init];
        _shopNameLB.font = Font(16);
        _shopNameLB.textColor = BlackLeverColor6;
    }
    return _shopNameLB;
}

- (UILabel *)businessHoursLB {
    if (!_businessHoursLB) {
        _businessHoursLB = [[UILabel alloc] init];
        _businessHoursLB.font = Font(10);
        _businessHoursLB.textColor = BlackLeverColor3;
    }
    return _businessHoursLB;
}

- (UILabel *)siteLB {
    if (!_siteLB) {
        _siteLB = [[UILabel alloc] init];
        _siteLB.font = Font(12);
        _siteLB.textColor = BlackLeverColor3;
    }
    return _siteLB;
}

- (ZTStarView *)starView {
    if (!_starView) {
        _starView = [[ZTStarView alloc] initWithFrame:CGRectMake(0, 0, 50, 12)];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

- (void)initSubview
{
    [super initSubview];
    [self.bottomView addSubview:self.contentImage];
    [self.bottomView addSubview:self.shopNameLB];
    [self.bottomView addSubview:self.starView];
    [self.bottomView addSubview:self.businessHoursLB];
    [self.bottomView addSubview:self.siteLB];
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
    
    [self.shopNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.top.equalTo(@(28));
        make.right.equalTo(weakself.mas_right).offset(-18);
        make.height.mas_equalTo(20);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.top.equalTo(weakself.shopNameLB.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 12));
    }];
    
    [self.businessHoursLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.starView.mas_right).offset(5);
        make.right.equalTo(weakself.mas_right).offset(-18);
        make.centerY.equalTo(weakself.starView.mas_centerY);
    }];
    
    [self.siteLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentImage.mas_right).offset(15);
        make.top.equalTo(weakself.starView.mas_bottom).offset(5);
        make.right.equalTo(weakself.mas_right).offset(-18);
    }];
}

- (void)setModel:(JTCollectionModel *)model
{
    [super setModel:model];
    NSString *url = [model.infoDic objectForKey:@"image"] ? [model.infoDic objectForKey:@"image"] : @"";
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:[url avatarHandleWithSize:CGSizeMake(160, 160)]]];
    [self.shopNameLB setText:[model.infoDic objectForKey:@"store_name"]];
    [self.starView setScore:MIN([[model.infoDic objectForKey:@"score"] floatValue], 5.0)/5 withAnimation:YES];
    [self.businessHoursLB setText:[NSString stringWithFormat:@"%@ 营业时间：%@", [model.infoDic objectForKey:@"score"], [model.infoDic objectForKey:@"time"]]];
    [self.siteLB setText:[NSString stringWithFormat:@"%@", [model.infoDic objectForKey:@"address"]]];
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
