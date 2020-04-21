//
//  JTCarCertificationHelpTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const carCertificationHelpIdentifier = @"JTCarCertificationHelpTableViewCell";

@interface JTCarCertificationHelpTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *subtitleLB;

@property (nonatomic, strong) id source;

@end
