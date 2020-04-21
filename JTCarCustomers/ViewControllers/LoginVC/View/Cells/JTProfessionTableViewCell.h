//
//  JTProfessionTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *professionCellId = @"JTProfessionTableViewCell";

@interface JTProfessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLB;

@end
