//
//  JTMapPositionViewController.m
//  JTSocial
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTMapPositionViewController.h"
#import <MapKit/MapKit.h>
#import "JTMessageMaker.h"
//#import "JTResultsViewController.h"

@interface JTMapPositionViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UISearchControllerDelegate>
{
    BOOL isInvalidUpdate;
}
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UISearchController *searchController;
//@property (nonatomic, strong) JTResultsViewController *resultsController;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation JTMapPositionViewController

- (void)dealloc
{
    NSLog(@"释放 JTMapPositionViewController");
    [self.mapView setDelegate:nil];
    [self.tableview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (instancetype)initWithPlace:(NSString *)place mapType:(JTMapType)mapType
{
    self = [super init];
    if (self) {
        self.place = place;
        self.mapType = mapType;
    }
    return self;
}

- (void)leftClick:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightClick:(id)sender
{
    if (self.mapPositionViewControllerBlock && self.dataArray.count > 0) {
        NSDictionary *source = [self.dataArray objectAtIndex:self.selectIndex];
        NSArray *coordinateArray = [source[@"location"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        CLLocationDegrees latitude = [[coordinateArray objectAtIndex:1] doubleValue];
        CLLocationDegrees longitude = [[coordinateArray objectAtIndex:0] doubleValue];
        NIMMessage *message = [JTMessageMaker messageWithLocation:latitude longitude:longitude title:[NSString stringWithFormat:@"%@&&&&&&%@", source[@"name"], source[@"address"]]];
        self.mapPositionViewControllerBlock(message);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self.navigationItem setTitle:@"位置"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:(self.mapType == JTMapTypeSession)?@"发送":@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)]];
    [self.view addSubview:self.tableHeaderView];
    [self.tableHeaderView addSubview:self.searchController.searchBar];
    [self.view addSubview:self.mapView];
    [self.mapView addAnnotation:self.annotation];
    [self createTalbeView:UITableViewStylePlain rowHeight:50];
    [self.tableview setFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), App_Frame_Width, APP_Frame_Height-CGRectGetMaxY(self.mapView.frame))];
    [self.tableview setDataSource:self];
    [self.tableview addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self setShowTableRefreshFooter:YES];
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            [[HUDTool shareHUDTool] showHint:@"请在设置-隐私里允许程序使用地理位置服务"];
        }
        else
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    } else {
        [[HUDTool shareHUDTool] showHint:@"请打开地理位置服务"];
    }
    [self.mapView addGestureRecognizer:self.panGesture];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!isInvalidUpdate) {
        [self.annotation setCoordinate:userLocation.coordinate];
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250) animated:NO];
        [self staticRefreshFirstTableListData];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    isInvalidUpdate = YES;
    if (pan.state == UIGestureRecognizerStateBegan) {
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
             pan.state == UIGestureRecognizerStateCancelled ||
             pan.state == UIGestureRecognizerStateFailed ||
             pan.state == UIGestureRecognizerStateRecognized) {
        [self.annotation setCoordinate:self.mapView.region.center];
        [self setSelectIndex:0];
        [self staticRefreshFirstTableListData];
    }
}

