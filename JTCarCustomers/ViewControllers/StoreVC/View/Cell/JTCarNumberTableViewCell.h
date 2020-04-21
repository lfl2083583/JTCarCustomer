//
//  JTCarNumberTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "TFDefaultsTableViewCell.h"

@class JTCarNumberTableViewCell;

@protocol JTCarNumberTableViewCellDelegate <NSObject>

- (void)carNumberTableViewCellAtChoiceAlias:(JTCarNumberTableViewCell *)carNumberTableViewCell;

@end


static NSString *carNumberIndentifier = @"JTCarNumberTableViewCell";

@interface JTCarNumberTableViewCell : TFDefaultsTableViewCell

@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UIImageView *arrow;
@property (weak, nonatomic) id<JTCarNumberTableViewCellDelegate> carNumberTableViewCellDelegate;
@end
