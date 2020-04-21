//
//  JTActivityViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTCirlceImageView.h"
#import "JTActivityCardView.h"
#import "JTActivityCardHeadView.h"
#import "JTActivityViewController.h"
#import "JTActivityDetailViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface JTActivityViewController () <JTActivityCardViewDelegate>

@property (nonatomic, strong) JTActivityCardHeadView *cardHeadView;
@property (nonatomic, strong) JTActivityCardView *cardView;
@property (nonatomic, strong) ZTCirlceImageView *avatarBT;

@property (nonatomic, copy) NSString *webUrl;

@end

@implementation JTActivityViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangeNotification object:nil];
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

- (JTActivityCardView *)cardView {
    if (!_cardView) {
        _cardView = [[JTActivityCardView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cardHeadView.frame), App_Frame_Width, APP_Frame_Height-CGRectGetMaxY(self.cardHeadView.frame))];
        _cardView.delegate = self;
    }
    return _cardView;
}

- (JTActivityCardHeadView *)cardHeadView {
    if (!_cardHeadView) {
        _cardHeadView = [[JTActivityCardHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 110)];
    }
    return _cardHeadView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"发现活动";
    [self.view addSubview:self.cardHeadView];
    [self.view addSubview:self.cardView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.avatarBT];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChangeNotification:) name:kLoginStatusChangeNotification object:nil];
    [self requestActivityDatas];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updataUI];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.hidesBottomBarWhenPushed) {
        self.hidesBottomBarWhenPushed = NO;
    }
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestActivityDatas {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ActivityListApi) parameters:nil cacheEnabled:YES success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
            weakSelf.cardView.dataArray = weakSelf.dataArray;
            weakSelf.webUrl = responseObject[@"h5_url"];
            [weakSelf.cardHeadView configActivityCardHeadViewWithInfo:[weakSelf.dataArray firstObject]];
            [weakSelf.cardView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loginStatusChangeNotification:(NSNotification *)notification
{
    [self updataUI];
}

- (void)updataUI {
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self.avatarBT setAvatarByUrlString:[[JTUserInfo shareUserInfo].userAvatar avatarHandleWithSquare:self.avatarBT.height*2] defaultImage:DefaultSmallAvatar];
    }
    else
    {
        [self.avatarBT setImage:DefaultSmallAvatar];
    }
}

#pragma mark JTActivityCardViewDelegate
- (void)cardView:(UIView *)cardView topCardClick:(id)cardInfo; {
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    JTActivityDetailViewController *detailVC = [[JTActivityDetailViewController alloc] initWithActivityID:cardInfo[@"activity_id"]];
    detailVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:detailVC animated:NO];
}

- (void)cardViewSwipeTopIndex:(NSInteger)index {
    if (index == 0) {
        self.cardHeadView.slideLoction = JTSlideLoctionLeft;
    }
    else if (index == self.dataArray.count-1)
    {
        self.cardHeadView.slideLoction = JTSlideLoctionRight;
    }
    else
    {
        self.cardHeadView.slideLoction = JTSlideLoctionCenter;
    }
    [self.cardHeadView configActivityCardHeadViewWithInfo:self.dataArray[index]];
}

- (void)cardViewSwipeBeginRefreshData {
    [self requestActivityDatas];
}

@end
