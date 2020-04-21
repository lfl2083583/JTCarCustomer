//
//  JTStoreDetailHeaderView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreDetailHeaderView.h"

@implementation JTStoreDetailHeaderView

- (instancetype)initWithStoreDetailHeaderViewDelegate:(id<JTStoreDetailHeaderViewDelegate>)storeDetailHeaderViewDelegate
{
    self = [super init];
    if (self) {
        _storeDetailHeaderViewDelegate = storeDetailHeaderViewDelegate;
        [self initSubview];
        [self setBackgroundColor:BlackLeverColor1];
        [self setFrame:CGRectMake(0, 0, App_Frame_Width, self.bottomView.bottom+10)];
    }
    return self;
}

- (void)setModel:(JTStoreModel *)model
{
    _model = model;
    [self.storeNameLB setText:model.name];
    [self.makeLB setText:model.type];
    [self.makeLB setBackgroundColor:BlueLeverColor1];
    NSString *score = [NSString stringWithFormat:@"综合评分：%@分", model.score];
    NSString *time = [NSString stringWithFormat:@"营业时间：%@", model.time];
    NSString *detail = [NSString stringWithFormat:@"%@  %@", score, time];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detail];
    [attributedString addAttribute:NSForegroundColorAttributeName value:YellowColor range:[detail rangeOfString:[NSString stringWithFormat:@"%@分", model.score]]];
    [attributedString addAttribute:NSFontAttributeName value:Font(10) range:[detail rangeOfString:time]];
    self.detailLB.attributedText = attributedString;
    self.addressLB.text = model.address;
    
    if (self.model.labels && [self.model.labels isKindOfClass:[NSArray class]] && self.model.labels.count > 0) {
        CGFloat left = self.storeNameLB.left, top = self.addressLB.bottom + 8, index = 101;
        for (NSString *str in self.model.labels) {
            CGSize size = [Utility getTextString:str textFont:Font(10) frameWidth:MAXFLOAT attributedString:nil];
            CGFloat width = size.width + 15;
            if (left + width + 15 > self.navigationBT.left) {
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
            [self addSubview:label];
            left = label.right + 5;
            index ++;
        }
    }
    [self.navigationBT setTitle:[NSString stringWithFormat:@"距您%@", model.distance] forState:UIControlStateNormal];
    [self.navigationBT centerImageAndTitle];
    [self.collectionBT setSelected:model.is_favorite];
    [self.collectionBT centerImageAndTitle];
    
    CGFloat width = [Utility getTextString:self.storeNameLB.text textFont:self.storeNameLB.font frameWidth:MAXFLOAT attributedString:nil].width;
    CGFloat makeWidth = [Utility getTextString:self.makeLB.text textFont:self.makeLB.font frameWidth:MAXFLOAT attributedString:nil].width + 10;
    CGFloat titleWidth = MIN(width, App_Frame_Width - self.storeNameLB.left - 25 - makeWidth);
    self.storeNameLB.width = titleWidth;
    self.makeLB.frame = CGRectMake(self.storeNameLB.right + 10, self.storeNameLB.top, makeWidth, 18);
}

- (void)navigationClick:(id)sender
{
    if (self.model && _storeDetailHeaderViewDelegate && [_storeDetailHeaderViewDelegate respondsToSelector:@selector(storeDetailHeaderView:didSelectHeaderAtType:)]) {
        [_storeDetailHeaderViewDelegate storeDetailHeaderView:self didSelectHeaderAtType:JTStoreDetailHeaderClickTypeNavigation];
    }
}

- (void)collectionClick:(id)sender
{
    if (self.model && _storeDetailHeaderViewDelegate && [_storeDetailHeaderViewDelegate respondsToSelector:@selector(storeDetailHeaderView:didSelectHeaderAtType:)]) {
        [_storeDetailHeaderViewDelegate storeDetailHeaderView:self didSelectHeaderAtType:JTStoreDetailHeaderClickTypeCollection];
    }
}

- (void)initSubview
{
    [self addSubview:self.bottomView];
    [self addSubview:self.storeNameLB];
    [self addSubview:self.makeLB];
    [self addSubview:self.detailLB];
    [self addSubview:[Utility initLineRect:CGRectMake(0, self.detailLB.bottom+15, App_Frame_Width, .5) lineColor:BlackLeverColor2]];
    [self addSubview:self.addressLB];
    [self addSubview:self.navigationBT];
    [self addSubview:self.collectionBT];
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WhiteColor;
        _bottomView.frame = CGRectMake(0, 0, App_Frame_Width, self.navigationBT.bottom);
    }
    return _bottomView;
}

- (UILabel *)storeNameLB
{
    if (!_storeNameLB) {
        _storeNameLB = [[UILabel alloc] init];
        _storeNameLB.textColor = BlackLeverColor6;
        _storeNameLB.font = Font(16);
        _storeNameLB.frame = CGRectMake(15, 15, App_Frame_Width-30, 18);
    }
    return _storeNameLB;
}

- (UILabel *)makeLB
{
    if (!_makeLB) {
        _makeLB = [[UILabel alloc] init];
        _makeLB.font = Font(10);
        _makeLB.textColor = WhiteColor;
        _makeLB.textAlignment = NSTextAlignmentCenter;
        _makeLB.frame = CGRectMake(self.storeNameLB.right+10, self.storeNameLB.top, 0, 18);
        _makeLB.layer.cornerRadius = 4.;
        _makeLB.clipsToBounds = YES;
    }
    return _makeLB;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.textColor = BlackLeverColor3;
        _detailLB.font = Font(12);
        _detailLB.frame = CGRectMake(self.storeNameLB.left, self.storeNameLB.bottom+2, App_Frame_Width-30, 12);
    }
    return _detailLB;
}

- (UILabel *)addressLB
{
    if (!_addressLB) {
        _addressLB = [[UILabel alloc] init];
        _addressLB.textColor = BlackLeverColor3;
        _addressLB.font = Font(10);
        _addressLB.frame = CGRectMake(self.storeNameLB.left, self.detailLB.bottom+30, self.navigationBT.left-30, 12);
    }
    return _addressLB;
}

- (ZTButtonExt *)navigationBT
{
    if (!_navigationBT) {
        _navigationBT = [ZTButtonExt buttonWithType:UIButtonTypeCustom];
        [_navigationBT setImage:[UIImage imageNamed:@"icon_navigation"] forState:UIControlStateNormal];
        _navigationBT.titleLabel.font = Font(12);
        [_navigationBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        _navigationBT.frame = CGRectMake(App_Frame_Width-152, self.detailLB.bottom+15, 76, 76);
        [_navigationBT addTarget:self action:@selector(navigationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationBT;
}

- (ZTButtonExt *)collectionBT
{
    if (!_collectionBT) {
        _collectionBT = [ZTButtonExt buttonWithType:UIButtonTypeCustom];
        [_collectionBT setTitle:@"收藏店铺" forState:UIControlStateNormal];
        [_collectionBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_collectionBT setImage:[UIImage imageNamed:@"focus_icon"] forState:UIControlStateNormal];
        [_collectionBT setTitle:@"已收藏" forState:UIControlStateSelected];
        [_collectionBT setTitleColor:BlueLeverColor1 forState:UIControlStateSelected];
        [_collectionBT setImage:[UIImage imageNamed:@"focus_seleted_icon"] forState:UIControlStateSelected];
        _collectionBT.titleLabel.font = Font(12);
        _collectionBT.frame = CGRectMake(App_Frame_Width-76, self.detailLB.bottom+15, 76, 76);
        [_collectionBT addTarget:self action:@selector(collectionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBT;
}

@end
