//
//  JTStoreCommentTableView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreCommentTableView.h"
#import "MJRefresh.h"
#import "JTStoreCommentScoreTableViewCell.h"
#import "JTStoreCommentClassTableViewCell.h"
#import "JTStoreCommentTableViewCell.h"

@interface JTStoreCommentTableView () <UITableViewDelegate, UITableViewDataSource, JTStoreCommentClassTableViewCellDelegate>

@property (strong, nonatomic) JTStoreCommentScoreModel *scoreModel;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger dataCount;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger commentType;

@end

@implementation JTStoreCommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _commentType = 1;
        [self registerClass:[JTStoreCommentScoreTableViewCell class] forCellReuseIdentifier:storeCommentScoreIndentifier];
        [self registerClass:[JTStoreCommentClassTableViewCell class] forCellReuseIdentifier:storeCommentClassIndentifier];
        [self registerClass:[JTStoreCommentTableViewCell class] forCellReuseIdentifier:storeCommentIndentifier];
        [self setup];
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

- (void)setCommentType:(NSInteger)commentType
{
    _commentType = commentType;
    [self staticRefreshFirstTableListData];
}

- (void)getListData:(void (^)(void))requestComplete
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(StoreCommentListApi) parameters:@{@"store_id": self.storeID, @"type": @(self.commentType-1), @"page": @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1) {
            [weakself.dataArray removeAllObjects];
        }
        if ([responseObject objectForKey:@"score"] && [responseObject[@"score"] isKindOfClass:[NSDictionary class]]) {
            weakself.scoreModel = [JTStoreCommentScoreModel mj_objectWithKeyValues:responseObject[@"score"]];
        }
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:[JTStoreCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        }
        requestComplete();
    } failure:^(NSError *error) {
        requestComplete();
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0.01f : 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? 80 : ((indexPath.section == 1) ? 50 : [(JTStoreCommentModel *)[self.dataArray objectAtIndex:indexPath.section - 2] cellHeight]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JTStoreCommentScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCommentScoreIndentifier];
        cell.model = self.scoreModel;
        return cell;
    }
    else if (indexPath.section == 1) {
        JTStoreCommentClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCommentClassIndentifier];
        cell.type = self.commentType;
        cell.delegate = self;
        return cell;
    }
    else
    {
        JTStoreCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCommentIndentifier];
        cell.model = [self.dataArray objectAtIndex:indexPath.section - 2];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)storeCommentClassTableViewCell:(JTStoreCommentClassTableViewCell *)storeCommentClassTableViewCell didSelectIndex:(NSInteger)index
{
    self.commentType = index;
}

- (void)staticRefreshFirstTableListData
{
    [self setPage:1];
    __weak typeof(self) weakself = self;
    [self getListData:^{
        [weakself handleFirstTableListData];
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

- (void)setup {
    self.backgroundColor = BlackLeverColor1;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = self;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.tableFooterView = [[UIView alloc] init];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
