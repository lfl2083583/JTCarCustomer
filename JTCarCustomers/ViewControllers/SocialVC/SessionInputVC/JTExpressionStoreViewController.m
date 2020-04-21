//
//  JTExpressionStoreViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionStoreViewController.h"
#import "JTExpressionTableViewCell.h"
#import "JTExpressionManageViewController.h"
#import "JTExpressionDetailViewController.h"
#import "JTExpressionTool.h"

@interface JTExpressionStoreViewController () <UITableViewDataSource, JTExpressionTableViewCellDelegate>
{
    BOOL cacheEnabled;
}
@end

@implementation JTExpressionStoreViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kModifyExpressionNotification object:nil];
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightClick:(id)sender
{
    [self.navigationController pushViewController:[[JTExpressionManageViewController alloc] init] animated:YES];
}

- (void)modifyExpressionNotification:(NSNotification *)notification
{
    __weak typeof(self) weakself = self;
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"id"] integerValue] == [notification.object[@"id"] integerValue]) {
            [obj setObject:notification.object[@"is_download"] forKey:@"is_download"];
            [weakself.tableview reloadData];
            *stop = YES;
        }
    }];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cacheEnabled = YES;
    [self.navigationItem setTitle:@"表情商店"];
    [self createTalbeView:UITableViewStylePlain rowHeight:60];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTExpressionTableViewCell class] forCellReuseIdentifier:expressionIdentifier];
    [self setShowTableRefreshHeader:YES];
    [self setShowTableRefreshFooter:YES];
    [self.tableview.mj_header beginRefreshing];
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)]];
    }
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"表情管理" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyExpressionNotification:) name:kModifyExpressionNotification object:nil];
}


- (void)getListData:(void (^)(void))requestComplete
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonListApi) parameters:@{@"page": @(self.page), @"source": CHANNEL_ID} cacheEnabled:cacheEnabled success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1) {
            [weakself.dataArray removeAllObjects];
        }
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        if (state == ResponseStateNormal) {
            [super getListData:requestComplete];
        }
        else
        {
            [weakself.tableview reloadData];
        }
    } failure:^(NSError *error) {
        
        [super getListData:requestComplete];
    }];
    cacheEnabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTExpressionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expressionIdentifier];
    cell.sourceDic = [self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[JTExpressionDetailViewController alloc] initWithSourceDic:self.dataArray[indexPath.row]] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)expressionTableViewCell:(id)expressionTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self downloadExpression:indexPath];
}

- (void)downloadExpression:(NSIndexPath *)indexPath
{
    [[HUDTool shareHUDTool] showHint:@"下载中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(DownloadApi) parameters:@{@"emoti_id": self.dataArray[indexPath.row][@"id"]} success:^(id responseObject, ResponseState state) {

        NSMutableDictionary *model = [NSMutableDictionary dictionary];
        [model addEntriesFromDictionary:[weakself.dataArray objectAtIndex:indexPath.row]];
        [model setObject:responseObject[@"list"] forKey:@"list"];
        [model setObject:@"0" forKey:@"sort"];
        [[JTExpressionTool sharedManager] addSingleModel:model success:^{
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[weakself.dataArray objectAtIndex:indexPath.row]];
            [weakself.dataArray removeObjectAtIndex:indexPath.row];
            [dic setObject:@"1" forKey:@"is_download"];
            [weakself.dataArray insertObject:dic atIndex:indexPath.row];
            [weakself.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [[HUDTool shareHUDTool] showHint:@"下载成功" yOffset:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];

        } failure:^{
            [[HUDTool shareHUDTool] showHint:@"下载失败" yOffset:0];
        }];

    } failure:^(NSError *error) {
        [[HUDTool shareHUDTool] showHint:@"下载失败" yOffset:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
