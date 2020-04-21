//
//  JTActivityCardHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityCardHeadView.h"

@interface JTActivityCardHeadView ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *siteLB;
@property (nonatomic, strong) UILabel *themeLB;
@property (nonatomic, strong) UILabel *postLB;

@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation JTActivityCardHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLB = [self createLabelWithRect:CGRectMake(20, 0, self.width-40, 28) font:[UIFont boldSystemFontOfSize:20]];
        _timeLB = [self createLabelWithRect:CGRectMake(20, CGRectGetMaxY(_titleLB.frame), self.width-40, 20) font:Font(12)];
        _siteLB = [self createLabelWithRect:CGRectMake(20, CGRectGetMaxY(_timeLB.frame), self.width-40, 20) font:Font(12)];
        _themeLB = [self createLabelWithRect:CGRectMake(20, CGRectGetMaxY(_siteLB.frame), self.width-40, 20) font:Font(12)];
        _postLB = [self createLabelWithRect:CGRectMake(20, CGRectGetMaxY(_themeLB.frame), self.width-40, 20) font:Font(12)];
        [self addSubview:self.titleLB];
        [self addSubview:self.timeLB];
        [self addSubview:self.siteLB];
        [self addSubview:self.themeLB];
        [self addSubview:self.postLB];
        [self setupSlideView];
    }
    return self;
}

- (void)setupSlideView {
    for (int i = 0; i < 3; i++) {
        UIView *slide = [[UIView alloc] initWithFrame:CGRectMake(self.width-120+25*i, CGRectGetMaxY(self.postLB.frame), 20, 3)];
        slide.backgroundColor = BlackLeverColor3;
        [self.viewArray addObject:slide];
        [self addSubview:slide];
    }
    self.slideLoction = JTSlideLoctionLeft;
}

- (void)setSlideLoction:(JTSlideLoction)slideLoction {
    _slideLoction = slideLoction;
    if (slideLoction < JTSlideLoctionUnKnow) {
        for (UIView *slide in self.viewArray) {
            slide.backgroundColor = BlackLeverColor3;
        }
        UIView *slder = self.viewArray[slideLoction];
        slder.backgroundColor = BlackLeverColor6;
    }
}

- (void)configActivityCardHeadViewWithInfo:(id)info {
    if (info && [info isKindOfClass:[NSDictionary class]]) {
        NSString *rangeStr = [NSString stringWithFormat:@"距离%@", info[@"distance"]];
        NSString *title = [NSString stringWithFormat:@"%@%@",info[@"activity_name"], rangeStr];
        self.titleLB.text = title;
        self.timeLB.text = [NSString stringWithFormat:@"时间： %@",info[@"time"]];
        self.siteLB.text = [NSString stringWithFormat:@"地点： %@",info[@"address"]];
        self.themeLB.text = [NSString stringWithFormat:@"主题： %@",info[@"theme"]];
        self.postLB.text = [NSString stringWithFormat:@"发起人： %@",info[@"initiator"]];;
        [Utility richTextLabel:self.titleLB fontNumber:Font(12) andRange:[title rangeOfString:rangeStr] andColor:BlackLeverColor3];
    }
}

- (UILabel *)createLabelWithRect:(CGRect)rect font:(UIFont *)font  {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = font;
    label.textColor = BlackLeverColor6;
    return label;
}

- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

@end
