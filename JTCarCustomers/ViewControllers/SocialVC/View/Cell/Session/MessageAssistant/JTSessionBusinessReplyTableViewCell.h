//
//  JTSessionBusinessReplyTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionBusinessReplyIdentifier = @"JTSessionBusinessReplyTableViewCell";

@interface JTSessionBusinessReplyTableViewCell : JTSessionTableViewCell

@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *contentLB;

@end
