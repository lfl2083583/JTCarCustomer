//
//  JTStoreSeviceModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTStoreGoodsModel.h"

@interface JTStoreSeviceModel : NSObject <NSMutableCopying>

@property (copy, nonatomic) NSString *serviceID;         // 服务ID
@property (copy, nonatomic) NSString *classID;           // 小分类ID
@property (copy, nonatomic) NSString *mainID;            // 大分类ID
@property (assign, nonatomic) BOOL disable;              // 是否可选
@property (assign, nonatomic) BOOL status;               // 服务状态(1正常，0服务商品库存不足)
@property (copy, nonatomic) NSString *name;              // 服务名称
@property (copy, nonatomic) NSString *introduce;         // 服务介绍
@property (assign, nonatomic) float maxPrice;            // 没车时，最高服务价格
@property (assign, nonatomic) float minPrice;            // 没车时，最低服务价格
@property (assign, nonatomic) float price;               // 有车时，服务价格
@property (assign, nonatomic) float maxGoodsPrice;       // 没车时，最高商品价格
@property (assign, nonatomic) float minGoodsPrice;       // 没车时，最低商品价格
@property (assign, nonatomic) float goodsPrice;          // 有车时，商品价格
@property (assign, nonatomic) float maxWorksPrice;       // 没车时，最高工时价格
@property (assign, nonatomic) float minWorksPrice;       // 没车时，最低工时价格
@property (assign, nonatomic) float worksPrice;          // 有车时，工时价格
@property (copy, nonatomic) NSArray<JTStoreGoodsModel *> *storeGoodsModel;

@property (assign, nonatomic) CGRect bottomFrame;
@property (assign, nonatomic) CGRect choiceFrame;
@property (assign, nonatomic) CGRect editFrame;
@property (assign, nonatomic) CGRect titleFrame;
@property (assign, nonatomic) CGRect priceFrame;
@property (assign, nonatomic) CGRect goodsPriceFrame;
@property (assign, nonatomic) CGRect worksPriceFrame;
@property (assign, nonatomic) CGRect detailFrame;

@property (assign, nonatomic) CGFloat cellHeight;

@end
