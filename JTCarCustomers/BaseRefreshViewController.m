//
//  BaseRefreshViewController.m
//  GCHCustomerMall
//
//  Created by 观潮汇 on 5/8/16.
//  Copyright © 2016 观潮汇. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface BaseRefreshViewController ()

@property (strong, nonatomic) NSIndexPath *lastAnimationIndexPath;
@property (assign, nonatomic) NSInteger dataCount;
@end

@implementation BaseRefreshViewController

- (void)viewDidLoad {
    if (!IOS11) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [self.view setBackgroundColor:WhiteColor];
    [self setPage:1];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/***
 * Footer的状态根据刷新的接口来显示
 * 当数据长度等于0的时候 隐藏Footer状态
 * 当数据长度小于10的时候 提示没有更多的数据 并隐藏状态Lable
 * 当数据长度大于等于10的时候 重置没有更多的数据（消除没有更多数据的状态）
 ***/
- (void)setShowTableRefreshHeader:(BOOL)showTableRefreshHeader
{
    if (_showTableRefreshHeader != showTableRefreshHeader) {
        _showTableRefreshHeader = showTableRefreshHeader;
        if (_showTableRefreshHeader) {
            __weak typeof(self) weakself = self;
            
            MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                weakself.page = 1;
                if (weakself.cellAnimation) {
                    weakself.lastAnimationIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                }
                [weakself getListData:^{
                    [weakself.tableview.mj_header endRefreshing];
                    [weakself handleFirstTableListData];                    
                }];
            }];
            [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
            [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
            [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];

            header.lastUpdatedTimeLabel.hidden = YES;
            self.tableview.mj_header = header;
        }
        else {
            self.tableview.mj_header = nil;
        }
    }
}

/***
 * 第一次设置TableView Footer的时候 隐藏状态
 * 当加载更多数据长度为0的时候 提示没有更多的数据
 ***/
- (void)setShowTableRefreshFooter:(BOOL)showTableRefreshFooter
{
    if (_showTableRefreshFooter != showTableRefreshFooter) {
        _showTableRefreshFooter = showTableRefreshFooter;
        if (_showTableRefreshFooter) {
            __weak typeof(self) weakself = self;
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                weakself.page++;
                [weakself getListData:^{
                    [weakself.tableview.mj_footer endRefreshing];
                    [weakself.tableview reloadData];
                    
                    if (weakself.dataCount != weakself.dataArray.count) {
                        weakself.dataCount = weakself.dataArray.count;
                        [weakself.tableview.mj_footer resetNoMoreData];
                    }
                    else
                    {
                        [weakself.tableview.mj_footer endRefreshingWithNoMoreData];
                    }
                }];
            }];
            [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
            self.tableview.mj_footer = footer;
            [(MJRefreshAutoNormalFooter *)weakself.tableview.mj_footer setHidden:YES];
        }
        else {
            self.tableview.mj_footer = nil;
        }
    }
}

/***
 * Footer的状态根据刷新的接口来显示
 * 当数据长度等于0的时候 隐藏Footer状态
 * 当数据长度小于10的时候 提示没有更多的数据 并隐藏状态Lable
 * 当数据长度大于等于10的时候 重置没有更多的数据（消除没有更多数据的状态）
 ***/
- (void)setShowCollectionRefreshHeader:(BOOL)showCollectionRefreshHeader
{
    if (_showCollectionRefreshHeader != showCollectionRefreshHeader) {
        _showCollectionRefreshHeader = showCollectionRefreshHeader;
        if (_showCollectionRefreshHeader) {
            __weak typeof(self) weakself = self;
            
            MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                weakself.page = 1;
                if (weakself.cellAnimation) {
                    weakself.lastAnimationIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                }
                [weakself getListData:^{
                    [weakself.collectionview.mj_header endRefreshing];
                    [weakself.collectionview reloadData];
                    
                    if (weakself.collectionview.mj_footer) {
                        weakself.dataCount = weakself.dataArray.count;
                        if (weakself.dataCount < 10) {
                            [weakself.collectionview.mj_footer endRefreshingWithNoMoreData];
                            [(MJRefreshAutoNormalFooter *)weakself.collectionview.mj_footer stateLabel].hidden = YES;
                        }
                        else
                        {
                            [weakself.collectionview.mj_footer resetNoMoreData];
                            [(MJRefreshAutoNormalFooter *)weakself.collectionview.mj_footer stateLabel].hidden = NO;
                        }
                    }
                }];
            }];
            [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
            [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
            [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
            
            header.lastUpdatedTimeLabel.hidden = YES;
            self.collectionview.mj_header = header;
        }
        else {
            self.collectionview.mj_header = nil;
        }
    }
}

/***
 * 第一次设置CollectionView Footer的时候 隐藏状态
 * 当加载更多数据长度为0的时候 提示没有更多的数据
 ***/
- (void)setShowCollectionRefreshFooter:(BOOL)showCollectionRefreshFooter
{
    if (_showCollectionRefreshFooter != showCollectionRefreshFooter) {
        _showCollectionRefreshFooter = showCollectionRefreshFooter;
        if (_showCollectionRefreshFooter) {
            __weak typeof(self) weakself = self;
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                weakself.page++;
                [weakself getListData:^{
                    [weakself.collectionview.mj_footer endRefreshing];
                    [weakself.collectionview reloadData];
                    
                    if (weakself.dataCount != weakself.dataArray.count) {
                        weakself.dataCount = weakself.dataArray.count;
                        [weakself.collectionview.mj_footer resetNoMoreData];
                    }
                    else
                    {
                        [weakself.collectionview.mj_footer endRefreshingWithNoMoreData];
                    }
                }];
            }];
            [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
            [footer.stateLabel setHidden:YES];
            self.collectionview.mj_footer = footer;
        }
        else {
            self.collectionview.mj_footer = nil;
        }
    }
}

