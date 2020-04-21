//
//  JTSessionActivityPromptTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionActivityPromptIdentifier = @"JTSessionActivityPromptTableViewCell";

@interface JTSessionActivityPromptTableViewCell : JTSessionTableViewCell

@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *contentLB;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *noteLB;
@property (strong, nonatomic) UIImageView *arrowIcon;

@end
