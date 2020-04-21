//
//  JTStoreTableView.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreTableView.h"
#import "MJRefresh.h"

@interface JTStoreTableView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger dataCount;
@property (assign, nonatomic) NSInteger page;

@end

@implementation JTStoreTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[JTStoreTableViewCell class] forCellReuseIdentifier:storeIndentifier];
        [self setup];
        [self setTableRefreshHeader];
        [self setTableRefreshFooter];
    }
    return self;
}

- (void)didMoveToWindow
{
    if (self.window) {
        if (self.dataArray.count == 0) {
            [self staticRefreshFirstTableListData];
        }
    }
    [super didMoveToWindow];
}

- (void)staticRefreshFirstTableListData
{
    [self setPage:1];
    __weak typeof(self) weakself = self;
    [self getListData:^{
        [weakself handleFirstTableListData];
    }];
}

- (void)setTableRefreshHeader
{
    __weak typeof(self) weakself = self;
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [weakself getListData:^{
            [weakself.mj_header endRefreshing];
            [weakself handleFirstTableListData];
        }];
    }];
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
}

- (void)setTableRefreshFooter
{
    __weak typeof(self) weakself = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [weakself getListData:^{
            [weakself.mj_footer endRefreshing];
            [weakself reloadData];

            if (weakself.dataCount != weakself.dataArray.count) {
                weakself.dataCount = weakself.dataArray.count;
                [weakself.mj_footer resetNoMoreData];
            }
            else
            {
                [weakself.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
    [(MJRefreshAutoNormalFooter *)weakself.mj_footer setHidden:YES];
}

- (void)getListData:(void (^)(void))requestComplete
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getStoreListApi) parameters:@{@"type": @(weakself.type), @"page": @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1) {
            [weakself.dataArray removeAllObjects];
        }
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:[JTStoreModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        }
        requestComplete();
    } failure:^(NSError *error) {
        requestComplete();
    }];
}

- (void)handleFirstTableListData
{
    [self reloadData];
    if (self.mj_footer) {
        self.dataCount = self.dataArray.count;
        if (self.dataCount < 10) {
            [self.mj_footer endRefreshingWithNoMoreData];
            [(MJRefreshAutoNormalFooter *)self.mj_footer setHidden:YES];
        }
        else
        {
            [self.mj_footer resetNoMoreData];
            [(MJRefreshAutoNormalFooter *)self.mj_footer setHidden:NO];
        }
    }
}

- (void)setup {
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = BlackLeverColor1;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeIndentifier];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_scrollDelegate && [_scrollDelegate respondsToSelector:@selector(storeTableView:didSelectRowStoreModel:)]) {
        [_scrollDelegate storeTableView:self didSelectRowStoreModel:self.dataArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollDelegate && [_scrollDelegate respondsToSelector:@selector(storeTableViewDidScroll:)]) {
        [_scrollDelegate storeTableViewDidScroll:scrollView];
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
