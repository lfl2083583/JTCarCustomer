//
//  JTOrderSectionHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const orderSectionHeadIdentifier = @"JTOrderSectionHeadView";

@interface JTOrderSectionHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIView *horizontalView;

@end
