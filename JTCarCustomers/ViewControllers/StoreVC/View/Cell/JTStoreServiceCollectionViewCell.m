//
//  JTStoreServiceCollectionViewCell.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceCollectionViewCell.h"
#import "JTStoreServiceTableHeaderView.h"
#import "ZTTableViewHeaderFooterView.h"
#import "JTStoreServiceTableViewCell.h"
#import "JTStoreGoodsTableViewCell.h"
#import "JTStoreEditGoodsTableViewCell.h"
#import "JTStoreGoodsListViewController.h"

@interface JTStoreServiceCollectionViewCell () <UITableViewDelegate, UITableViewDataSource, JTStoreServiceTableViewCellDelegate, JTStoreEditGoodsTableViewCellDelegate>

@property (strong, nonatomic) JTStoreServiceTableHeaderView *headerView;
@property (assign, nonatomic) NSInteger itemType;        // 0，普通 1，保养
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation JTStoreServiceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
        [self.tableview registerClass:[JTStoreServiceTableViewCell class] forCellReuseIdentifier:storeServiceIndentifier];
        [self.tableview registerClass:[JTStoreGoodsTableViewCell class] forCellReuseIdentifier:storeGoodsIndentifier];
        [self.tableview registerClass:[JTStoreEditGoodsTableViewCell class] forCellReuseIdentifier:storeEditGoodsIndentifier];
    }
    return self;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.tableHeaderView = self.headerView;
        _tableview.separatorColor = BlackLeverColor2;
    }
    return _tableview;
}

- (void)setIsClear:(BOOL)isClear
{
    _isClear = isClear;
    [self setItemType:0];
    [self.dataArray removeAllObjects];
}

- (void)setChoiceDictionary:(NSMutableDictionary<NSString *,JTStoreSeviceModel *> *)choiceDictionary
{
    _choiceDictionary = choiceDictionary;
}

- (void)setMainDictionary:(NSMutableDictionary<NSString *,NSMutableArray *> *)mainDictionary
{
    _mainDictionary = mainDictionary;
}

- (void)setClassDictionary:(NSMutableDictionary<NSString *,NSMutableArray *> *)classDictionary
{
    _classDictionary = classDictionary;
}

- (void)setEditArray:(NSMutableArray<NSString *> *)editArray
{
    _editArray = editArray;
}

- (void)setStoreSeviceLiveModels:(NSMutableArray<JTStoreServiceLiveModel *> *)storeSeviceLiveModels
{
    _storeSeviceLiveModels = storeSeviceLiveModels;
    _headerView.storeServiceLiveModels = storeSeviceLiveModels;
}

- (void)setStoreSeviceModels:(NSMutableArray<JTStoreSeviceModel *> *)storeSeviceModels
{
    _storeSeviceModels = storeSeviceModels;
    if (storeSeviceModels && [storeSeviceModels isKindOfClass:[NSArray class]] && storeSeviceModels.count > 0) {
        [self setItemType:0];
        [self.dataArray addObjectsFromArray:storeSeviceModels];
    }
    [self.tableview reloadData];
    if (_delegate && [_delegate respondsToSelector:@selector(storeServiceCollectionViewCell:didChangeAtHeight:)] && self.tableview.contentSize.height > 0 && self.tableview.height != self.tableview.contentSize.height) {
        [_delegate storeServiceCollectionViewCell:self didChangeAtHeight:self.tableview.contentSize.height];
        [self.tableview setContentOffset:CGPointZero animated:NO];
        [self.tableview setHeight:self.tableview.contentSize.height];
    }
}

