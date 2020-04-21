//
//  JTSessionTeamTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTTeamInviteAttachment.h"
#import "JTTeamInviteRefuseAttachment.h"
#import "JTTeamApplyAttachment.h"
#import "JTTeamApplyRefuseAttachment.h"
#import "JTTeamRemoveAttachment.h"
#import "JTTeamDismissAttachment.h"

static NSString *sessionTeamIdentifier = @"JTSessionTeamTableViewCell";

@interface JTSessionTeamTableViewCell : UITableViewCell

@property (strong, nonatomic) ZTCirlceImageView *avatar;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *contentLB;
@property (strong, nonatomic) UILabel *remarksLB;
@property (strong, nonatomic) UILabel *statusLB;

@property (strong, nonatomic) id<NIMCustomAttachment> attachment;

@end
