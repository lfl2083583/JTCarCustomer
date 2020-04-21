//
//  JTStoreCommentScoreTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTStarView.h"
#import "JTStoreCommentScoreModel.h"

static NSString *storeCommentScoreIndentifier = @"JTStoreCommentScoreTableViewCell";

@interface JTStoreCommentScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *scoreLB;
@property (strong, nonatomic) UILabel *promptLB;

@property (strong, nonatomic) UILabel *storefrontPromptLB;
@property (strong, nonatomic) ZTStarView *storefrontStarView;
@property (strong, nonatomic) UILabel *storefrontScoreLB;

@property (strong, nonatomic) UILabel *technologyPromptLB;
@property (strong, nonatomic) ZTStarView *technologyStarView;
@property (strong, nonatomic) UILabel *technologyScoreLB;

@property (strong, nonatomic) UILabel *servicePromptLB;
@property (strong, nonatomic) ZTStarView *serviceStarView;
@property (strong, nonatomic) UILabel *serviceScoreLB;

@property (copy, nonatomic) JTStoreCommentScoreModel *model;
@end
