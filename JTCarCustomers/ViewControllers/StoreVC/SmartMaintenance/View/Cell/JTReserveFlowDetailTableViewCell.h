//
//  JTReserveFlowDetailTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const reserveFlowDetailIdentifer = @"JTReserveFlowDetailTableViewCell";

@interface JTDashLineView : UIView

@end

@interface JTReserveFlowDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) JTDashLineView *flowView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *subtitleLB;

@end
