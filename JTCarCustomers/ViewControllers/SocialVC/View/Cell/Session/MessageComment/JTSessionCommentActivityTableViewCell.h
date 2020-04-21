//
//  JTSessionCommentActivityTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTCommentActivityAttachment.h"
#import "JTCommentInformationAttachment.h"
@protocol JTSessionCommentActivityTableViewCellDelegate <NSObject>

- (void)sessionCommentActivityTableViewCellAvatarClick:(NSIndexPath *)indexPath;
- (void)sessionCommentActivityTableViewCellContentClick:(NSIndexPath *)indexPath;
- (void)sessionCommentActivityTableViewCellCoverClick:(NSIndexPath *)indexPath;


@end

static NSString *sessionCommentActivityIdentifer = @"JTSessionCommentActivityTableViewCell";

@interface JTSessionCommentActivityTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatarView;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *centerLB;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UIImageView *rightImgeView;
@property (nonatomic, strong) UIView *bottomView;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) id attachment;
@property (weak, nonatomic) id<JTSessionCommentActivityTableViewCellDelegate>delegate;

@end
