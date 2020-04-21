//
//  JTStoreViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UINavigationBar+Awesome.h"
#import "SwipeTableView.h"
#import "JTStoreHeaderView.h"
#import "ZTSegmentedControl.h"
#import "JTStoreTableView.h"
#import "UIImage+Extension.h"

#import "JTMyLoveCarViewController.h"
#import "JTAddCarViewController.h"
#import "JTSmartMaintenanceViewController.h"
#import "JTFaultCheckViewController.h"
#import "JTRescueViewController.h"
#import "JTParkingLotViewController.h"
#import "JTStoreDetailViewController.h"

#define kSTRefreshHeaderHeight  60

@interface JTStoreViewController () <SwipeTableViewDelegate, SwipeTableViewDataSource, JTStoreHeaderViewDelegate, JTStoreTableViewDelegate>
{
    CGFloat alpha;
    CGFloat swipeTableViewOffsetY;
}

@property (nonatomic, strong) SwipeTableView *swipeTableView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) ZTCirlceImageView *avatarBT;
@property (nonatomic, strong) JTStoreHeaderView *headerView;
@property (nonatomic, strong) ZTSegmentedControl *segmentedControl;

@end

@implementation JTStoreViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateMyCarListNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar zt_setBlackLineHidden:YES];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: Font(14), NSForegroundColorAttributeName: WhiteColor} forState:UIControlStateNormal];
    [self.navigationController.navigationBar zt_setBackgroundColor:[BlueLeverColor1 colorWithAlphaComponent:alpha]];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.hidesBottomBarWhenPushed) {
        self.hidesBottomBarWhenPushed = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar zt_setBlackLineHidden:NO];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: Font(14), NSForegroundColorAttributeName: BlackLeverColor3} forState:UIControlStateNormal];
    [self.navigationController.navigationBar zt_setBackgroundColor:[BlueLeverColor1 colorWithAlphaComponent:0]];
    [super viewWillDisappear:animated];
}

- (void)leftClick
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self.view endEditing:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
    }
}

- (void)rightClick:(id)sender
{
    [self.navigationController pushViewController:[[JTMyLoveCarViewController alloc] init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WhiteColor];
    [self.view addSubview:self.swipeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChangeNotification:) name:kLoginStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyCarListNotification:) name:kUpdateMyCarListNotification object:nil];
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self requestMyCarList];
    }
    swipeTableViewOffsetY = self.swipeTableView.currentItemView.contentOffset.y;
    self.navigationItem.titleView = self.titleLB;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的爱车" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.avatarBT];
}

- (void)loginStatusChangeNotification:(NSNotification *)notification
{
    [self reloadData];
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self requestMyCarList];
    }
}

- (void)updateMyCarListNotification:(NSNotification *)notification
{
    [self.headerView reloadData];
}

- (void)reloadData
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self.avatarBT setAvatarByUrlString:[[JTUserInfo shareUserInfo].userAvatar avatarHandleWithSquare:self.avatarBT.height*2] defaultImage:DefaultSmallAvatar];
    }
    else
    {
        [self.avatarBT setImage:DefaultSmallAvatar];
    };
}

- (void)requestMyCarList
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarApi) parameters:nil success:^(id responseObject, ResponseState state) {
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [[JTUserInfo shareUserInfo] addCarModels:[JTCarModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        }
        [[JTUserInfo shareUserInfo] save];
        [weakself.headerView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (SwipeTableView *)swipeTableView
{
    if (!_swipeTableView) {
        _swipeTableView = [[SwipeTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kBottomBarHeight)];
        _swipeTableView.delegate = self;
        _swipeTableView.dataSource = self;
        _swipeTableView.swipeHeaderView = self.headerView;
        _swipeTableView.swipeHeaderBar = self.segmentedControl;
        _swipeTableView.shouldAdjustContentSize = YES;
        _swipeTableView.swipeHeaderTopInset = kStatusBarHeight + kTopBarHeight;
    }
    return _swipeTableView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = Font(18);
        _titleLB.textColor = WhiteColor;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = @"门店";
        [_titleLB sizeToFit];
    }
    return _titleLB;
}

- (ZTCirlceImageView *)avatarBT
{
    if (!_avatarBT) {
        _avatarBT = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _avatarBT.userInteractionEnabled = YES;
        [_avatarBT addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarBT;
}

- (JTStoreHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTStoreHeaderView alloc] initWithStoreHeaderViewDelegate:self];
    }
    return _headerView;
}

- (ZTSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"距离最近", @"好评度"]];
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

