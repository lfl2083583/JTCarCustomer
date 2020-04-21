//
//  JTOrderExtensionTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderBaseTableViewCell.h"

static NSString *const orderExtensionIdentifier = @"JTOrderExtensionTableViewCell";

@interface JTOrderExtensionTableViewCell : JTOrderBaseTableViewCell

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end
