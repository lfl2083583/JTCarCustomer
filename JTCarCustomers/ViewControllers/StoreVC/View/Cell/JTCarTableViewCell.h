//
//  JTCarTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *carIndentifier = @"JTCarTableViewCell";

@class JTCarTableViewCell;

@protocol JTCarNumberTableViewCellDelegate <NSObject>

- (void)carTableViewCell:(JTCarTableViewCell *)carTableViewCell carOperationType:(JTCarOperationType)carOperationType;

@end

@interface JTCarTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIImageView *carIcon;
@property (strong, nonatomic) UILabel *carModelLB;
@property (strong, nonatomic) UILabel *carNamelLB;
@property (strong, nonatomic) UILabel *carNumberLB;
@property (strong, nonatomic) UIButton *carStatusBT;
@property (strong, nonatomic) UIButton *carDefaultBT;
@property (strong, nonatomic) UIButton *carDeleteBT;
@property (strong, nonatomic) UIButton *carEditBT;

@property (weak, nonatomic) id<JTCarNumberTableViewCellDelegate> delegate;
@property (copy, nonatomic) JTCarModel *model;
@end
