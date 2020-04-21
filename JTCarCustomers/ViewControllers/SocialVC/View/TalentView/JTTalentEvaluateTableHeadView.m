//
//  JTTalentEvaluateTableHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define KBottomLineW (self.width-150)/2.0
#import "JTTalentEvaluateTableHeadView.h"

@interface JTTalentEvaluateTableHeadView ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation JTTalentEvaluateTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = @[@"您的评价会让达人做的更好" , @"非常不满意，聊天有障碍", @"不满意，比较差", @"一般，还需要改善", @"比较满意，仍可改善", @"非常满意，无可挑剔"];
        [self addSubview:self.avatarView];
        [self addSubview:self.topLB];
        [self addSubview:self.bottomLB];
        [self addSubview:self.leftView];
        [self addSubview:self.centerLB];
        [self addSubview:self.rightView];
        [self addSubview:self.starView];
        [self addSubview:self.discribLB];
        
        __weak typeof(self)weakSelf = self;
        self.starView.onStart = ^(NSInteger score) {
            [weakSelf.discribLB setText:weakSelf.titleArray[score]];
            if (_delegate && [_delegate respondsToSelector:@selector(talentEvaluateWithScore:)]) {
                [weakSelf.delegate talentEvaluateWithScore:score];
            }
        };
    }
    return self;
}

- (void)setTalentInfo:(id)talentInfo {
    _talentInfo = talentInfo;
    if (talentInfo && [talentInfo isKindOfClass:[NSDictionary class]]) {
        [self.avatarView setAvatarByUrlString:[talentInfo[@"avatar"] avatarHandleWithSquare:120] defaultImage:DefaultSmallAvatar];
        self.topLB.text = [NSString stringWithFormat:@"%@",talentInfo[@"name"]];
        NSInteger timeType = [talentInfo[@"time_type"] integerValue];
        NSString *service = (timeType == 0)?@"24h":[NSString stringWithFormat:@"%@-%@h", talentInfo[@"start_time"], talentInfo[@"end_time"]];
        
        NSString *content = [NSString stringWithFormat:@"综合评分：%@分  %@", talentInfo[@"praise"], service];
        NSString *serveTime = [NSString stringWithFormat:@"%@", service];
        self.bottomLB.text = content;
        [Utility richTextLabel:self.bottomLB fontNumber:Font(12) andRange:NSMakeRange(content.length-serveTime.length, serveTime.length) andColor:BlackLeverColor3];
    }
}


- (UILabel *)discribLB {
    if (!_discribLB) {
        _discribLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.starView.frame)+10, App_Frame_Width, 20)];
        _discribLB.textAlignment = NSTextAlignmentCenter;
        _discribLB.font = Font(14);
        _discribLB.textColor = UIColorFromRGB(0xfd955a);
        _discribLB.text = self.titleArray[0];
    }
    return _discribLB;
}

- (JTStarView *)starView {
    if (!_starView) {
        _starView = [[JTStarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.centerLB.frame)+10, App_Frame_Width, 40)];
    }
    return _starView;
}

- (ZTCirlceImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(25, 20, 60, 60)];
    }
    return _avatarView;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(105, 27, self.width-110, 25)];
        _topLB.font = Font(18);
        _topLB.textColor = BlackLeverColor5;
    }
    return _topLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(105, CGRectGetMaxY(self.topLB.frame), self.width-110, 17)];
        _bottomLB.font = Font(12);
        _bottomLB.textColor = UIColorFromRGB(0xfc9153);
    }
    return _bottomLB;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.avatarView.frame)+18, KBottomLineW, 1)];
        _leftView.backgroundColor = BlackLeverColor2;
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(self.width-KBottomLineW-30, CGRectGetMaxY(self.avatarView.frame)+18, KBottomLineW, 1)];
        _rightView.backgroundColor = BlackLeverColor2;
    }
    return _rightView;
}

- (UILabel *)centerLB {
    if (!_centerLB) {
        _centerLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftView.frame), CGRectGetMaxY(self.bottomLB.frame)+19, 65, 17)];
        _centerLB.centerX = self.centerX;
        _centerLB.centerY = self.leftView.centerY;
        _centerLB.font = Font(12);
        _centerLB.textColor = BlackLeverColor3;
        _centerLB.text = @"为沟通打分";
    }
    return _centerLB;
}

@end


@implementation JTTalentEvaluateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImgeView];
        [self addSubview:self.centerLB];
    }
    return self;
}

- (UIImageView *)topImgeView {
    if (!_topImgeView) {
        _topImgeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 100) / 2.0, 80, 100, 100)];
        _topImgeView.image = [UIImage imageNamed:@"center_real_sucess"];
    }
    return _topImgeView;
}

- (UILabel *)centerLB {
    if (!_centerLB) {
        _centerLB = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.topImgeView.frame) + 20, self.width - 40, 22)];
        _centerLB.textAlignment = NSTextAlignmentCenter;
        _centerLB.font = Font(16);
        _centerLB.textColor = BlueLeverColor1;
        _centerLB.text = @"感谢评价";
    }
    return _centerLB;
}


@end
