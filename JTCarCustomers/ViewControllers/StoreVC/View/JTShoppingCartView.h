//
//  JTShoppingCartView.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreSeviceModel.h"
#import "JTStoreSeviceClassModel.h"

@interface JTShoppingCartView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat maxHeight;
}

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *cleanBT;
@property (copy, nonatomic) NSMutableArray<JTStoreSeviceClassModel *> *storeSeviceClassModels;;
@property (copy, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *mainDictionary;
@property (copy, nonatomic) void(^deleteModel)(JTStoreSeviceModel *model);
@property (copy, nonatomic) void(^cleanModels)(void);

- (instancetype)initWithFrame:(CGRect)frame storeSeviceClassModels:(NSMutableArray<JTStoreSeviceClassModel *> *)storeSeviceClassModels mainDictionary:(NSMutableDictionary<NSString *, NSMutableArray *> *)mainDictionary deleteModel:(void (^)(JTStoreSeviceModel *model))deleteModel cleanModels:(void (^)(void))cleanModels;

@end
