//
//  JTOrderConfig.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTOrderConfig.h"

@implementation JTOrderConfig

- (void)setOrder:(id)order {
    _order = order;
    if (self.orderType == JTOrderTypeLiftTrailer ||
        self.orderType == JTOrderTypeLiftElectricity)
    {
        NSMutableDictionary *mudict1 = [NSMutableDictionary dictionary];
        [mudict1 setValue:@"服务项目详情" forKey:kSectionTitle];
        JTWordItem *item1 = [self buildItem:@"位置" subtitle:@"坂田街道" cellHeight:35];
        JTWordItem *item2 = [self buildItem:@"服务项目" subtitle:@"搭电" cellHeight:35];
        JTWordItem *item3 = [self buildItem:@"预约时间" subtitle:@"05-09 14:00" cellHeight:35];
        NSArray *array1 = @[item1, item2, item3];
        [mudict1 setValue:array1 forKey:kItems];
        
        NSMutableDictionary *mudict2 = [NSMutableDictionary dictionary];
        [mudict2 setValue:@"订单信息" forKey:kSectionTitle];
        JTWordItem *service1 = [self buildItem:@"订单编号" subtitle:@"124680233" cellHeight:25];
        JTWordItem *service2 = [self buildItem:@"订单状态" subtitle:@"订单已取消" cellHeight:25];
        JTWordItem *service3 = [self buildItem:@"订单类型" subtitle:@"搭电" cellHeight:25];
        JTWordItem *service4 = [self buildItem:@"车型" subtitle:@"奥迪Q7" cellHeight:25];
        JTWordItem *service5 = [self buildItem:@"车牌号" subtitle:@"京 B468923" cellHeight:25];
        JTWordItem *service6 = [self buildItem:@"联系人" subtitle:@"哈哈哈" cellHeight:25];
        JTWordItem *service7 = [self buildItem:@"电话号码" subtitle:@"138 8866 6688" cellHeight:25];
        JTWordItem *service8 = [self buildItem:@"订单时间" subtitle:@"2018-05-21" cellHeight:25];
        JTWordItem *service9 = [self buildItem:@"支付方式" subtitle:@"支付宝" cellHeight:25];
        JTWordItem *service10 = [self buildItem:@"发票" subtitle:@"不需要开发票" cellHeight:25];
        NSArray *array2 = @[service1, service2, service3, service4, service5, service6, service7, service8, service9, service10];
        [mudict2 setValue:array2 forKey:kItems];
        
        [self.itemArray addObjectsFromArray:@[mudict1, mudict2]];
        
    }
    else
    {
        
    }
}


- (JTWordItem *)buildItem:(NSString *)title subtitle:(NSString *)subtitle cellHeight:(CGFloat)cellHeight {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.subTitle = subtitle;
    item.cellHeight = cellHeight;
    item.titleFont = (cellHeight > 25)?Font(16):Font(14);
    return item;
}


- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
