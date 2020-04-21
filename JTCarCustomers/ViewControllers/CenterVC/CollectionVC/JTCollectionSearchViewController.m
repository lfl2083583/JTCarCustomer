//
//  JTCollectionSearchViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/14.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTCollectionLabelTableViewCell.h"
#import "JTCollectionTextTableViewCell.h"
#import "JTCollectionAudioTableViewCell.h"
#import "JTCollectionImageTableViewCell.h"
#import "JTCollectionVideoTableViewCell.h"
#import "JTCollectionAddressTableViewCell.h"
#import "JTCollectionActivityTableViewCell.h"
#import "JTCollectionExpressionTableViewCell.h"
#import "JTCollectionInfomationTableViewCell.h"
#import "JTCollectionShopTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "JTMapMarkViewController.h"
#import "JTCollectionSearchViewController.h"
#import "JTCollectionDetailViewController.h"
#import "JTActivityDetailViewController.h"


@interface JTCollectionSearchViewController () <UITableViewDataSource, UISearchBarDelegate>
{
    NSInteger _categoryID;
}

@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) NSIndexPath *editingIndexPath;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation JTCollectionSearchViewController

- (instancetype)initWithCategoryID:(NSInteger)categoryID {
    self = [super init];
    if (self) {
        _categoryID = categoryID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
    self.view.backgroundColor = BlackLeverColor1;
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:100 sectionHeaderHeight:8 sectionFooterHeight:0];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[JTCollectionTextTableViewCell class] forCellReuseIdentifier:collectionTextIdentifier];
    [self.tableview registerClass:[JTCollectionImageTableViewCell class] forCellReuseIdentifier:collectionImageIdentifier];
    [self.tableview registerClass:[JTCollectionAudioTableViewCell class] forCellReuseIdentifier:collectionAudioIdentifier];
    [self.tableview registerClass:[JTCollectionAddressTableViewCell class] forCellReuseIdentifier:collectionAddressIdentifier];
    [self.tableview registerClass:[JTCollectionExpressionTableViewCell class] forCellReuseIdentifier:collectionExpressionIdentifier];
    [self.tableview registerClass:[JTCollectionVideoTableViewCell class] forCellReuseIdentifier:collectionVideoIdentifier];
    [self.tableview registerClass:[JTCollectionActivityTableViewCell class] forCellReuseIdentifier:collectionActivityIndentfier];
    [self.tableview registerClass:[JTCollectionShopTableViewCell class] forCellReuseIdentifier:collectionShopIdentifier];
    [self.tableview registerClass:[JTCollectionInfomationTableViewCell class] forCellReuseIdentifier:collectionInfomationIdentifier];
    [self setShowTableRefreshHeader:YES];
    [self setShowTableRefreshFooter:YES];
    [self.view addSubview:self.tipLB];
    [self.tableview.mj_header beginRefreshing];
    
}

- (void)getListData:(void (^)(void))requestComplete
{
    __weak typeof(self) weakself = self;
    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
    [progem setValue:@(self.page) forKey:@"page"];
    [progem setValue:@(_categoryID) forKey:@"type"];
    if (self.isSearching) {
        [progem setValue:self.searchBar.text forKey:@"keyword"];
    }
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(self.isSearching?@"client/user/favorite/searchFavorite":getuserfavoriteApi) parameters:progem success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1)
        {
            [weakself.searchArray removeAllObjects];
            [weakself.dataArray removeAllObjects];
        }
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            if (weakself.isSearching) {
                [weakself.searchArray addObjectsFromArray:[JTCollectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            } else {
               [weakself.dataArray addObjectsFromArray:[JTCollectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            }
        }
        [weakself configTipLB];
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isSearching?self.searchArray.count:self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setEditingIndexPath:indexPath];
    [self.view setNeedsLayout];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];
        [weakself deleteCollection:indexPath];
    }];
    deleteRowAction.backgroundColor = BlackLeverColor1;
    return @[deleteRowAction];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    __weak typeof(self) weakself = self;
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [tableView setEditing:NO animated:YES];
        [weakself deleteCollection:indexPath];
        completionHandler (YES);
    }];
    deleteRowAction.image = [UIImage imageNamed:@"icon_cell_delete"];
    deleteRowAction.backgroundColor = BlackLeverColor1;
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

