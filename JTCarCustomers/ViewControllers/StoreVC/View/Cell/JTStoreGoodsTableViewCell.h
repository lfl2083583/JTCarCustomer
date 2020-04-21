//
//  JTStoreGoodsTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/5/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTAlignmentLabel.h"
#import "JTStoreGoodsModel.h"

static NSString *storeGoodsIndentifier = @"JTStoreGoodsTableViewCell";

@interface JTStoreGoodsTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIImageView *cover;
@property (strong, nonatomic) ZTAlignmentLabel *titleLB;
@property (strong, nonatomic) UILabel *priceLB;
@property (strong, nonatomic) UILabel *numLB;

@property (copy, nonatomic) JTStoreGoodsModel *model;

@end
