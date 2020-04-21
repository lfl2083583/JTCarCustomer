//
//  JTExpressionManageViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionManageViewController.h"
#import "JTExpressionTableViewCell.h"
#import "JTExpressionTool.h"
#import "JTExpressionDetailViewController.h"

@interface JTExpressionManageViewController () <UITableViewDataSource, JTExpressionTableViewCellDelegate>
{
    BOOL isEdit;
}
@end

@implementation JTExpressionManageViewController

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightClick:(UIBarButtonItem *)sender
{
    isEdit = !isEdit;
    sender.title = isEdit?@"完成":@"排序";
    [self.tableview reloadData];
    [self.tableview setEditing:isEdit animated:YES];
    
    if (!isEdit) {
        
        NSMutableArray *sortArr = [NSMutableArray array];
        for (NSUInteger index = 0; index < self.dataArray.count; index ++ ) {
            [sortArr addObject:@{@"id": self.dataArray[index][@"id"], @"sort": [NSNumber numberWithInteger:index+1]}];
        }
        [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
        __weak typeof(self) weakself = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonsSortApi) parameters:@{@"sort" : [sortArr mj_JSONString]} success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] hideHUD];
            [[JTExpressionTool sharedManager] reloadOtherExpressions:weakself.dataArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"我的表情"];
    [self createTalbeView:UITableViewStylePlain rowHeight:60];
    [self.tableview setAllowsSelectionDuringEditing:NO];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTExpressionTableViewCell class] forCellReuseIdentifier:expressionIdentifier];
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)]];
    }
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)]];
    
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(MyEmoticonsApi) parameters:@{@"page": @(self.page)} success:^(id responseObject, ResponseState state) {
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:responseObject[@"list"]];
            [[JTExpressionTool sharedManager] reloadOtherExpressions:weakself.dataArray];
        }
        [weakself.tableview reloadData];
    } failure:^(NSError *error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTExpressionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expressionIdentifier];
    cell.isManage = YES;
    cell.isEdit = isEdit;
    cell.sourceDic = [self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *model = [NSMutableDictionary dictionary];
    [model addEntriesFromDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    [model setObject:@"1" forKey:@"is_download"];
    JTExpressionDetailViewController *expressionDetailVC = [[JTExpressionDetailViewController alloc] initWithSourceDic:model];
    [self.navigationController pushViewController:expressionDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id sourceDic = [self.dataArray objectAtIndex:sourceIndexPath.row];
    [self.dataArray removeObjectAtIndex:sourceIndexPath.row];
    [self.dataArray insertObject:sourceDic atIndex:destinationIndexPath.row];
}

- (void)expressionTableViewCell:(id)expressionTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    [[HUDTool shareHUDTool] showHint:@"移除中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(RemoveEmoticonsApi) parameters:@{@"id": self.dataArray[indexPath.row][@"id"]} success:^(id responseObject, ResponseState state) {
        
        [[HUDTool shareHUDTool] hideHUD];
        [[NSNotificationCenter defaultCenter] postNotificationName:kModifyExpressionNotification object:@{@"id": weakself.dataArray[indexPath.row][@"id"], @"is_download": @"0"}];
        [weakself.dataArray removeObjectAtIndex:indexPath.row];
        [weakself.tableview reloadData];
        [[JTExpressionTool sharedManager] reloadOtherExpressions:weakself.dataArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
