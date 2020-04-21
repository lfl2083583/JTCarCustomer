//
//  JTNearbyTeamViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTNearbyTeamViewController.h"
#import "JTNearbyTeamTableViewCell.h"
#import "JTNearbyTeamTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTTeamInfoViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface JTNearbyTeamViewController () <JTNearbyTeamTableViewCellDelegate, UITableViewDataSource, CLLocationManagerDelegate>

{
    CLLocationManager *loctionManager;
    NSString *lat;
    NSString *lng;
}
@property (nonatomic, strong) UILabel *tipLB;

@end

@implementation JTNearbyTeamViewController

- (void)dealloc {
    [loctionManager stopUpdatingLocation];
    loctionManager = nil;
    CCLOG(@"JTNearbyTeamViewController销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tipLB];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kTopBarHeight+44, App_Frame_Width, APP_Frame_Height-kTopBarHeight*3-60-kStatusBarHeight) rowHeight:70 sectionHeaderHeight:0 sectionFooterHeight:0];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = BlackLeverColor1;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[JTNearbyTeamTableViewCell class] forCellReuseIdentifier:nearbyTeamCellID];
    self.showTableRefreshFooter = YES;
    self.showTableRefreshHeader = YES;
    
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
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(NearbyTeamApi) parameters:@{@"lng" : lng?lng:@"0", @"lat" : lat?lat:@"0", @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        NSArray *array = responseObject[@"list"];
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (array && [array isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

#pragma mark UITableViewDateSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTNearbyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nearbyTeamCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *teamInfo = self.dataArray[indexPath.row];
    [cell configNearbyCellWithTeamInfo:teamInfo indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *teamInfo = self.dataArray[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:nearbyTeamCellID cacheByIndexPath:indexPath configuration:^(JTNearbyTeamTableViewCell *cell) {
        [cell configNearbyCellWithTeamInfo:teamInfo indexPath:indexPath];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *teamInfo = self.dataArray[indexPath.row];
    NSString *teamID = [NSString stringWithFormat:@"%@",teamInfo[@"group_id"]];
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:teamID];
    if (team) {
        [self.parentController.navigationController pushViewController:[[JTTeamInfoViewController alloc] initWithTeam:team] animated:YES];
    }
}

#pragma mark JTNearbyTeamTableViewCellDelegate
- (void)tableCellRightBtnClick:(NSIndexPath *)indexPath {
    NSDictionary *teamInfo = self.dataArray[indexPath.row];
    NSString *teamID = [NSString stringWithFormat:@"%@",teamInfo[@"group_id"]];
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:teamID];
    if (team) {
        [self.parentController.navigationController pushViewController:[[JTTeamInfoViewController alloc] initWithTeam:team] animated:YES];
    } 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.tableview.mj_header beginRefreshing];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [loctionManager stopUpdatingLocation];
    CLLocation *currentLoction = [locations lastObject];
    lng = [NSString stringWithFormat:@"%.2f",currentLoction.coordinate.longitude];
    lat = [NSString stringWithFormat:@"%.2f",currentLoction.coordinate.latitude];
    [self.tableview.mj_header beginRefreshing];
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"附近暂时没有群聊~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

@end
