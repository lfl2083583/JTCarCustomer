//
//  JTNearbyContactsViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/14.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTUserTableViewCell.h"
#import "JTDeviceAccess.h"

#import "JTNearbyContactsViewController.h"
#import "JTCardViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation JTNearbyContactsHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.bounds.size.width - 22 , 40)];
        _leftLabel.font = Font(24);
    }
    return _leftLabel;
}

@end

@interface JTNearbyContactsViewController () <UITableViewDataSource, CLLocationManagerDelegate>
{
    CLLocationManager *loctionManager;
    NSString *lat;
    NSString *lng;
}

@property (nonatomic, strong) JTNearbyContactsHeadView *headView;
@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, assign) NSInteger gender;

@end

@implementation JTNearbyContactsViewController

- (void)dealloc {
    [loctionManager stopUpdatingLocation];
    loctionManager = nil;
    CCLOG(@"JTNearbyContactsViewController销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight+self.headView.height, self.headView.width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-self.headView.height) rowHeight:70 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self setShowTableRefreshHeader:YES];
    [self setShowTableRefreshFooter:YES];
    self.view.backgroundColor = WhiteColor;
    [self.tableview registerClass:[JTUserTableViewCell class] forCellReuseIdentifier:userTableViewIndentifier];
    [self.view addSubview:self.tipLB];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick:)];
    
    __weak typeof(self)weakSelf = self;
    [JTDeviceAccess checkLocationEnable:@"" result:^(BOOL result) {
        if (result) {
            loctionManager = [[CLLocationManager alloc] init];
            loctionManager.delegate = weakSelf;
            [loctionManager requestAlwaysAuthorization];
            [loctionManager requestWhenInUseAuthorization];
            loctionManager.desiredAccuracy = kCLLocationAccuracyBest;
            loctionManager.distanceFilter = 5.0;
            [loctionManager startUpdatingLocation];
        }
    }];
    
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetNearbyUserApi) parameters:@{@"lng" : lng?lng:@"0",@"lat" : lat?lat:@"0",@"gender" : @(self.gender), @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.gender = NIMUserGenderFemale;
        [weakSelf.tableview.mj_header beginRefreshing];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.gender = NIMUserGenderMale;
        [weakSelf.tableview.mj_header beginRefreshing];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"不限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.gender = NIMUserGenderUnknown;
        [weakSelf.tableview.mj_header beginRefreshing];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userTableViewIndentifier];
    [cell configUserCellWithUserInfo:self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"uid"]]] animated:YES];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.gender = NIMUserGenderUnknown;
    [self staticRefreshFirstTableListData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [loctionManager stopUpdatingLocation];
    CLLocation *currentLoction = [locations lastObject];
    lng = [NSString stringWithFormat:@"%.2f",currentLoction.coordinate.longitude];
    lat = [NSString stringWithFormat:@"%.2f",currentLoction.coordinate.latitude];
    self.gender = NIMUserGenderUnknown;
    [self staticRefreshFirstTableListData];
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"附近暂时没有用户~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

- (JTNearbyContactsHeadView *)headView {
    if (!_headView) {
        _headView = [[JTNearbyContactsHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 40)];
        _headView.leftLabel.text = @"附近的人";
    }
    return _headView;
}
@end
