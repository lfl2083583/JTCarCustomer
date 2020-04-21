//
//  JTSessionGroupTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionGroupIdentifier = @"JTSessionGroupTableViewCell";

@interface JTSessionGroupTableViewCell : JTSessionTableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatar;
@property (nonatomic, strong) UILabel *callLB;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *noteLB;

@end
