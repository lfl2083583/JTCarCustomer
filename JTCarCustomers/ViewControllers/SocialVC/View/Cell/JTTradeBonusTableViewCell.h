//
//  JTTradeBonusTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/9/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *tradeBonusIdentifier = @"JTTradeBonusTableViewCell";

@interface JTTradeBonusTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) UILabel *moneyLB;
@property (strong, nonatomic) UILabel *detailLB;

@end
