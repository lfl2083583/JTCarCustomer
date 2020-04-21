//
//  JTStoreDetailViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreDetailViewController.h"
#import "SwipeTableView.h"
#import "JTStoreDetailHeaderView.h"
#import "JTStoreServiceCollectionView.h"
#import "JTStoreCommentTableView.h"
#import "JTStoreInformationTableView.h"
#import "ZTSegmentedControl.h"
#import "JTShareTool.h"
#import "JTMessageMaker.h"
#import "NSObject+ZTExtension.h"
#import "JTMapMarkViewController.h"

@interface JTStoreDetailViewController () <SwipeTableViewDelegate, SwipeTableViewDataSource, JTStoreDetailHeaderViewDelegate>

@property (nonatomic, strong) SwipeTableView *swipeTableView;
@property (nonatomic, strong) JTStoreDetailHeaderView *headerView;
@property (nonatomic, strong) JTStoreServiceCollectionView *storeServiceCollectionView;
@property (nonatomic, strong) JTStoreCommentTableView *storeCommentTableView;
@property (nonatomic, strong) JTStoreInformationTableView *storeInformationTableView;
@property (nonatomic, strong) ZTSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray<JTStoreSeviceClassModel *> *storeSeviceClassModels;

@end

@implementation JTStoreDetailViewController

- (instancetype)initWithModel:(JTStoreModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
        _storeID = model.storeID;
    }
    return self;
}

- (instancetype)initWithStoreID:(NSString *)storeID
{
    self = [super init];
    if (self) {
        _storeID = storeID;
    }
    return self;
}

