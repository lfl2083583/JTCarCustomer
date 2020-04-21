//
//  JTStoreGoodsListViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreGoodsListViewController.h"
#import "JTSimpleStoreGoodsTableViewCell.h"

@interface JTStoreGoodsListViewController () <UITableViewDataSource>

@end

@implementation JTStoreGoodsListViewController

- (instancetype)initWithClassID:(NSString *)classID goodsID:(NSString *)goodsID selectCompletion:(void (^)(JTStoreGoodsModel *))selectCompletion
{
    self = [super init];
    if (self) {
        _classID = classID;
        _goodsID = goodsID;
        _selectCompletion = selectCompletion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"可更换产品"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:90 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTSimpleStoreGoodsTableViewCell class] forCellReuseIdentifier:simpleStoreGoodsIndentifier];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetReplaceGoodsApi) parameters:@{@"type": self.classID, @"goods_id": self.goodsID} success:^(id responseObject, ResponseState state) {
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:[JTStoreGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        }
        [weakself.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTSimpleStoreGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleStoreGoodsIndentifier];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectCompletion) {
        self.selectCompletion(self.dataArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
