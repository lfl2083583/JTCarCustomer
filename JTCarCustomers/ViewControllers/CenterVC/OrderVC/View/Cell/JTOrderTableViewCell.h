//
//  JTOrderTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const orderIdentifier = @"JTOrderTableViewCell";

@interface JTOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *detailLB;
@property (nonatomic, strong) UILabel *statusLB;
@property (nonatomic, strong) UILabel *timeLB;

@end
