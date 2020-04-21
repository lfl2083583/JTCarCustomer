//
//  JTStoreEditGoodsTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreGoodsModel.h"

static NSString *storeEditGoodsIndentifier = @"JTStoreEditGoodsTableViewCell";

typedef NS_ENUM(NSInteger, JTStoreEditGoodsType) {
    JTStoreEditGoodsTypeReduce,
    JTStoreEditGoodsTypeAdd,
    JTStoreEditGoodsTypeDelete,
    JTStoreEditGoodsTypeReplace
};

@class JTStoreEditGoodsTableViewCell;

@protocol JTStoreEditGoodsTableViewCellDelegate <NSObject>

- (void)storeEditGoodsTableViewCell:(JTStoreEditGoodsTableViewCell *)storeEditGoodsTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath didEditGoodsType:(JTStoreEditGoodsType)editGoodsType;

@end

@interface JTStoreEditGoodsTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIImageView *cover;
@property (strong, nonatomic) UIImageView *editView;
@property (strong, nonatomic) UIButton *reduceBT;
@property (strong, nonatomic) UILabel *numLB;
@property (strong, nonatomic) UIButton *addBT;
@property (strong, nonatomic) UIButton *deleteBT;
@property (strong, nonatomic) UIButton *replaceBT;

@property (copy, nonatomic) JTStoreGoodsModel *model;
@property (weak, nonatomic) id<JTStoreEditGoodsTableViewCellDelegate> delegate;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) NSInteger currentNum;

@end
