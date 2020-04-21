//
//  JTTeamInfoTableHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamInfoHandle.h"
#import "JTTeamInfoTableHeadView.h"
@interface JTTeamInfoTableHeadView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapRecongnizer;
@property (nonatomic, assign) BOOL isGroupMain;

@end

@implementation JTTeamInfoTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.coverImgeView];
        [self addSubview:self.topLB];
        [self addSubview:self.bottomLB];
        [self addSubview:self.rightBtn];
        [self addSubview:self.bottomBtn];
    }
    return self;
}

- (void)setDistance:(NSDictionary *)distance {
    _distance = distance;
    if (distance && [distance isKindOfClass:[NSDictionary class]]) {
         [self.bottomBtn setTitle:[NSString stringWithFormat:@"%@(%@)",distance[@"address"], distance[@"distance"]] forState:UIControlStateNormal];
    }
}

- (void)setTeam:(NIMTeam *)team {
    _team = team;
    if (team && [team isKindOfClass:[NIMTeam class]]) {
        self.isGroupMain = [self.team.owner isEqualToString:[JTUserInfo shareUserInfo].userYXAccount];
        [self.coverImgeView setUrlImages:@[[[self rechangeTeamAvatar:self.team.avatarUrl] avatarHandleWithSquare:App_Frame_Width]]];
        self.bottomLB.text = [NSString stringWithFormat:@"群号：%@",team.teamId];
        NSString *teamName = team.teamName?team.teamName:@"";
        NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:teamName];
        
        if (self.isGroupMain) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.bounds = CGRectMake(10, -2, 20, 19);
            attach.image = [UIImage imageNamed:@"group_edit"];
            NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
            [atributeStr insertAttributedString:strAtt atIndex:teamName.length];
        }
        
        JTTeamCategoryType category = [JTTeamInfoHandle showTeamCategoryWithTeam:team];
        if (category) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.bounds = CGRectMake(5, -2, 32, 16);
            attach.image = [JTTeamInfoHandle showTeamCategoryImage:category];
            NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
            [atributeStr insertAttributedString:strAtt atIndex:teamName.length];
        }
        self.topLB.attributedText = atributeStr;
    }
}

- (void)bottomBtnClick:(id)sender {
    if (_isGroupMain && _delegate && [_delegate respondsToSelector:@selector(teamInfoViewEditeTeamInfo)]) {
        [_delegate teamInfoViewEditeTeamInfo];
    }
}

- (void)tapRecongnizerEvent:(UITapGestureRecognizer *)sender {
    
    if (_isGroupMain && _delegate && [_delegate respondsToSelector:@selector(teamInfoViewEditeTeamInfo)]) {
        [_delegate teamInfoViewEditeTeamInfo];
    }
}

- (void)rightBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(teamInfoViewQRCode)]) {
        [_delegate teamInfoViewQRCode];
    }
}

- (UITapGestureRecognizer *)tapRecongnizer {
    if (!_tapRecongnizer) {
        _tapRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecongnizerEvent:)];
        _tapRecongnizer.numberOfTapsRequired = 1;
    }
    return _tapRecongnizer;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(22, self.bounds.size.height-100, self.bounds.size.width-100, 25)];
        _topLB.font = Font(18);
        _topLB.textColor = WhiteColor;
        _topLB.userInteractionEnabled = YES;
        [_topLB addGestureRecognizer:self.tapRecongnizer];
    }
    return _topLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.topLB.frame)+5, self.bounds.size.height-100, 20)];
        _bottomLB.font = Font(14);
        _bottomLB.textColor = WhiteColor;
        _bottomBtn.userInteractionEnabled = YES;
        [_bottomBtn addGestureRecognizer:self.tapRecongnizer];
    }
    return _bottomLB;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, self.bounds.size.height-40, self.bounds.size.height-100, 20)];
        _bottomBtn.titleLabel.font = Font(15);
        [_bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        _bottomBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bottomBtn setImage:[UIImage imageNamed:@"group_location"] forState:UIControlStateNormal];
        _bottomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-60, self.bounds.size.height-105, 40, 40)];
        [_rightBtn setImage:[UIImage imageNamed:@"center_qr_icon"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


- (KCarouselView *)coverImgeView {
    if (!_coverImgeView) {
        _coverImgeView = [[KCarouselView alloc] init];
        _coverImgeView.frame = self.bounds;
        _coverImgeView.showPageControl = NO;
    }
    return _coverImgeView;
}

- (NSString *)rechangeTeamAvatar:(NSString *)avatarUrl {
    NSString *urlStr = @"";
    if (avatarUrl && [avatarUrl isKindOfClass:[NSString class]]) {
        if ([avatarUrl containsString:@"https://"]) {
             urlStr = [avatarUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
        }else {
             urlStr = avatarUrl;
        }
    }
    return urlStr;
}
@end

@implementation JTTeamInfoTableFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.centerBtn];
    }
    return self;
}

- (void)centerBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(teamInfoViewApplyJoin)]) {
        [_delegate teamInfoViewApplyJoin];
    }
}

- (JTGradientButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = [[JTGradientButton alloc] initWithFrame:CGRectMake((self.width - 300) / 2.0, 20, 300 , 45)];
        _centerBtn.titleLabel.font = Font(16);
        [_centerBtn setTitle:@"申请加入" forState:UIControlStateNormal];
        [_centerBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}
@end
