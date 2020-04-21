//
//  JTActivityCommentTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTGenderGradeImageView.h"

static NSString *commentIdentifier = @"JTActivityCommentTableViewCell";

@protocol JTActivityCommentTableViewCellDelegate <NSObject>

- (void)activityCommentCellCommentContentResponse:(NSIndexPath *)indexPath;
- (void)activityCommentCellReplyContentResponse:(NSIndexPath *)indexPath;

@end

@interface JTActivityCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatarView;
@property (nonatomic, strong) JTGenderGradeImageView *genterView;
@property (nonatomic, strong) UILabel *userNameLB;
@property (nonatomic, strong) UILabel *commentLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *replyNameLB;
@property (nonatomic, strong) UILabel *replyLB;
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIView *horizontalView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<JTActivityCommentTableViewCellDelegate>delegate;

- (void)configJTActivityCommentTableViewCellCommentInfo:(id)commentInfo indexPath:(NSIndexPath *)indexPath;
@end
