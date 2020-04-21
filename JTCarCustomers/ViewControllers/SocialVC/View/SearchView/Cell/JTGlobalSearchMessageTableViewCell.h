//
//  JTGlobalSearchMessageTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

static NSString *globalSearchMessageIdentifier = @"JTGlobalSearchMessageTableViewCell";

@interface JTGlobalSearchMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *horizontalView;


@end