#pragma mark SwipeTableViewDataSource
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView
{
    return 2;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view
{
    JTStoreTableView *storeTableView = (JTStoreTableView *)view;
    if (nil == storeTableView) {
        storeTableView = [[JTStoreTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kBottomBarHeight) style:UITableViewStylePlain];
    }
    storeTableView.scrollDelegate = self;
    storeTableView.type = index + 1;
    return storeTableView;
}

#pragma mark SwipeTableViewDelegate
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    self.segmentedControl.selectedSegmentIndex = swipeView.currentItemIndex;
}

- (void)storeHeaderView:(JTStoreHeaderView *)storeHeaderView didSelectHeaderAtType:(JTStoreHeaderClickType)storeHeaderClickType
{
    switch (storeHeaderClickType) {
        case JTStoreHeaderClickTypeCar:
        {
            if ([JTUserInfo shareUserInfo].myCarList.count == 0) {
                [self.navigationController pushViewController:[[JTAddCarViewController alloc] init] animated:YES];
            }
            else
            {
                [self.navigationController pushViewController:[[JTMyLoveCarViewController alloc] init] animated:YES];
            }
        }
            break;
        case JTStoreHeaderClickTypeMaintain:
        {
            if ([JTUserInfo shareUserInfo].myCarList.count == 0) {
                [self.navigationController pushViewController:[[JTAddCarViewController alloc] initWithAddCarType:JTAddCarTypeMaintain] animated:YES];
            }
            else
            {
               [self.navigationController pushViewController:[[JTSmartMaintenanceViewController alloc] initWithCarModel:[[JTUserInfo shareUserInfo].myCarList objectAtIndex:0]] animated:YES];
            }
        }
            break;
        case JTStoreHeaderClickTypeFault:
        {
            [self.navigationController pushViewController:[[JTFaultCheckViewController alloc] init] animated:YES];
        }
            break;
        case JTStoreHeaderClickTypeRescue:
        {
            [self.navigationController pushViewController:[[JTRescueViewController alloc] initWithNibName:@"JTRescueViewController" bundle:nil] animated:YES];
        }
            break;
        case JTStoreHeaderClickTypeParkingLot:
        {
            if ([JTUserInfo shareUserInfo].myCarList.count == 0) {
                [self.navigationController pushViewController:[[JTAddCarViewController alloc] initWithAddCarType:JTAddCarTypeParkingLot] animated:YES];
            }
            else
            {
                [self.navigationController pushViewController:[[JTParkingLotViewController alloc] init] animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)storeTableView:(JTStoreTableView *)storeTableView didSelectRowStoreModel:(JTStoreModel *)storeModel {
    [self.navigationController pushViewController:[[JTStoreDetailViewController alloc] initWithModel:storeModel] animated:YES];
}

- (void)storeTableViewDidScroll:(UIScrollView *)scrollView
{
    if (swipeTableViewOffsetY == 0) {
        [self.navigationController.navigationBar zt_setBackgroundColor:[BlueLeverColor1 colorWithAlphaComponent:0]];
    }
    else
    {
        alpha = MIN(1, (scrollView.contentOffset.y - swipeTableViewOffsetY) / (fabs(swipeTableViewOffsetY) - self.swipeTableView.swipeHeaderBar.height));
        [self.navigationController.navigationBar zt_setBackgroundColor:[BlueLeverColor1 colorWithAlphaComponent:alpha]];
    }
}
@end
