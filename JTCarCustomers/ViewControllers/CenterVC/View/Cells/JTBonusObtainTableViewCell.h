//
//  JTBonusObtainTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *bonusObtainCellIdentifier = @"JTBonusObtainTableViewCell";

@interface JTBonusObtainTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftTopLB;
@property (nonatomic, strong) UILabel *leftBottomLB;
@property (nonatomic, strong) UILabel *rightTopLB;
@property (nonatomic, strong) UILabel *rightBottomLB;

@end
