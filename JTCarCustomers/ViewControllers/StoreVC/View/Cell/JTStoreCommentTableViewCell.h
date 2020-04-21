//
//  JTStoreCommentTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "ZTStarView.h"
#import "JTStoreCommentModel.h"

static NSString *storeCommentIndentifier = @"JTStoreCommentTableViewCell";

@interface JTStoreCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) ZTCirlceImageView *avatar;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) ZTStarView *starView;
@property (strong, nonatomic) UILabel *scoreLB;
@property (strong, nonatomic) UILabel *commentLB;
@property (strong, nonatomic) NSMutableArray<UIImageView *> *imageViews;
@property (strong, nonatomic) UILabel *detailLB;
@property (strong, nonatomic) UIImageView *replyBottom;
@property (strong, nonatomic) UILabel *replyLB;

@property (copy, nonatomic) JTStoreCommentModel *model;
@end
