//
//  JTStoreGoodsModel.m
//  JTCarCustomers
//
//  Created by apple on 2018/5/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreGoodsModel.h"

@implementation JTStoreGoodsModel

- (id)copyWithZone:(nullable NSZone *)zone {
    JTStoreGoodsModel *model = [[[self class] allocWithZone:zone] init];
    model.goodsID = [_goodsID copy];
    model.coverUrlString = [_coverUrlString copy];
    model.name = [_name copy];
    model.num = _num;
    model.stock = _stock;
    model.price = _price;
    return model;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodsID"          : @"goods_id",
             @"coverUrlString"   : @"goods_image",
             @"name"             : @"goods_name",
             @"num"              : @"goods_number",
             @"stock"            : @"goods_stock",
             @"price"            : @"sales_price",
             };
}
@end
