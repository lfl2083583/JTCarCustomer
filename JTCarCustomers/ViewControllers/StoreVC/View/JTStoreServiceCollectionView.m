//
//  JTStoreServiceCollectionView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceCollectionView.h"
#import "JTStoreServiceCollectionViewCell.h"
#import "JTStoreServiceCollectionHeaderView.h"
#import "JTBadgeTableViewCell.h"
#import "JTStoreServiceCollectionFooterView.h"
#import "JTShoppingCartView.h"
#import "JTCarModel.h"
#import "JTStoreServiceLiveModel.h"
#import "JTStoreServiceMaintainModel.h"
#import "JTAppointmentViewController.h"

@interface JTStoreServiceCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, JTStoreServiceCollectionViewCellDelegate, UITableViewDelegate, UITableViewDataSource, JTStoreServiceCollectionFooterViewDelegate>
{
    BOOL isLoading;
    NSInteger itemHeight;
}

@property (strong, nonatomic) JTStoreServiceCollectionHeaderView *headerView;
@property (strong, nonatomic) JTStoreServiceCollectionFooterView *footerView;
@property (strong, nonatomic) UITableView *leftTableView;
@property (copy, nonatomic) JTCarModel *carModel;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;  // 集合所有类别数据
@property (strong, nonatomic) NSMutableDictionary *choiceDictionary;// 集合所选服务
@property (strong, nonatomic) NSMutableDictionary *mainDictionary;  // 选择的类别对应的集合（主类）
@property (strong, nonatomic) NSMutableDictionary *classDictionary; // 选择的类别对应的集合（保养）
@property (strong, nonatomic) NSMutableArray *editArray;            // 编辑的子分类集合
@property (strong, nonatomic) NSMutableArray *serviceLiveArray;     // 直播集合
@property (strong, nonatomic) NSMutableArray *serviceItemArray;     // 服务集合
@property (strong, nonatomic) NSMutableArray *serviceMaintainArray; // 保养集合
@property (assign, nonatomic) BOOL isMulti;
@property (assign, nonatomic) NSInteger index;

@end

@implementation JTStoreServiceCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setup];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyCarListNotification:) name:kUpdateMyCarListNotification object:nil];
        [self updateMyCarListNotification:nil];
        [self registerClass:[JTStoreServiceCollectionViewCell class] forCellWithReuseIdentifier:storeServiceCollectionIndentifier];
        [self addSubview:self.headerView];
        [self.leftTableView registerClass:[JTBadgeTableViewCell class] forCellReuseIdentifier:badgeIdentifier];
        [self addSubview:self.leftTableView];
        [self addSubview:self.footerView];
    }
    return self;
}

- (void)updateMyCarListNotification:(NSNotification *)notification {
    JTCarModel *model = ([JTUserInfo shareUserInfo].myCarList.count > 0) ? [[JTUserInfo shareUserInfo].myCarList objectAtIndex:0] : nil;
    if (![self.carModel isEqual:model] || (model && self.carModel && ![self.carModel.carID isEqualToString:model.carID])) {
        self.carModel = model;
        self.headerView.model = model;
    }
    if (notification) {
        self.footerView.icon.image = [UIImage imageNamed:@"icon_shoppingCart_normal"];
        self.footerView.allPrice = 0;
        self.footerView.workPrice = 0;
        [self.dataDictionary removeAllObjects];
        [self.choiceDictionary removeAllObjects];
        [self.mainDictionary removeAllObjects];
        [self.classDictionary removeAllObjects];
        [self.editArray removeAllObjects];
        self.index = self.index;
        self.leftTableView.frame = CGRectMake(0, self.headerView.height, 100, self.height-self.headerView.height-self.footerView.height-44);
    }
}

- (void)setup {
    self.backgroundColor = BlackLeverColor1;
    self.dataSource = self;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)setStoreSeviceClassModels:(NSMutableArray<JTStoreSeviceClassModel *> *)storeSeviceClassModels
{
    _storeSeviceClassModels = storeSeviceClassModels;
    [self.leftTableView reloadData];
    if (!isLoading && storeSeviceClassModels.count > 0) {
        isLoading = YES;
        self.index = 0;
    }
}

