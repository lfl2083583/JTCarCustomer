//
//  JTSessionFunsTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTFunsAttachment.h"

@class JTSessionFunsTableViewCell;

static NSString *sessionFunsIdentifier = @"JTSessionFunsTableViewCell";

@protocol JTSessionFunsTableViewCellDelegate <NSObject>
@optional

- (void)sessionFunsTableViewCell:(JTSessionFunsTableViewCell *)sessionFunsTableViewCell clickInAvatarAtUserID:(NSString *)userID;
@end

@interface JTSessionFunsTableViewCell : UITableViewCell

@property (strong, nonatomic) ZTCirlceImageView *avatar;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *contentLB;

@property (copy, nonatomic) JTFunsAttachment *attachment;
@property (weak, nonatomic) id<JTSessionFunsTableViewCellDelegate> delegate;
@end
