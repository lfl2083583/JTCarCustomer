//
//  JTShoppingCartView.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTShoppingCartView.h"
#import "JTShoppingCartTableViewCell.h"

@interface JTShoppingCartView () <UITableViewDelegate, UITableViewDataSource, JTShoppingCartTableViewCellDelegate>

@end

@implementation JTShoppingCartView

- (instancetype)initWithFrame:(CGRect)frame storeSeviceClassModels:(NSMutableArray<JTStoreSeviceClassModel *> *)storeSeviceClassModels mainDictionary:(NSMutableDictionary<NSString *, NSMutableArray *> *)mainDictionary deleteModel:(void (^)(JTStoreSeviceModel *model))deleteModel cleanModels:(void (^)(void))cleanModels
{
    self = [super initWithFrame:frame];
    if (self) {
        _storeSeviceClassModels = storeSeviceClassModels;
        _mainDictionary = mainDictionary;
        _deleteModel = deleteModel;
        _cleanModels = cleanModels;
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self relaodUI];
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.cleanBT];
    [self.tableview registerClass:[JTShoppingCartTableViewCell class] forCellReuseIdentifier:shoppingCartIndentifier];
    [self addSubview:self.tableview];
    
    self.backgroundColor = UIColorFromRGBoraAlpha(0x000000, .2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.tableview.frame, touchPoint)) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }
}

- (void)cleanClick:(id)sender
{
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认要清空项目库吗？" message:@"清空后，所选项目记录将不被保存" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakself.cleanModels) {
            weakself.cleanModels();
        }
        [weakself setHidden:YES];
        [weakself removeFromSuperview];
    }]];
    [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.storeSeviceClassModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *mainID = [[self.storeSeviceClassModels objectAtIndex:section] classID];
    return [self.mainDictionary objectForKey:mainID] ? ([[self.mainDictionary objectForKey:mainID] count] + 1) : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? 30 : 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(14);
            cell.textLabel.textColor = BlueLeverColor1;
        }
        cell.textLabel.text = [[self.storeSeviceClassModels objectAtIndex:indexPath.section] className];
        return cell;
    }
    else
    {
        JTShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartIndentifier];
        NSString *mainID = [[self.storeSeviceClassModels objectAtIndex:indexPath.section] classID];
        cell.model = [[self.mainDictionary objectForKey:mainID] objectAtIndex:indexPath.row-1];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)shoppingCartTableViewCell:(JTShoppingCartTableViewCell *)shoppingCartTableViewCell didDeleteAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.deleteModel) {
        NSString *mainID = [[self.storeSeviceClassModels objectAtIndex:indexPath.section] classID];
        JTStoreSeviceModel *model = [[self.mainDictionary objectForKey:mainID] objectAtIndex:indexPath.row-1];
        self.deleteModel(model);
        if (self.mainDictionary.count > 0) {
            [self.tableview reloadData];
            [self relaodUI];
        }
        else
        {
            [self setHidden:YES];
            [self removeFromSuperview];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)relaodUI
{
    maxHeight = self.height / 3 * 2;
    NSInteger contentHeight = self.mainDictionary.count * 30;
    for (NSArray *array in self.mainDictionary.allValues) {
        contentHeight += array.count*60;
    }
    self.tableview.height = MIN(contentHeight, maxHeight);
    self.tableview.top = self.height - self.tableview.height;
    
    self.headerView.height = 30;
    self.headerView.bottom = self.tableview.top;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:self.bounds];
        _headerView.backgroundColor = BlackLeverColor1;
    }
    return _headerView;
}

- (UIButton *)cleanBT
{
    if (!_cleanBT) {
        _cleanBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanBT setImage:[UIImage imageNamed:@"icon_shoppingCar_delete"] forState:UIControlStateNormal];
        [_cleanBT setTitle:@" 清空项目库" forState:UIControlStateNormal];
        [_cleanBT setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_cleanBT addTarget:self action:@selector(cleanClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cleanBT.titleLabel setFont:Font(14)];
        [_cleanBT setFrame:CGRectMake(App_Frame_Width-120, 0, 120, 30)];
    }
    return _cleanBT;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = WhiteColor;
        _tableview.separatorColor = BlackLeverColor2;
        _tableview.rowHeight = 60;
    }
    return _tableview;
}

@end