- (void)setStoreServiceMaintainModels:(NSMutableArray<JTStoreServiceMaintainModel *> *)storeServiceMaintainModels
{
    _storeServiceMaintainModels = storeServiceMaintainModels;
    if (storeServiceMaintainModels && [storeServiceMaintainModels isKindOfClass:[NSArray class]] && storeServiceMaintainModels.count > 0) {
        [self setItemType:1];
        for (JTStoreServiceMaintainModel *model in storeServiceMaintainModels) {
            [self.dataArray addObject:model];
            [self.dataArray addObjectsFromArray:model.storeSeviceModels];
        }
    }
    [self.tableview reloadData];
    if (_delegate && [_delegate respondsToSelector:@selector(storeServiceCollectionViewCell:didChangeAtHeight:)] && self.tableview.contentSize.height > 0 && self.tableview.height != self.tableview.contentSize.height) {
        [_delegate storeServiceCollectionViewCell:self didChangeAtHeight:self.tableview.contentSize.height];
        [self.tableview setContentOffset:CGPointZero animated:NO];
        [self.tableview setHeight:self.tableview.contentSize.height];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id model = [self.dataArray objectAtIndex:section];
    return 1 + (([model isKindOfClass:[JTStoreSeviceModel class]] && [self.choiceDictionary objectForKey:[model serviceID]]) ? [[self.choiceDictionary objectForKey:[model serviceID]] storeGoodsModel].count : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        id model = [self.dataArray objectAtIndex:indexPath.section];
        return [model isKindOfClass:[JTStoreSeviceModel class]] ? [model cellHeight] : 30;
    }
    else
    {
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40.0;
    }
    else
    {
        if (self.itemType == 0) {
            return 5.0;
        }
        else
        {
            id model = [self.dataArray objectAtIndex:section];
            return [model isKindOfClass:[JTStoreSeviceModel class]] ? .5f : 5.f;
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZTTableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
    header.promptLB.textColor = BlackLeverColor6;
    if (section == 0) {
        header.promptLB.text = self.isMulti?@"服务类型（多选）":@"服务类型";
        header.promptLB.hidden = NO;
    }
    else
    {
        header.promptLB.text = @"";
        header.promptLB.hidden = YES;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        if ([model isKindOfClass:[JTStoreSeviceModel class]]) {
            JTStoreServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeServiceIndentifier];
            BOOL isChoice = [self.choiceDictionary objectForKey:[model serviceID]]; // 是否选择
            BOOL isShowEdit = !(isChoice && [model storeGoodsModel].count > 0); // 是否显示编辑按钮
            BOOL isEditStatus = [self.editArray containsObject:[model serviceID]]; // 是否改成编辑状态
            cell.choiceBT.selected = isChoice;
            cell.editBT.hidden = isShowEdit;
            cell.editBT.selected = isEditStatus;
            cell.model = isChoice ? [self.choiceDictionary objectForKey:[model serviceID]] : model; // 赋值
            cell.delegate = self;
            cell.indexPath = indexPath;
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.textLabel.font = Font(14);
                cell.textLabel.textColor = BlackLeverColor3;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *maintainID = [(JTStoreServiceMaintainModel *)model maintainID];
            NSInteger num = [self.classDictionary objectForKey:maintainID] ? [[self.classDictionary objectForKey:maintainID] count] : 0;
            cell.textLabel.text = [NSString stringWithFormat:@"%@（%ld/%ld）", [(JTStoreServiceMaintainModel *)model name], num, (long)[(JTStoreServiceMaintainModel *)model total]];
            return cell;
        }
    }
    else
    {
        if ([self.editArray containsObject:[model serviceID]]) {
            JTStoreEditGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeEditGoodsIndentifier];
            cell.model = [self.choiceDictionary objectForKey:[model serviceID]] ? [[[self.choiceDictionary objectForKey:[model serviceID]] storeGoodsModel] objectAtIndex:indexPath.row - 1] : [[model storeGoodsModel] objectAtIndex:indexPath.row - 1];
            cell.delegate = self;
            cell.indexPath = indexPath;
            return cell;
        }
        else
        {
            JTStoreGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeGoodsIndentifier];
            cell.model = [self.choiceDictionary objectForKey:[model serviceID]] ? [[[self.choiceDictionary objectForKey:[model serviceID]] storeGoodsModel] objectAtIndex:indexPath.row - 1] : [[model storeGoodsModel] objectAtIndex:indexPath.row - 1];
            return cell;
        }
    }
}

- (void)storeServiceTableViewCell:(JTStoreServiceTableViewCell *)storeServiceTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath didEditAtStatus:(BOOL)status
{
    if (status)
        [self.editArray addObject:storeServiceTableViewCell.model.serviceID];
    else
        [self.editArray removeObject:storeServiceTableViewCell.model.serviceID];
    [self.tableview reloadData];
}

- (void)storeServiceTableViewCell:(JTStoreServiceTableViewCell *)storeServiceTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath didChoiceAtStatus:(BOOL)status
{
    if (status) {
        id model = [[self.dataArray objectAtIndex:indexPath.section] mutableCopy];
        [self.choiceDictionary setObject:model forKey:storeServiceTableViewCell.model.serviceID];
    }
    else {
        [self.choiceDictionary removeObjectForKey:storeServiceTableViewCell.model.serviceID];
        [self.editArray removeObject:storeServiceTableViewCell.model.serviceID];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(refreshDataInstoreServiceCollectionViewCell:)]) {
        [_delegate refreshDataInstoreServiceCollectionViewCell:self];
    }
}

- (void)storeEditGoodsTableViewCell:(JTStoreEditGoodsTableViewCell *)storeEditGoodsTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath didEditGoodsType:(JTStoreEditGoodsType)editGoodsType
{
    switch (editGoodsType) {
        case JTStoreEditGoodsTypeReduce:
        {
            storeEditGoodsTableViewCell.model.num --;
        }
            break;
        case JTStoreEditGoodsTypeAdd:
        {
            storeEditGoodsTableViewCell.model.num ++;
        }
            break;
        case JTStoreEditGoodsTypeDelete:
        {
            id object = [self.dataArray objectAtIndex:indexPath.section];
            JTStoreSeviceModel *model = [self.choiceDictionary objectForKey:[object serviceID]];
            NSMutableArray *storeGoodsModel = [NSMutableArray arrayWithArray:model.storeGoodsModel];
            [storeGoodsModel removeObjectAtIndex:indexPath.row - 1];
            model.storeGoodsModel = storeGoodsModel;
            [self.choiceDictionary setObject:model forKey:[object serviceID]];
        }
            break;
        case JTStoreEditGoodsTypeReplace:
        {
            __weak typeof(self) weakself = self;
            [[Utility currentViewController].navigationController pushViewController:[[JTStoreGoodsListViewController alloc] initWithClassID:@"90" goodsID:storeEditGoodsTableViewCell.model.goodsID selectCompletion:^(JTStoreGoodsModel *model) {
                storeEditGoodsTableViewCell.model.goodsID = model.goodsID;
                storeEditGoodsTableViewCell.model.coverUrlString = model.coverUrlString;
                storeEditGoodsTableViewCell.model.name = model.name;
                storeEditGoodsTableViewCell.model.stock = model.stock;
                storeEditGoodsTableViewCell.model.price = model.price;
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(refreshDataInstoreServiceCollectionViewCell:)]) {
                    [weakself.delegate refreshDataInstoreServiceCollectionViewCell:weakself];
                }
            }] animated:YES];
            return;
        }
            break;
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(refreshDataInstoreServiceCollectionViewCell:)]) {
        [_delegate refreshDataInstoreServiceCollectionViewCell:self];
    }
}

- (JTStoreServiceTableHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTStoreServiceTableHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
