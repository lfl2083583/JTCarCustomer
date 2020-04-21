//
//  JTImageTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *imageTableIndentifier = @"JTImageTableViewCell";

@interface JTImageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLB;

@end
