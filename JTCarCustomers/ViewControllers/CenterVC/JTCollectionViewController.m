//
//  JTCollectionViewController.m
//  JTSocial
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionViewController.h"
#import "JTCollectionLabelTableViewCell.h"
#import "JTCollectionTextTableViewCell.h"
#import "JTCollectionImageTableViewCell.h"
#import "JTCollectionAudioTableViewCell.h"
#import "JTCollectionAddressTableViewCell.h"
#import "JTCollectionExpressionTableViewCell.h"
#import "JTCollectionVideoTableViewCell.h"
#import "JTCollectionActivityTableViewCell.h"
#import "JTCollectionShopTableViewCell.h"
#import "JTCollectionInfomationTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTMessageMaker.h"
#import "JTMapMarkViewController.h"
#import "JTCollectionDetailViewController.h"
#import "JTActivityDetailViewController.h"
#import "JTCollectionSearchViewController.h"
#import "JTCarLifeDetailViewController.h"
#import "JTStoreDetailViewController.h"

@interface JTCollectionViewController () <UITableViewDataSource, JTCollectionLabelTableViewCellDelegate>
{
    NSInteger categoryID;
}
@property (copy, nonatomic) NSIndexPath *editingIndexPath;
@property (copy, nonatomic) NSArray *categorys;
@end

@implementation JTCollectionViewController

- (instancetype)initWithDoneBlock:(void (^)(NIMMessage *message))doneBlock
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _doneBlock = doneBlock;
    }
    return self;
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"收藏"];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    }
    self.view.backgroundColor = BlackLeverColor1;
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:100 sectionHeaderHeight:8 sectionFooterHeight:0];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTCollectionLabelTableViewCell class] forCellReuseIdentifier:collectionLabelIdentifier];
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
    [self staticRefreshFirstTableListData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCollectionNotification:) name:kDeleteCollectionNotification object:nil];
}

- (void)deleteCollectionNotification:(NSNotification *)notification
{
    if (notification.object && [notification.object isKindOfClass:[NSString class]]) {
        NSString *collectionID = notification.object;
        for (JTCollectionModel *model in self.dataArray) {
            if ([model.collectionID isEqualToString:collectionID]) {
                [self.dataArray removeObject:model];
                [self.tableview reloadData];
                break;
            }
        }
    }
}

