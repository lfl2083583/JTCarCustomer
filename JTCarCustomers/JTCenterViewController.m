//
//  JTCenterViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTCenterHeadView.h"
#import "JTNormalUserInfo.h"
#import "JTPersonQRView.h"

#import "JTCardViewController.h"
#import "JTCenterViewController.h"
#import "JTPersonalViewController.h"
#import "JTWalletViewController.h"
#import "JTUserInfoViewController.h"
#import "JTScanQRViewController.h"
#import "JTSettingViewController.h"
#import "JTActivityJoinViewController.h"
#import "JTCollectionViewController.h"
#import "JTOrderContainerViewController.h"
#import "UIViewController+MMDrawerController.h"


@interface JTCenterViewController () <UITableViewDataSource, JTCenterHeadViewDelegate>

@property (nonatomic, strong) JTCenterHeadView *headView;
@property (nonatomic, strong) JTCenterFootView *footView;

@end

@implementation JTCenterViewController

- (void)dealloc {
    CCLOG(@"JTCenterViewController销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserInfoUpdateNotificationName object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeFullScreen rowHeight:60];
    [self.tableview setDataSource:self];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.tableHeaderView = self.headView;
    self.tableview.tableFooterView = self.footView;
    [self setupComponent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdateNotification:) name:kUserInfoUpdateNotificationName object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self requestForUserInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableview scrollRectToVisible:self.view.bounds animated:YES];
}

- (void)setupComponent {
    JTWordItem *item1 = [self createItemIcon:@"center_activity_icon" title:@"参与的活动"];
    JTWordItem *item2 = [self createItemIcon:@"center_collection_icon" title:@"收藏"];
    JTWordItem *item3 = [self createItemIcon:@"center_list_icon" title:@"我的订单"];
    JTWordItem *item4 = [self createItemIcon:@"center_wallet_icon" title:@"钱包"];
    JTWordItem *item5 = [self createItemIcon:@"center_sweep_icon" title:@"扫一扫"];
    JTWordItem *item6 = [self createItemIcon:@"center_set_icon" title:@"设置"];
    self.dataArray = [NSMutableArray arrayWithArray:@[item1, item2, item3, item4, item5, item6]];
    
}

- (JTWordItem *)createItemIcon:(NSString *)icon title:(NSString *)title {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.image = [UIImage imageNamed:icon];
    item.title = title;
    return item;
}

- (void)userInfoUpdateNotification:(NSNotification *)notification {
    [self requestForUserInfo];
}

- (void)requestForUserInfo {
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserInfoApi) parameters:@{@"uid" : [JTUserInfo shareUserInfo].userID} success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            JTUserInfo *userInfo = [JTUserInfo mj_objectWithKeyValues:responseObject[@"user"]];
            userInfo.userTags = responseObject[@"label"];
            userInfo.userBullet = responseObject[@"barrage"];
            userInfo.relateTags = responseObject[@"label_related"];
            userInfo.userAblum = responseObject[@"album"];
            userInfo.userBalance = [responseObject[@"account"][@"baccount"] doubleValue];
            NSArray *array = responseObject[@"bind"];
            userInfo.isBindWeiChat = (array && [array isKindOfClass:[NSArray class]] && [array containsObject:@(1)])?YES:NO;
            userInfo.isBindQQ = (array && [array isKindOfClass:[NSArray class]] && [array containsObject:@(2)])?YES:NO;
            [userInfo save];
            [weakSelf.headView refreshHeadViewData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(16);
        cell.textLabel.textColor = BlackLeverColor5;
    }
    JTWordItem *item = self.dataArray[indexPath.row];
    cell.imageView.image = item.image;
    cell.textLabel.text = item.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.row];
    UIViewController *vc;
    if ([item.title isEqualToString:@"参与的活动"])
    {
        vc = [[JTActivityJoinViewController alloc] init];
    }
    else if ([item.title isEqualToString:@"收藏"])
    {
        vc = [[JTCollectionViewController alloc] init];
    }
    else if ([item.title isEqualToString:@"我的订单"])
    {
        vc = [[JTOrderContainerViewController alloc] init];
    }
    else if ([item.title isEqualToString:@"钱包"])
    {
        vc = [[JTWalletViewController alloc] init];
    }
    else if ([item.title isEqualToString:@"扫一扫"])
    {
        vc = [[JTScanQRViewController alloc] init];
    }
    else if ([item.title isEqualToString:@"设置"])
    {
        vc = [[JTSettingViewController alloc] init];
    }
    else
    {
        
    }
    __weak typeof(self)weakSelf  = self;
    UINavigationController *currentNav = [(UITabBarController *)self.mm_drawerController.centerViewController selectedViewController];
    [currentNav pushViewController:vc animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [weakSelf.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

#pragma mark JTCenterHeadViewDelegate
- (void)headViewAvatarClick {
    __weak typeof(self)weakSelf  = self;
    JTCardViewController *cardlVC = [[JTCardViewController alloc] initWithUserID:[JTUserInfo shareUserInfo].userID];
    UINavigationController *currentNav = [(UITabBarController *)self.mm_drawerController.centerViewController selectedViewController];
    [currentNav pushViewController:cardlVC animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [weakSelf.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

- (void)headViewQRClick {
    [[Utility mainWindow] presentView:[[[NSBundle mainBundle] loadNibNamed:@"JTPersonQRView" owner:nil options:nil] lastObject] animated:YES completion:nil];
}

- (JTCenterHeadView *)headView {
    if (!_headView) {
        _headView = [[JTCenterHeadView alloc] initWithFrame:CGRectMake(0, 0, 258.0 * App_Frame_Width / 375, 220)];
        _headView.delegate = self;
    }
    return _headView;
}

- (JTCenterFootView *)footView {
    if (!_footView) {
        _footView = [[JTCenterFootView alloc] initWithFrame:CGRectMake(0, 0, 258.0 * App_Frame_Width / 375, 78)];
    }
    return _footView;
}
@end

