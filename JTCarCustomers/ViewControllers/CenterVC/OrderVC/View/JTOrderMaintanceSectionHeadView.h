//
//  JTOrderMaintanceSectionHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const orderMaintanceSectionHeadIdentifier = @"JTOrderMaintanceSectionHeadView";

@interface JTOrderMaintanceSectionHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *statusLB;

@end
