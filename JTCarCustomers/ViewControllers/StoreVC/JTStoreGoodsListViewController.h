//
//  JTStoreGoodsListViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTStoreSeviceModel.h"

@interface JTStoreGoodsListViewController : BaseRefreshViewController

@property (copy, nonatomic) NSString *classID;
@property (copy, nonatomic) NSString *goodsID;
@property (copy, nonatomic) void (^selectCompletion)(JTStoreGoodsModel *model);

- (instancetype)initWithClassID:(NSString *)classID goodsID:(NSString *)goodsID selectCompletion:(void (^)(JTStoreGoodsModel *model))selectCompletion;

@end