- (void)getListData:(void (^)(void))requestComplete
{
    NSString *location = [NSString stringWithFormat:@"%f,%f", self.mapView.region.center.latitude, self.mapView.region.center.longitude];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:LBS_Key forKey:@"key"];
    [parameters setObject:location forKey:@"location"];
    if (self.place && ![self.place isBlankString]) {
        [parameters setObject:self.place forKey:@"keywords"];
    }
    [parameters setObject:@"2000" forKey:@"radius"];
    [parameters setObject:@"weight" forKey:@"sortrule"];
    [parameters setObject:@"20" forKey:@"offset"];
    [parameters setObject:@(self.page) forKey:@"page"];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:LBS_SearchApi parameters:parameters success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1)
        {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:weakself.mapView.region.center.latitude
                                                              longitude:weakself.mapView.region.center.longitude];

            [weakself.geocoder reverseGeocodeLocation:location
                                    completionHandler:^(NSArray *placemarks, NSError *error)
             {
                 [weakself.dataArray removeAllObjects];
                 [weakself.tableview reloadData];
                 if (error == nil) {
                     if (placemarks.count > 0) {
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
                         if (placemark) {
                             [weakself.dataArray addObject:@{@"name": placemark.name, @"address": placemark.title, @"location": [NSString stringWithFormat:@"%lf,%lf", weakself.mapView.region.center.longitude, weakself.mapView.region.center.latitude]}];
                         }
                     }
                     if ([responseObject objectForKey:@"pois"] && [responseObject[@"pois"] isKindOfClass:[NSArray class]]) {
                         [weakself.dataArray addObjectsFromArray:responseObject[@"pois"]];
                     }
                 }
                 [weakself.geocoder cancelGeocode];
                 dispatch_main_async_safe(^{
                     [super getListData:requestComplete];
                 });
             }];
        }
        else
        {
            if ([responseObject objectForKey:@"pois"] && [responseObject[@"pois"] isKindOfClass:[NSArray class]]) {
                [weakself.dataArray addObjectsFromArray:responseObject[@"pois"]];
            }
            [super getListData:requestComplete];
        }
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(15);
        cell.textLabel.textColor = BlackLeverColor5;
        cell.detailTextLabel.font = Font(12);
        cell.detailTextLabel.textColor = BlackLeverColor3;
    }
    NSDictionary *source = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = source[@"name"];
    cell.detailTextLabel.text = [source[@"address"] isKindOfClass:[NSString class]]?source[@"address"]:source[@"adname"];
    cell.accessoryType = (indexPath.row == self.selectIndex)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > indexPath.row) {
        self.selectIndex = indexPath.row;
        NSDictionary *source = [self.dataArray objectAtIndex:self.selectIndex];
        
        NSArray *coordinateArray = [source[@"location"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        CLLocationDegrees latitude = [[coordinateArray objectAtIndex:1] doubleValue];
        CLLocationDegrees longitude = [[coordinateArray objectAtIndex:0] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                          longitude:longitude];
        isInvalidUpdate = YES;
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 250, 250) animated:YES];
        [self.annotation setCoordinate:location.coordinate];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
//    self.resultsController.region = self.mapView.region;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 animations:^{
        weakself.mapView.top = kStatusBarHeight+kTopBarHeight;
        weakself.tableview.top = CGRectGetMaxY(weakself.mapView.frame);
    }];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 animations:^{
        weakself.mapView.top = CGRectGetMaxY(weakself.tableHeaderView.frame);
        weakself.tableview.top = CGRectGetMaxY(weakself.mapView.frame);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(__unused id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat oldOffsetY          = [change[NSKeyValueChangeOldKey] CGPointValue].y;
    CGFloat newOffsetY          = [change[NSKeyValueChangeNewKey] CGPointValue].y;
    CGFloat deltaY              = newOffsetY - oldOffsetY;
    
    if(deltaY >= 0) {
        if (self.tableview.contentOffset.y > 10) {
            if (self.tableview.top == App_Frame_Width) {
                __weak typeof(self) weakself= self;
                [UIView animateWithDuration:.3 animations:^{
                    weakself.mapView.height = App_Frame_Width-CGRectGetMaxY(weakself.tableHeaderView.frame)-100;
                    weakself.tableview.top = CGRectGetMaxY(weakself.mapView.frame);
                    weakself.tableview.height = APP_Frame_Height-CGRectGetMaxY(weakself.mapView.frame);
                }];
            }
        }
    } else {
        if (self.tableview.contentOffset.y < -10) {
            if (self.tableview.top == App_Frame_Width - 100) {
                __weak typeof(self) weakself= self;
                [UIView animateWithDuration:.3 animations:^{
                    weakself.mapView.height = App_Frame_Width-CGRectGetMaxY(weakself.tableHeaderView.frame);
                    weakself.tableview.top = CGRectGetMaxY(weakself.mapView.frame);
                    weakself.tableview.height = APP_Frame_Height-CGRectGetMaxY(weakself.mapView.frame);
                }];
            }
        }
    }
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsController];
//        _searchController.searchResultsUpdater = self.resultsController;
        _searchController.searchBar.placeholder = @"搜索地点";
        _searchController.delegate = self;
        _searchController.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IOS11?56:44);
    }
    return _searchController;
}

//- (JTResultsViewController *)resultsController
//{
//    if (!_resultsController) {
//        _resultsController = [[JTResultsViewController alloc] init];
//        _resultsController.searchType = JTSearchTypeLocation;
//        __weak typeof(self) weakself = self;
//        [_resultsController setSearchChoiceBlock:^(id info, JTSearchType searchType) {
//            [weakself.searchController setActive:NO];
//            [weakself setHidesBottomBarWhenPushed:YES];
//            [weakself.mapView setRegion:MKCoordinateRegionMakeWithDistance([info placemark].coordinate, 250, 250) animated:YES];
//        }];
//    }
//    return _resultsController;
//}

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableHeaderView.frame), App_Frame_Width, App_Frame_Width-CGRectGetMaxY(self.tableHeaderView.frame))];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (MKPointAnnotation *)annotation
{
    if (!_annotation) {
        _annotation = [[MKPointAnnotation alloc] init];
    }
    return _annotation;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, CGRectGetHeight(self.searchController.searchBar.frame))];
    }
    return _tableHeaderView;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
