//
//  JTMutiUserTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/8/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

static NSString *mutiUserIdentifier = @"JTMutiUserTableViewCell";

@interface JTMutiUserTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *choiceBT;
@property (nonatomic, strong) ZTCirlceImageView *avatarImageView;
@property (nonatomic, strong) UILabel *detailLB;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NIMUser *user;
@end
