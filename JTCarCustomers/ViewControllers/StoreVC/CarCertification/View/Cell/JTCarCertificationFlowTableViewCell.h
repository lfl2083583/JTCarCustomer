//
//  JTCarCertificationFlowTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTCarCertificationEntryTableViewCellDelegate <NSObject>

- (void)recognizeLicence;

@end

static NSString *const carCertificationEntryIdentifier = @"JTCarCertificationEntryTableViewCell";
static NSString *const carCertificationDescribeIdentifier = @"JTCarCertificationDescribeTableViewCell";

@interface JTCarCertificationEntryTableViewCell : UITableViewCell

@property (nonatomic, weak) id<JTCarCertificationEntryTableViewCellDelegate>delegate;

@end

@interface JTCarCertificationDescribeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *describeLB;


@end

