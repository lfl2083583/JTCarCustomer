//
//  JTSessionMoneyBonusReturnTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionMoneyBonusReturnIdentifier = @"JTSessionMoneyBonusReturnTableViewCell";

@interface JTSessionMoneyBonusReturnTableViewCell : JTSessionTableViewCell

@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *messageTimeLB;
@property (strong, nonatomic) UILabel *moneyLB;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *reasonLB;
@property (strong, nonatomic) UILabel *reasonValueLB;
@property (strong, nonatomic) UILabel *theMoneyTimeLB;
@property (strong, nonatomic) UILabel *theMoneyTimeValueLB;
@property (strong, nonatomic) UILabel *remarksLB;
@property (strong, nonatomic) UILabel *remarksValueLB;

@property (strong, nonatomic) UIView *line_2;
@property (strong, nonatomic) UILabel *lookDetailLB;
@property (strong, nonatomic) UIImageView *arrowIcon;

@end
