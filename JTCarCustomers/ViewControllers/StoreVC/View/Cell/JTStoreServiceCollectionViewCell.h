//
//  JTStoreServiceCollectionViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreSeviceModel.h"
#import "JTStoreServiceLiveModel.h"
#import "JTStoreServiceMaintainModel.h"

static NSString *storeServiceCollectionIndentifier = @"JTStoreServiceCollectionViewCell";

@class JTStoreServiceCollectionViewCell;

@protocol JTStoreServiceCollectionViewCellDelegate <NSObject>

- (void)storeServiceCollectionViewCell:(JTStoreServiceCollectionViewCell *)storeServiceCollectionViewCell didChangeAtHeight:(CGFloat)height;
- (void)refreshDataInstoreServiceCollectionViewCell:(JTStoreServiceCollectionViewCell *)storeServiceCollectionViewCell;

@end

@interface JTStoreServiceCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UITableView *tableview;
@property (weak, nonatomic) id<JTStoreServiceCollectionViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL isMulti;
@property (assign, nonatomic) BOOL isClear;
@property (copy, nonatomic) NSMutableDictionary<NSString *, JTStoreSeviceModel *> *choiceDictionary;
@property (copy, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *mainDictionary;
@property (copy, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *classDictionary;
@property (copy, nonatomic) NSMutableArray<NSString *> *editArray;
@property (copy, nonatomic) NSMutableArray<JTStoreServiceLiveModel *> *storeSeviceLiveModels;
@property (copy, nonatomic) NSMutableArray<JTStoreSeviceModel *> *storeSeviceModels;
@property (copy, nonatomic) NSMutableArray<JTStoreServiceMaintainModel *> *storeServiceMaintainModels;
@end
