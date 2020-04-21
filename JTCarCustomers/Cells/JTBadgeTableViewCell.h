//
//  JTBadgeTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTBadgeView.h"


static NSString *badgeIdentifier = @"JTBadgeTableViewCell";

@interface JTBadgeTableViewCell : UITableViewCell

@property (nonatomic, strong) JTBadgeView *badgeView;
@property (nonatomic, assign) NSInteger bedgeNum;
@end