- (void)getListData:(void (^)(void))requestComplete
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getuserfavoriteApi) parameters:@{@"page" : @(self.page), @"type": @(categoryID)} success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1)
        {
            [weakself.dataArray removeAllObjects];
            if ([responseObject objectForKey:@"category"] && [responseObject[@"category"] isKindOfClass:[NSArray class]]) {
                [weakself setCategorys:responseObject[@"category"]];
            }
        }
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:[JTCollectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        }
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((self.navigationController.viewControllers.count != 1) && indexPath.section != 0);
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除当前收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JTCollectionModel *model = [weakself.dataArray objectAtIndex:indexPath.section - 1];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(delfavoriteApi) parameters:@{@"id": model.collectionID} placeholder:@"" success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"删除成功"];
            [[HUDTool shareHUDTool] hideHUD];
            [weakself.dataArray removeObjectAtIndex:indexPath.section - 1];
            [weakself.tableview reloadData];
        } failure:^(NSError *error) {
        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        JTCollectionLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionLabelIdentifier];
        cell.dataArray = self.categorys;
        cell.delegate = self;
        return cell;
    }
    else
    {
        JTCollectionTableViewCell *cell = nil;
        JTCollectionModel *model = [self.dataArray objectAtIndex:indexPath.section - 1];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0;
    if (indexPath.section == 0) {
        __weak typeof(self) weakself = self;
        CGFloat height = cellHeight = [tableView fd_heightForCellWithIdentifier:collectionLabelIdentifier cacheByIndexPath:indexPath configuration:^(JTCollectionLabelTableViewCell *cell) {
            cell.dataArray = weakself.categorys;
        }];
        cellHeight = weakself.categorys.count?height:0;
        
    }
    else
    {
        JTCollectionModel *model = [self.dataArray objectAtIndex:indexPath.section - 1];
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
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        JTCollectionModel *model = [self.dataArray objectAtIndex:indexPath.section - 1];
        __weak typeof(self) weakself = self;
        if (self.navigationController.viewControllers.count == 1) {
            
            if (model.collectionType == JTCollectionTypeAudio) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"收藏类型中，不支持语音转发。" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                if (weakself.doneBlock) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认发送当前收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (model.collectionType == JTCollectionTypeText) {
                            NIMMessage *message = [JTMessageMaker messageWithText:model.contentDic[@"text"]];
                            weakself.doneBlock(message);
                        }
                        else if (model.collectionType == JTCollectionTypeExpression) {
                            NIMMessage *message = [JTMessageMaker messageWithExpression:@"" expressionName:model.contentDic[@"name"] expressionUrl:model.contentDic[@"image"] expressionThumbnail:model.contentDic[@"thumbnail"] expressionWidth:model.contentDic[@"width"] expressionHeight:model.contentDic[@"height"]];
                            weakself.doneBlock(message);
                        }
                        else if (model.collectionType == JTCollectionTypeAddress) {
                            NIMMessage *message = [JTMessageMaker messageWithLocation:[model.contentDic[@"lat"] doubleValue] longitude:[model.contentDic[@"lng"] doubleValue] title:model.contentDic[@"address"]];
                            weakself.doneBlock(message);
                        }
                        else if (model.collectionType == JTCollectionTypeImage) {
                            NIMMessage *message = [JTMessageMaker messageWithImageUrl:model.contentDic[@"image"] imageThumbnail:model.contentDic[@"thumbnail"] imageWidth:model.contentDic[@"width"] imageHeight:model.contentDic[@"height"]];
                            weakself.doneBlock(message);
                        }
                        else if (model.collectionType == JTCollectionTypeVideo) {
                            NIMMessage *message = [JTMessageMaker messageWithVideoUrl:model.contentDic[@"url"] videoCoverUrl:model.contentDic[@"coverUrl"] videoWidth:model.contentDic[@"width"] videoHeight:model.contentDic[@"height"]];
                            weakself.doneBlock(message);
                        }
                        else if (model.collectionType == JTCollectionTypeActivity) {
                            NIMMessage *message = [JTMessageMaker messageWithActivity:model.contentDic[@"id"] coverUrl:model.contentDic[@"image"] theme:model.contentDic[@"theme"] time:model.contentDic[@"time"] address:model.contentDic[@"address"]];
                            weakself.doneBlock(message);
                        }
                        else if (model.collectionType == JTCollectionTypeInformation) {
                            NIMMessage *message = [JTMessageMaker messageWithInformation:model.contentDic[@"id"] h5Url:model.contentDic[@"h5_url"] coverUrl:model.contentDic[@"image"] title:model.contentDic[@"title"] content:model.contentDic[@"content"]];
                            weakself.doneBlock(message);
                        }
                        else if (model.collectionType == JTCollectionTypeShop) {
                            NIMMessage *message = [JTMessageMaker messageWithShop:model.contentDic[@"id"] coverUrl:model.contentDic[@"image"] name:model.contentDic[@"store_name"] score:model.contentDic[@"score"] time:model.contentDic[@"time"] address:model.contentDic[@"address"]];
                            weakself.doneBlock(message);
                        }
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
        else
        {
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
            else if (model.collectionType == JTCollectionTypeInformation) {
                viewController = [[JTCarLifeDetailViewController alloc] initWeburl:model.contentDic[@"h5_url"] navtitle:model.contentDic[@"title"]];
            }
            else if (model.collectionType == JTCollectionTypeShop) {
                viewController = [[JTStoreDetailViewController alloc] initWithStoreID:model.contentDic[@"id"]];
            }
            [self.navigationController pushViewController:viewController animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)collectionLabelTableViewCell:(JTCollectionLabelTableViewCell *)collectionLabelTableViewCell didSelectAtSource:(id)source
{
    categoryID = [[source objectForKey:@"type"] integerValue];

    [self.navigationController pushViewController:[[JTCollectionSearchViewController alloc] initWithCategoryID:categoryID] animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}

- (void)configSwipeButtons
{
    if (IOS11)
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableview.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                [subview.subviews[0] setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
                [subview.subviews[0] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in cell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                [subview.subviews[0] setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
                [subview.subviews[0] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
