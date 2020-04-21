//
//  JTStoreGoodsModel.h
//  JTCarCustomers
//
//  Created by apple on 2018/5/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTStoreGoodsModel : NSObject <NSCopying>

@property (copy, nonatomic) NSString *goodsID;          // 商品ID
@property (copy, nonatomic) NSString *coverUrlString;   // 商品封面
@property (copy, nonatomic) NSString *name;             // 商品名称
@property (assign, nonatomic) NSInteger num;            // 数量
@property (assign, nonatomic) NSInteger stock;          // 库存
@property (assign, nonatomic) CGFloat price;            // 价格

@end
