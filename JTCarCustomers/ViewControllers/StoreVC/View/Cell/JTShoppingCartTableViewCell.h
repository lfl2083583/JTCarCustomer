//
//  JTShoppingCartTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreSeviceModel.h"

@class JTShoppingCartTableViewCell;

static NSString *shoppingCartIndentifier = @"JTShoppingCartTableViewCell";

@protocol JTShoppingCartTableViewCellDelegate <NSObject>

- (void)shoppingCartTableViewCell:(JTShoppingCartTableViewCell *)shoppingCartTableViewCell didDeleteAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JTShoppingCartTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *priceLB;
@property (strong, nonatomic) UILabel *goodsPriceLB;
@property (strong, nonatomic) UILabel *worksPriceLB;
@property (strong, nonatomic) UIButton *deleteBT;

@property (copy, nonatomic) JTStoreSeviceModel *model;
@property (assign, nonatomic) id<JTShoppingCartTableViewCellDelegate> delegate;
@property (copy, nonatomic) NSIndexPath *indexPath;

@end