- (void)handleResponseObject:(id)responseObject
{
    [self.serviceLiveArray removeAllObjects];
    [self.serviceItemArray removeAllObjects];
    [self.serviceMaintainArray removeAllObjects];
    if ([responseObject objectForKey:@"live"] && [responseObject[@"live"] isKindOfClass:[NSArray class]]) {
        [self.serviceLiveArray addObjectsFromArray:[JTStoreServiceLiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"live"]]];
    }
    if ([responseObject objectForKey:@"service"] && [responseObject[@"service"] isKindOfClass:[NSArray class]]) {
        [self.serviceItemArray addObjectsFromArray:[JTStoreSeviceModel mj_objectArrayWithKeyValuesArray:responseObject[@"service"]]];
    }
    if ([responseObject objectForKey:@"maintain"] && [responseObject[@"maintain"] isKindOfClass:[NSArray class]]) {
        [self.serviceMaintainArray addObjectsFromArray:[JTStoreServiceMaintainModel mj_objectArrayWithKeyValuesArray:responseObject[@"maintain"]]];
    }
    [self setIsMulti:[[responseObject objectForKey:@"multi"] boolValue]];
    [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    if ([self.dataDictionary objectForKey:@(index)]) {
        [self handleResponseObject:[self.dataDictionary objectForKey:@(index)]];
    }
    else
    {
        __weak typeof(self) weakself = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetStoreCategoryServiceApi) parameters:@{@"store_id": self.storeID?self.storeID:@"", @"c_id": [[self.storeSeviceClassModels objectAtIndex:index] classID], @"car_id": self.carModel?self.carModel.carID:@""} success:^(id responseObject, ResponseState state) {
            [weakself handleResponseObject:responseObject];
            [weakself.dataDictionary setObject:responseObject forKey:@(weakself.index)];
        } failure:^(NSError *error) {
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTStoreServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:storeServiceCollectionIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.isMulti = self.isMulti;
    cell.isClear = YES;
    cell.choiceDictionary = self.choiceDictionary;
    cell.mainDictionary = self.mainDictionary;
    cell.classDictionary = self.classDictionary;
    cell.editArray = self.editArray;
    cell.storeSeviceLiveModels = self.serviceLiveArray;
    cell.storeSeviceModels = self.serviceItemArray;
    cell.storeServiceMaintainModels = self.serviceMaintainArray;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.headerView.height, 100, 80, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width - 100, itemHeight);
}

- (void)storeServiceCollectionViewCell:(JTStoreServiceCollectionViewCell *)storeServiceCollectionViewCell didChangeAtHeight:(CGFloat)height {
    itemHeight = MAX(height, self.leftTableView.height);
    [self reloadData];
}

- (void)refreshDataInstoreServiceCollectionViewCell:(JTStoreServiceCollectionViewCell *)storeServiceCollectionViewCell
{
    [self reloadSetOrUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storeSeviceClassModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTBadgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:badgeIdentifier];
    cell.textLabel.font = Font(14);
    cell.textLabel.textColor = (indexPath.row == self.index) ? BlackLeverColor6 : BlackLeverColor3;
    cell.textLabel.text = [[self.storeSeviceClassModels objectAtIndex:indexPath.row] className];
    cell.bedgeNum = [self.mainDictionary objectForKey:[[self.storeSeviceClassModels objectAtIndex:indexPath.row] classID]] ? [[self.mainDictionary objectForKey:[[self.storeSeviceClassModels objectAtIndex:indexPath.row] classID]] count] : 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self]) {
        self.headerView.top = MAX(scrollView.contentOffset.y+44, 0);
        self.leftTableView.top = MAX(scrollView.contentOffset.y+self.headerView.height+44, self.headerView.height);
        self.footerView.top = scrollView.contentOffset.y+self.height-80;
    }
}

- (void)shoppingCartInStoreServiceCollectionFooterView:(JTStoreServiceCollectionFooterView *)storeServiceCollectionFooterView
{
    BOOL isUnDisplayShoppingCart = NO;
    for (UIView *view in [Utility currentViewController].navigationController.view.subviews) {
        if ([view isKindOfClass:[JTShoppingCartView class]]) {
            [view setHidden:YES];
            [view removeFromSuperview];
            isUnDisplayShoppingCart = YES;
            break;
        }
    }
    if (!isUnDisplayShoppingCart && self.mainDictionary.count > 0) {
        __weak typeof(self) weakself = self;
        JTShoppingCartView *shoppingCartView = [[JTShoppingCartView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-self.footerView.height) storeSeviceClassModels:self.storeSeviceClassModels mainDictionary:self.mainDictionary deleteModel:^(JTStoreSeviceModel *model) {
            [weakself.choiceDictionary removeObjectForKey:model.serviceID];
            [weakself reloadSetOrUI];
        } cleanModels:^{
            [weakself.choiceDictionary removeAllObjects];
            [weakself reloadSetOrUI];
        }];
        [[Utility currentViewController].navigationController.view addSubview:shoppingCartView];
    }    
}

