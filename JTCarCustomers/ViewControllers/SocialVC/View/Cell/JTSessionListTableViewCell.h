//
//  JTSessionListTableViewCell.h
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTBadgeView.h"

static NSString *sessionListIdentifier = @"JTSessionListTableViewCell";

@class NIMRecentSession;

@interface JTSessionListTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) JTBadgeView *badgeView;

@property (nonatomic, strong) UIImageView *messageNoDisturbIcon;

- (void)configWithSessionListTableViewCell:(NIMRecentSession *)recent;

@end
