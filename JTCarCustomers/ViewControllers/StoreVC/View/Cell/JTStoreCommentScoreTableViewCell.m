//
//  JTStoreCommentScoreTableViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreCommentScoreTableViewCell.h"

@implementation JTStoreCommentScoreTableViewCell

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
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.scoreLB];
    [self.bottomView addSubview:self.promptLB];
    [self.bottomView addSubview:self.storefrontPromptLB];
    [self.bottomView addSubview:self.storefrontStarView];
    [self.bottomView addSubview:self.storefrontScoreLB];
    [self.bottomView addSubview:self.technologyPromptLB];
    [self.bottomView addSubview:self.technologyStarView];
    [self.bottomView addSubview:self.technologyScoreLB];
    [self.bottomView addSubview:self.servicePromptLB];
    [self.bottomView addSubview:self.serviceStarView];
    [self.bottomView addSubview:self.serviceScoreLB];
}

- (void)setModel:(JTStoreCommentScoreModel *)model
{
    _model = model;
    self.scoreLB.text = model.score;
    [self.storefrontStarView setScore:[model.environment floatValue] / 5 withAnimation:YES];
    self.storefrontScoreLB.text = model.environment;
    [self.technologyStarView setScore:[model.skill floatValue] / 5 withAnimation:YES];
    self.technologyScoreLB.text = model.skill;
    [self.serviceStarView setScore:[model.service floatValue] / 5 withAnimation:YES];
    self.serviceScoreLB.text = model.service;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake((App_Frame_Width-220)/2, 0, 220, 80);
    }
    return _bottomView;
}

- (UILabel *)scoreLB
{
    if (!_scoreLB) {
        _scoreLB = [[UILabel alloc] init];
        _scoreLB.textColor = YellowColor;
        _scoreLB.font = BoldFont(36);
        _scoreLB.frame = CGRectMake(0, 5, 80, 50);
    }
    return _scoreLB;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] init];
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.font = Font(14);
        _promptLB.frame = CGRectMake(0, self.scoreLB.bottom, 80, 15);
        _promptLB.text = @"商家评分";
    }
    return _promptLB;
}

- (UILabel *)storefrontPromptLB
{
    if (!_storefrontPromptLB) {
        _storefrontPromptLB = [[UILabel alloc] init];
        _storefrontPromptLB.textColor = BlackLeverColor3;
        _storefrontPromptLB.font = Font(12);
        _storefrontPromptLB.frame = CGRectMake(80, 12, 50, 12);
        _storefrontPromptLB.text = @"店面环境";
    }
    return _storefrontPromptLB;
}

- (ZTStarView *)storefrontStarView
{
    if (!_storefrontStarView) {
        _storefrontStarView = [[ZTStarView alloc] initWithFrame:CGRectMake(self.storefrontPromptLB.right+5, self.storefrontPromptLB.top, 50, self.storefrontPromptLB.height) numberOfStar:5];
        _storefrontStarView.userInteractionEnabled = NO;
    }
    return _storefrontStarView;
}

- (UILabel *)storefrontScoreLB
{
    if (!_storefrontScoreLB) {
        _storefrontScoreLB = [[UILabel alloc] init];
        _storefrontScoreLB.textColor = BlackLeverColor3;
        _storefrontScoreLB.font = Font(12);
        _storefrontScoreLB.frame = CGRectMake(self.storefrontStarView.right+5, self.storefrontStarView.top, 30, self.storefrontPromptLB.height);
    }
    return _storefrontScoreLB;
}

- (UILabel *)technologyPromptLB
{
    if (!_technologyPromptLB) {
        _technologyPromptLB = [[UILabel alloc] init];
        _technologyPromptLB.textColor = BlackLeverColor3;
        _technologyPromptLB.font = Font(12);
        _technologyPromptLB.frame = CGRectMake(self.storefrontPromptLB.left, self.storefrontPromptLB.bottom+10, self.storefrontPromptLB.width, self.storefrontPromptLB.height);
        _technologyPromptLB.text = @"技术能力";
    }
    return _technologyPromptLB;
}

- (ZTStarView *)technologyStarView
{
    if (!_technologyStarView) {
        _technologyStarView = [[ZTStarView alloc] initWithFrame:CGRectMake(self.technologyPromptLB.right+5, self.technologyPromptLB.top, 50, self.technologyPromptLB.height) numberOfStar:5];
        _technologyStarView.userInteractionEnabled = NO;
    }
    return _technologyStarView;
}

- (UILabel *)technologyScoreLB
{
    if (!_technologyScoreLB) {
        _technologyScoreLB = [[UILabel alloc] init];
        _technologyScoreLB.textColor = BlackLeverColor3;
        _technologyScoreLB.font = Font(12);
        _technologyScoreLB.frame = CGRectMake(self.technologyStarView.right+5, self.technologyStarView.top, 30, self.technologyStarView.height);
    }
    return _technologyScoreLB;
}

- (UILabel *)servicePromptLB
{
    if (!_servicePromptLB) {
        _servicePromptLB = [[UILabel alloc] init];
        _servicePromptLB.textColor = BlackLeverColor3;
        _servicePromptLB.font = Font(12);
        _servicePromptLB.frame = CGRectMake(self.technologyPromptLB.left, self.technologyPromptLB.bottom+10, self.technologyPromptLB.width, self.technologyPromptLB.height);
        _servicePromptLB.text = @"服务态度";
    }
    return _servicePromptLB;
}

- (ZTStarView *)serviceStarView
{
    if (!_serviceStarView) {
        _serviceStarView = [[ZTStarView alloc] initWithFrame:CGRectMake(self.servicePromptLB.right+5, self.servicePromptLB.top, 50, self.servicePromptLB.height) numberOfStar:5];
        _serviceStarView.userInteractionEnabled = NO;
    }
    return _serviceStarView;
}

- (UILabel *)serviceScoreLB
{
    if (!_serviceScoreLB) {
        _serviceScoreLB = [[UILabel alloc] init];
        _serviceScoreLB.textColor = BlackLeverColor3;
        _serviceScoreLB.font = Font(12);
        _serviceScoreLB.frame = CGRectMake(self.serviceStarView.right+5, self.serviceStarView.top, 30, self.serviceStarView.height);
    }
    return _serviceScoreLB;
}

@end
