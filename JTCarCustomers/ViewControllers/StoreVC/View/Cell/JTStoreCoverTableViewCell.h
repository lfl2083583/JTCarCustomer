//
//  JTStoreCoverTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *storeCoverIndentifier = @"JTStoreCoverTableViewCell";

@interface JTStoreCoverTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UIScrollView *scrollview;

@property (copy, nonatomic) NSArray *coverImages;

@end
