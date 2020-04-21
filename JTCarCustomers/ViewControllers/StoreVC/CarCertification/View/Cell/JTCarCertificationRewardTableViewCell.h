//
//  JTCarCertificationRewardTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const carCertificationRewardIdentifier = @"JTCarCertificationRewardTableViewCell";

@interface JTCarCertificationRewardTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *giftView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *subtitleLB;
@property (nonatomic, strong) UIButton *rightBtn;

@end
