//
//  JTOrderServiceTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const orderServiceIdentifier = @"JTOrderServiceTableViewCell";

@interface JTOrderServiceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *subtitleLB;

@end
