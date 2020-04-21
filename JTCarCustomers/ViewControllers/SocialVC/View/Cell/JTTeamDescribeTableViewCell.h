//
//  JTTeamDescribeTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *discribCellIdentifier = @"JTTeamDescribeTableViewCell";

@interface JTTeamDescribeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *bottomLB;

- (void)configTableViewCellTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
