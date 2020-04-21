//
//  JTSimpleStoreGoodsTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTAlignmentLabel.h"
#import "JTStoreGoodsModel.h"

static NSString *simpleStoreGoodsIndentifier = @"JTSimpleStoreGoodsTableViewCell";

@interface JTSimpleStoreGoodsTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *cover;
@property (strong, nonatomic) ZTAlignmentLabel *titleLB;
@property (strong, nonatomic) UILabel *priceLB;

@property (copy, nonatomic) JTStoreGoodsModel *model;

@end
