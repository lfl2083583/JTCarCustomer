//
//  JTSessionBonusTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionBonusIdentifier = @"JTSessionBonusTableViewCell";

@interface JTSessionBonusTableViewCell : JTSessionTableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *subTitleLB;
@property (nonatomic, strong) UILabel *noteLB;

@end
