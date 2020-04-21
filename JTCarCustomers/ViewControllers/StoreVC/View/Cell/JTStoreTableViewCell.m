//
//  JTStoreTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreTableViewCell.h"

@implementation JTStoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self.contentView addSubview:self.coverImage];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.makeLB];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.scoreLB];
    [self.contentView addSubview:self.distanceLB];
    [self.contentView addSubview:self.addressLB];
}

- (void)setModel:(JTStoreModel *)model
{
    _model = model;
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[model.logo avatarHandleWithSquare:160]]];
    [self.titleLB setText:model.name];
    [self.makeLB setText:model.type];
    [self.makeLB setBackgroundColor:BlueLeverColor1];
    [self.starView setScore:[model.score floatValue] / 5 withAnimation:YES];
    [self.scoreLB setText:model.score];
    [self.distanceLB setText:[NSString stringWithFormat:@"距离%@", model.distance]];
    [self.addressLB setText:model.address];
    for (UIView *view in self.contentView.subviews) {
        if (view.tag > 100) {
            [view setHidden:YES];
            [view removeFromSuperview];
        }
    }
    if (self.model.labels && [self.model.labels isKindOfClass:[NSArray class]] && self.model.labels.count > 0) {
        CGFloat left = self.titleLB.left, top = self.addressLB.bottom + 8, index = 101;
        for (NSString *str in self.model.labels) {
            CGSize size = [Utility getTextString:str textFont:Font(10) frameWidth:MAXFLOAT attributedString:nil];
            CGFloat width = size.width + 10;
            if (left + width + 10 > App_Frame_Width) {
                break;
            }
            UILabel *label = [[UILabel alloc] init];
            label.text = str;
            label.font = Font(10);
            label.textColor = BlueLeverColor5;
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(left, top, width, 18);
            label.layer.cornerRadius = 4.;
            label.layer.borderColor = BlueLeverColor5.CGColor;
            label.layer.borderWidth = .5f;
            label.clipsToBounds = YES;
            label.tag = index;
            [self.contentView addSubview:label];
            left = label.right + 10;
            index ++;
        }
    }
    
    CGFloat width = [Utility getTextString:self.titleLB.text textFont:self.titleLB.font frameWidth:MAXFLOAT attributedString:nil].width;
    CGFloat makeWidth = [Utility getTextString:self.makeLB.text textFont:self.makeLB.font frameWidth:MAXFLOAT attributedString:nil].width + 10;
    CGFloat titleWidth = MIN(width, App_Frame_Width - self.titleLB.left - 25 - makeWidth);
    self.titleLB.width = titleWidth;
    self.makeLB.frame = CGRectMake(self.titleLB.right + 10, self.coverImage.top, makeWidth, 18);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIImageView *)coverImage
{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.contentMode = UIViewContentModeScaleAspectFill;
        _coverImage.clipsToBounds = YES;
        _coverImage.frame = CGRectMake(15, 15, 80, 80);
        _coverImage.layer.cornerRadius = 4.f;
    }
    return _coverImage;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
        _titleLB.frame = CGRectMake(self.coverImage.right + 10, self.coverImage.top, 0, 18);
    }
    return _titleLB;
}

- (UILabel *)makeLB
{
    if (!_makeLB) {
        _makeLB = [[UILabel alloc] init];
        _makeLB.font = Font(10);
        _makeLB.textColor = WhiteColor;
        _makeLB.textAlignment = NSTextAlignmentCenter;
        _makeLB.frame = CGRectMake(self.titleLB.right + 10, self.coverImage.top, 0, 18);
        _makeLB.layer.cornerRadius = 4.;
        _makeLB.clipsToBounds = YES;
    }
    return _makeLB;
}

- (ZTStarView *)starView
{
    if (!_starView) {
        _starView = [[ZTStarView alloc] initWithFrame:CGRectMake(self.titleLB.left, self.titleLB.bottom + 8, 50, 12)
                                         numberOfStar:5];
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

- (UILabel *)scoreLB
{
    if (!_scoreLB) {
        _scoreLB = [[UILabel alloc] init];
        _scoreLB.font = Font(12);
        _scoreLB.textColor = BlackLeverColor3;
        _scoreLB.frame = CGRectMake(self.starView.right + 5, self.starView.top, 30, self.starView.height);
    }
    return _scoreLB;
}

- (UILabel *)distanceLB
{
    if (!_distanceLB) {
        _distanceLB = [[UILabel alloc] init];
        _distanceLB.font = Font(12);
        _distanceLB.textColor = BlackLeverColor3;
        _distanceLB.frame = CGRectMake(self.scoreLB.right + 5, self.starView.top, 100, self.starView.height);
    }
    return _distanceLB;
}

- (UILabel *)addressLB
{
    if (!_addressLB) {
        _addressLB = [[UILabel alloc] init];
        _addressLB.font = Font(12);
        _addressLB.textColor = BlackLeverColor3;
        _addressLB.frame = CGRectMake(self.titleLB.left, self.starView.bottom + 8, App_Frame_Width - self.titleLB.left - 15, 12);
    }
    return _addressLB;
}

@end