- (void)rightClick:(id)sender
{
    if (!self.headerView.model) {
        return;
    }
    __weak typeof(self) weakself = self;
    [JTShareTool instance].shareContentType = JTShareContentTypeUrl;
    [[JTShareTool instance] shareInfo:@{ShareUrl: self.headerView.model.h5Url, ShareTitle: self.headerView.model.name, ShareDescribe : self.headerView.model.address, ShareThumbURL : self.headerView.model.logo} result:^(NSError *error, JTSharePlatformType platformType) {
        
        NIMMessage *message = [JTMessageMaker messageWithShop:weakself.headerView.model.storeID coverUrl:weakself.headerView.model.logo name:weakself.headerView.model.name score:weakself.headerView.model.score time:weakself.headerView.model.time address:weakself.headerView.model.address];
        
        if (platformType == JTSharePlatformTypeFriend) {
            NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=1", kJTCarCustomersScheme, JTPlatformSendNormalMessage, [message zt_string]];
            [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
        }
        else if (platformType == JTSharePlatformTypeTeam)
        {
            NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=2", kJTCarCustomersScheme, JTPlatformSendNormalMessage, [message zt_string]];
            [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
        }
        else
        {
//            if (!error) {
//                [weakSelf handleShareSuccess:platformType+3];
//            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WhiteColor];
    [self.view addSubview:self.swipeTableView];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(StoreDetailsApi) parameters:@{@"store_id": self.storeID} success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject objectForKey:@"info"]) {
            weakself.headerView.model = [JTStoreModel mj_objectWithKeyValues:responseObject[@"info"]];
        }
        if (responseObject && [responseObject objectForKey:@"category"]) {
            [weakself.storeSeviceClassModels addObjectsFromArray:[JTStoreSeviceClassModel mj_objectArrayWithKeyValuesArray:responseObject[@"category"]]];
        }
        weakself.storeServiceCollectionView.storeSeviceClassModels = weakself.storeSeviceClassModels;
        if (responseObject && [responseObject objectForKey:@"seller"]) {
            weakself.storeInformationTableView.model = [JTStoreInformationModel mj_objectWithKeyValues:responseObject[@"seller"]];
        }
        [weakself.swipeTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    self.navigationItem.title = @"店铺详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"activity_forward_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark SwipeTableViewDataSource
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView
{
    return 3;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view
{
    if (index == 0) {
        return self.storeServiceCollectionView;
    }
    else if (index == 1) {
        return self.storeCommentTableView;
    }
    else
    {
        return self.storeInformationTableView;
    }
}

#pragma mark SwipeTableViewDelegate
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    self.segmentedControl.selectedSegmentIndex = swipeView.currentItemIndex;
}

- (void)storeDetailHeaderView:(JTStoreDetailHeaderView *)storeDetailHeaderView didSelectHeaderAtType:(JTStoreDetailHeaderClickType)storeDetailHeaderClickType
{
    if (storeDetailHeaderClickType == JTStoreDetailHeaderClickTypeNavigation) {
        JTMapMarkViewController *mapMarkVC = [[JTMapMarkViewController alloc] initWithLocation:storeDetailHeaderView.model.latitude longitude:storeDetailHeaderView.model.longitude title:storeDetailHeaderView.model.name subTitle:storeDetailHeaderView.model.address];
        [self.navigationController pushViewController:mapMarkVC animated:YES];
    }
    else if (storeDetailHeaderClickType == JTStoreDetailHeaderClickTypeCollection) {
        __weak typeof(self) weakself = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(StoreFavoriteApi) parameters:@{@"store_id": self.storeID} success:^(id responseObject, ResponseState state) {
            weakself.headerView.model.is_favorite = !weakself.headerView.model.is_favorite;
            weakself.headerView.collectionBT.selected = weakself.headerView.model.is_favorite;
            [[HUDTool shareHUDTool] showHint:weakself.headerView.model.is_favorite?@"收藏成功,您可以在我的个人中心--收藏中查看了":@"已取消收藏"];
            [weakself.headerView.collectionBT centerImageAndTitle];
        } failure:^(NSError *error) {
        }];
    }
}

- (SwipeTableView *)swipeTableView
{
    if (!_swipeTableView) {
        _swipeTableView = [[SwipeTableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight)];
        _swipeTableView.delegate = self;
        _swipeTableView.dataSource = self;
        _swipeTableView.swipeHeaderView = self.headerView;
        _swipeTableView.swipeHeaderBar = self.segmentedControl;
        _swipeTableView.shouldAdjustContentSize = YES;
        _swipeTableView.swipeHeaderTopInset = 0;
        _swipeTableView.clipsToBounds = YES;
    }
    return _swipeTableView;
}

- (JTStoreDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTStoreDetailHeaderView alloc] initWithStoreDetailHeaderViewDelegate:self];
    }
    return _headerView;
}

- (JTStoreServiceCollectionView *)storeServiceCollectionView
{
    if (!_storeServiceCollectionView) {
        _storeServiceCollectionView = [[JTStoreServiceCollectionView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _storeServiceCollectionView.storeID = self.storeID;
    }
    return _storeServiceCollectionView;
}

- (JTStoreCommentTableView *)storeCommentTableView
{
    if (!_storeCommentTableView) {
        _storeCommentTableView = [[JTStoreCommentTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) style:UITableViewStyleGrouped];
        _storeCommentTableView.storeID = self.storeID;
    }
    return _storeCommentTableView;
}

- (JTStoreInformationTableView *)storeInformationTableView
{
    if (!_storeInformationTableView) {
        _storeInformationTableView = [[JTStoreInformationTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) style:UITableViewStyleGrouped];
    }
    return _storeInformationTableView;
}

- (ZTSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"服务项目", @"评价", @"商家"]];
        _segmentedControl.frame = CGRectMake(0, 0, self.swipeTableView.width, 44);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                  NSForegroundColorAttributeName : BlackLeverColor3,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                          NSForegroundColorAttributeName : BlackLeverColor6,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlackLeverColor6;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.backgroundColor = WhiteColor;
        _segmentedControl.showHorizonLine = YES;
        __weak typeof(self) weakself = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            [weakself.swipeTableView scrollToItemAtIndex:index animated:YES];
        };
    }
    return _segmentedControl;
}

- (NSMutableArray<JTStoreSeviceClassModel *> *)storeSeviceClassModels
{
    if (!_storeSeviceClassModels) {
        _storeSeviceClassModels = [NSMutableArray array];
    }
    return _storeSeviceClassModels;
}
@end