- (void)makeAnAppointmentInStoreServiceCollectionFooterView:(JTStoreServiceCollectionFooterView *)storeServiceCollectionFooterView
{
    if (self.mainDictionary.allValues.count > 0) {
        [[Utility currentViewController].navigationController pushViewController:[[JTAppointmentViewController alloc] init] animated:YES];
    }
}

- (JTStoreServiceCollectionHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTStoreServiceCollectionHeaderView alloc] init];
        _headerView.backgroundColor = WhiteColor;
    }
    return _headerView;
}

- (JTStoreServiceCollectionFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[JTStoreServiceCollectionFooterView alloc] initWithFrame:CGRectMake(0, self.contentOffset.y+self.height-80, self.width, 80) delegate:self];
    }
    return _footerView;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, 100, self.height-self.headerView.height-self.footerView.height-44) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _leftTableView;
}

- (NSMutableDictionary *)dataDictionary
{
    if (!_dataDictionary) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

- (NSMutableDictionary *)choiceDictionary
{
    if (!_choiceDictionary) {
        _choiceDictionary = [NSMutableDictionary dictionary];
    }
    return _choiceDictionary;
}

- (NSMutableDictionary *)mainDictionary
{
    if (!_mainDictionary) {
        _mainDictionary = [NSMutableDictionary dictionary];
    }
    return _mainDictionary;
}

- (NSMutableDictionary *)classDictionary
{
    if (!_classDictionary) {
        _classDictionary = [NSMutableDictionary dictionary];
    }
    return _classDictionary;
}

- (NSMutableArray *)editArray
{
    if (!_editArray) {
        _editArray = [NSMutableArray array];
    }
    return _editArray;
}

- (NSMutableArray *)serviceItemArray
{
    if (!_serviceItemArray) {
        _serviceItemArray = [NSMutableArray array];
    }
    return _serviceItemArray;
}

- (NSMutableArray *)serviceLiveArray
{
    if (!_serviceLiveArray) {
        _serviceLiveArray = [NSMutableArray array];
    }
    return _serviceLiveArray;
}

- (NSMutableArray *)serviceMaintainArray
{
    if (!_serviceMaintainArray) {
        _serviceMaintainArray = [NSMutableArray array];
    }
    return _serviceMaintainArray;
}

- (void)reloadSetOrUI
{
    [self.mainDictionary removeAllObjects];
    [self.classDictionary removeAllObjects];
    if (self.choiceDictionary.count > 0) {
        self.footerView.icon.image = [UIImage imageNamed:@"icon_shoppingCart_highlight"];
        CGFloat workPrice = 0, allPrice = 0;
        for (JTStoreSeviceModel *model in self.choiceDictionary.allValues) {
            if (model.mainID && model.mainID.length > 0) {
                NSMutableArray *array = [self.mainDictionary objectForKey:model.mainID] ? [self.mainDictionary objectForKey:model.mainID] : [NSMutableArray array];
                [array addObject:model];
                [self.mainDictionary setObject:array forKey:model.mainID];
            }
            if (model.classID && model.classID.length > 0) {
                NSMutableArray *array = [self.classDictionary objectForKey:model.classID] ? [self.classDictionary objectForKey:model.classID] : [NSMutableArray array];
                [array addObject:model];
                [self.classDictionary setObject:array forKey:model.classID];
            }
            workPrice += model.worksPrice;
            if (model.storeGoodsModel && [model.storeGoodsModel isKindOfClass:[NSArray class]] && model.storeGoodsModel.count > 0) {
                for (JTStoreGoodsModel *item in model.storeGoodsModel) {
                    allPrice += item.num * item.price;
                }
            }
            else
            {
                allPrice += model.price;
            }
            allPrice += workPrice;
        }
        self.footerView.allPrice = allPrice;
        self.footerView.workPrice = workPrice;
        self.footerView.bedge = self.choiceDictionary.count;
    }
    else
    {
        self.footerView.icon.image = [UIImage imageNamed:@"icon_shoppingCart_normal"];
        self.footerView.allPrice = 0;
        self.footerView.workPrice = 0;
        self.footerView.bedge = 0;
    }
    JTStoreServiceCollectionViewCell *cell = (JTStoreServiceCollectionViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.tableview reloadData];
    itemHeight = MAX(cell.tableview.contentSize.height, self.leftTableView.height);
    cell.tableview.height = cell.tableview.contentSize.height;
    [self reloadData];
    [self.leftTableView reloadData];
}

@end
