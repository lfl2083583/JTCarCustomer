//
//  JTStoreServiceTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreSeviceModel.h"

static NSString *storeServiceIndentifier = @"JTStoreServiceTableViewCell";

@class JTStoreServiceTableViewCell;

@protocol JTStoreServiceTableViewCellDelegate <NSObject>

- (void)storeServiceTableViewCell:(JTStoreServiceTableViewCell *)storeServiceTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath didEditAtStatus:(BOOL)status;
- (void)storeServiceTableViewCell:(JTStoreServiceTableViewCell *)storeServiceTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath didChoiceAtStatus:(BOOL)status;

@end

@interface JTStoreServiceTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *choiceBT;
@property (strong, nonatomic) UIButton *editBT;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *priceLB;
@property (strong, nonatomic) UILabel *goodsPriceLB;
@property (strong, nonatomic) UILabel *worksPriceLB;
@property (strong, nonatomic) UILabel *detailLB;

@property (copy, nonatomic) JTStoreSeviceModel *model;
@property (weak, nonatomic) id<JTStoreServiceTableViewCellDelegate> delegate;
@property (copy, nonatomic) NSIndexPath *indexPath;
@end
