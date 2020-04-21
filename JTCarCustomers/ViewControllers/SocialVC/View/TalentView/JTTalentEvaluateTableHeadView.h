//
//  JTTalentEvaluateTableHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JTStarView.h"
#import "ZTCirlceImageView.h"

@protocol JTTalentEvaluateTableHeadViewDelegate <NSObject>

- (void)talentEvaluateWithScore:(NSInteger)score;

@end


@interface JTTalentEvaluateTableHeadView : UIView

@property (nonatomic, strong) JTStarView *starView;
@property (nonatomic, strong) ZTCirlceImageView *avatarView;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UILabel *centerLB;
@property (nonatomic, strong) UILabel *discribLB;

@property (nonatomic, strong) id talentInfo;
@property (nonatomic, weak) id<JTTalentEvaluateTableHeadViewDelegate>delegate;


@end


@interface JTTalentEvaluateView : UIView

@property (nonatomic, strong) UIImageView *topImgeView;
@property (nonatomic, strong) UILabel *centerLB;

@end