- (void)setCellAnimation:(BOOL)cellAnimation
{
    _cellAnimation = cellAnimation;
    _lastAnimationIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (tableView.sectionHeaderHeight == 0) ? 0.1 : tableView.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (tableView.sectionFooterHeight == 0) ? 0.1 : tableView.sectionFooterHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_cellAnimation && indexPath > _lastAnimationIndexPath) {
        
        _lastAnimationIndexPath = indexPath;
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = [NSNumber numberWithFloat:.6];
        opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnimation.duration = .2f;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:.6];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.duration = .2f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        // 将上述两个动画编组
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations:[NSArray arrayWithObjects:opacityAnimation, scaleAnimation, nil]];
        [cell.layer addAnimation:animationGroup forKey:@"basic"];
    }
    
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

#pragma mark - getter

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableDictionary *)dataDictionary
{
    if (_dataDictionary == nil) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    
    return _dataDictionary;
}

- (UIView *)defaultFooterView
{
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc] init];
    }
    
    return _defaultFooterView;
}

- (void)createTalbeView:(UITableViewStyle)style rowHeight:(CGFloat)rowHeight
{
    [self createTalbeView:style tableHeightType:JTTableHeightTypeNavigation rowHeight:rowHeight];
}

- (void)createTalbeView:(UITableViewStyle)style tableHeightType:(JTTableHeightType)tableHeightType rowHeight:(CGFloat)rowHeight
{
    [self createTalbeView:style tableHeightType:tableHeightType rowHeight:rowHeight sectionHeaderHeight:0 sectionFooterHeight:0];
}

- (void)createTalbeView:(UITableViewStyle)style tableHeightType:(JTTableHeightType)tableHeightType rowHeight:(CGFloat)rowHeight sectionHeaderHeight:(CGFloat)sectionHeaderHeight sectionFooterHeight:(CGFloat)sectionFooterHeight
{
    CGRect frame = CGRectZero;
    if (tableHeightType == JTTableHeightTypeFullScreen) {
        frame = SC_DEVICE_BOUNDS;
    }
    else if (tableHeightType == JTTableHeightTypeNavigation) {
        frame = CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight);
    }
    else if (tableHeightType == JTTableHeightTypeTabbar) {
        frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kBottomBarHeight);
    }
    else
    {
        frame = CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-kBottomBarHeight);
    }
    [self createTalbeView:style tableFrame:frame rowHeight:rowHeight sectionHeaderHeight:sectionHeaderHeight sectionFooterHeight:sectionFooterHeight];
}

- (void)createTalbeView:(UITableViewStyle)style tableFrame:(CGRect)tableFrame rowHeight:(CGFloat)rowHeight sectionHeaderHeight:(CGFloat)sectionHeaderHeight sectionFooterHeight:(CGFloat)sectionFooterHeight
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:tableFrame style:style];
        _tableview.separatorColor = BlackLeverColor2;
        _tableview.rowHeight = rowHeight;
        _tableview.estimatedRowHeight = rowHeight;
        _tableview.backgroundColor = BlackLeverColor1;
        _tableview.delegate = self;
        
        _tableview.sectionHeaderHeight = sectionHeaderHeight;
        _tableview.estimatedSectionHeaderHeight = sectionHeaderHeight;
        
        _tableview.sectionFooterHeight = sectionFooterHeight;
        _tableview.estimatedSectionFooterHeight = sectionFooterHeight;
        
        _tableview.tableFooterView = self.defaultFooterView;
    }
    [self.view addSubview:self.tableview];
}

- (void)getListData:(void (^)(void))requestComplete
{
    requestComplete();
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
    [self.tableview reloadData];
    if (self.tableview.mj_footer) {
        self.dataCount = self.dataArray.count;
        if (self.dataCount < 10) {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
            [(MJRefreshAutoNormalFooter *)self.tableview.mj_footer setHidden:YES];
        }
        else
        {
            [self.tableview.mj_footer resetNoMoreData];
            [(MJRefreshAutoNormalFooter *)self.tableview.mj_footer setHidden:NO];
        }
    }
}
@end