- (void)deleteCollection:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认发送当前收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JTCollectionModel *model = [weakself.dataArray objectAtIndex:indexPath.section];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(delfavoriteApi) parameters:@{@"id": model.collectionID} placeholder:@"" success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"删除成功"];
            [[HUDTool shareHUDTool] hideHUD];
            [weakself.dataArray removeObjectAtIndex:indexPath.section];
            [weakself.tableview reloadData];
        } failure:^(NSError *error) {
        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTCollectionTableViewCell *cell = nil;
    JTCollectionModel *model = [self.isSearching?self.searchArray:self.dataArray objectAtIndex:indexPath.section];
    switch (model.collectionType) {
        case JTCollectionTypeText: cell = [tableView dequeueReusableCellWithIdentifier:collectionTextIdentifier]; break;
        case JTCollectionTypeAudio: cell = [tableView dequeueReusableCellWithIdentifier:collectionAudioIdentifier]; break;
        case JTCollectionTypeExpression: cell = [tableView dequeueReusableCellWithIdentifier:collectionExpressionIdentifier]; break;
        case JTCollectionTypeAddress: cell = [tableView dequeueReusableCellWithIdentifier:collectionAddressIdentifier]; break;
        case JTCollectionTypeImage: cell = [tableView dequeueReusableCellWithIdentifier:collectionImageIdentifier]; break;
        case JTCollectionTypeVideo: cell = [tableView dequeueReusableCellWithIdentifier:collectionVideoIdentifier]; break;
        case JTCollectionTypeActivity: cell = [tableView dequeueReusableCellWithIdentifier:collectionActivityIndentfier]; break;
        case JTCollectionTypeShop: cell = [tableView
            dequeueReusableCellWithIdentifier:collectionShopIdentifier]; break;
        case JTCollectionTypeInformation: cell = [tableView
            dequeueReusableCellWithIdentifier:collectionInfomationIdentifier]; break;
        default:
            break;
    }
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0;
    JTCollectionModel *model = [self.isSearching?self.searchArray:self.dataArray objectAtIndex:indexPath.section];
    if (model.collectionType == JTCollectionTypeText) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionTextIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionTextTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeAudio) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionAudioIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionAudioTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeExpression) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionExpressionIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionExpressionTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeAddress) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionAddressIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionAddressTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeImage) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionImageIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionImageTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeVideo) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionVideoIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionVideoTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeActivity) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionActivityIndentfier cacheByIndexPath:indexPath configuration:^(JTCollectionActivityTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeShop) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionShopIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionShopTableViewCell *cell) {
            cell.model = model;
        }];
    }
    else if (model.collectionType == JTCollectionTypeInformation) {
        cellHeight = [tableView fd_heightForCellWithIdentifier:collectionInfomationIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionInfomationTableViewCell *cell) {
            cell.model = model;
        }];
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTCollectionModel *model = [self.isSearching?self.searchArray:self.dataArray objectAtIndex:indexPath.section];
    UIViewController *viewController;
    if (model.collectionType == JTCollectionTypeText ||
        model.collectionType == JTCollectionTypeImage ||
        model.collectionType == JTCollectionTypeVideo ||
        model.collectionType == JTCollectionTypeExpression ||
        model.collectionType == JTCollectionTypeAudio) {
        viewController = [[JTCollectionDetailViewController alloc] initWithCollectionModel:model];
    }
    else if (model.collectionType == JTCollectionTypeAddress) {
        NSArray *array = [model.contentDic[@"address"] componentsSeparatedByString:@"&&&&&&"];
        if (array.count >= 2) {
            viewController = [[JTMapMarkViewController alloc] initWithCollection:model.collectionID latitude:[model.contentDic[@"lat"] doubleValue] longitude:[model.contentDic[@"lng"] doubleValue] title:array[0] subTitle:array[1]];
        }
    }
    else if (model.collectionType == JTCollectionTypeActivity) {
        viewController = [[JTActivityDetailViewController alloc] initWithActivityID:model.infoDic[@"id"]];
        viewController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.tableview.mj_header beginRefreshing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        self.isSearching = NO;
        self.tipLB.hidden = YES;
        [self.tableview reloadData];
    }
    else
    {
        self.isSearching = YES;
    }
}

- (void)configTipLB {
    if (self.isSearching) {
        self.tipLB.text = @"搜不到结果~";
        self.tipLB.hidden = self.searchArray.count;
    } else {
        self.tipLB.text = @"暂无相关收藏~";
        self.tipLB.hidden = self.dataArray.count;
    }
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width, kTopBarHeight);
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundColor = WhiteColor;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"找不到结果~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

@end
