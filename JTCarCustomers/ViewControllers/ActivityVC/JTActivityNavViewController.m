//
//  JTActivityMapViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "CLAlertController.h"
#import "JTActivityLoctionView.h"
#import "JTActivityNavViewController.h"

@interface JTActivityNavViewController () <JTActivityLoctionViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) JTActivityLoctionView *loctionView;

@property (nonatomic, copy) NSString *destinationPalce;
@property (nonatomic, assign) MKDirectionsTransportType transportType;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSMutableArray *overLays;

@end


@implementation JTActivityNavViewController

- (instancetype)initWithLocation:(double)latitude longitude:(double)longitude title:(NSString *)title {
    self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
        _destinationPalce = title;
        _transportType = MKDirectionsTransportTypeAutomobile;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查看导航";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_black"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemClick:)];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.loctionView];
    
    self.loctionView.destinationLB.text = [NSString stringWithFormat:@"终点：%@", self.destinationPalce];
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            [[HUDTool shareHUDTool] showHint:@"请在设置-隐私里允许程序使用地理位置服务"];
        } else {
            [self.locationManager startUpdatingLocation];
            [self.mapView addAnnotation:self.annotation];
            [self.annotation setCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
            [self presentCurrentCourse];
            self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.latitude, self.longitude), MKCoordinateSpanMake(.1f, .1f));
        }
    } else {
        [[HUDTool shareHUDTool] showHint:@"请打开地理位置服务"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.locationManager requestAlwaysAuthorization];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.locationManager stopUpdatingLocation];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButtonItemClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentCurrentCourse {
    __weak typeof(self) weakSelf = self;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude
                                                      longitude:self.longitude];
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil) {
             if (placemarks.count > 0) {
                 
                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks lastObject]];
                 MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                 MKMapItem *startMapItem = [MKMapItem mapItemForCurrentLocation];
                 [weakSelf startRoute:startMapItem withMapItem:endMapItem transportType:MKDirectionsTransportTypeAutomobile];
             }
         }
     }];
}

#pragma mark MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.lineWidth = 4.0;
    render.strokeColor = UIColorFromRGB(0x6987F7);
    return render;
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    
//    MKAnnotationView * view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
//    //设置标注的图片
//    view.image = [UIImage imageNamed:@"location_annotation_icon"];
//    //设置拖拽 可以通过点击不放进行拖拽
//    view.draggable = NO;
//    return view;
//}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    __weak typeof(self)weakSelf = self;
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLoction = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLoction completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *address = [placemark addressDictionary];
            weakSelf.loctionView.currentLoctionLB.text = [NSString stringWithFormat:@"%@%@",[address objectForKey:@"SubLocality"],[address objectForKey:@"Thoroughfare"]];
        };
    }];
    CLLocation *loction2 = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    NSArray *route = @[currentLoction, loction2];
    [self centerMapWithRoutes:route];
}

- (void)startRoute:(MKMapItem *)startMapItem withMapItem:(MKMapItem *)endMapItem transportType:(MKDirectionsTransportType)transportType {
    [self.overLays removeAllObjects];
    //创建request对象
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    //给request设置起点和终点
    request.source = startMapItem;
    request.destination = endMapItem;
    request.transportType = transportType;
    //创建MKDirections对象; 发送请求
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    __weak typeof(self) weakself = self;
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //取出整体路线; 取出对应路线的所有steps；添加polyline
            for (MKRoute *route in response.routes) {
                //第一处可以添加几何线
                //steps
                for (MKRouteStep *step in route.steps) {
                    //第二处可以添加几何线到地图视图上
                    [weakself.mapView addOverlay:step.polyline];
                    [weakself.overLays addObject:step.polyline];
                }
            }
        }
    }];
    NSString *origin = [NSString stringWithFormat:@"%f,%f", self.locationManager.location.coordinate.longitude, self.locationManager.location.coordinate.latitude];
    NSString *destination = [NSString stringWithFormat:@"%.6f,%.6f", self.longitude, self.latitude];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:LBS_Key forKey:@"key"];
    [parameters setObject:origin forKey:@"origin"];
    [parameters setObject:destination forKey:@"destination"];
    NSString *requestUrl = self.transportType == MKDirectionsTransportTypeWalking?LBS_WalkApi:LBS_DrivingApi;
    [[HttpRequestTool sharedInstance] postWithURLString:requestUrl parameters:parameters success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        NSArray *paths = responseObject[@"route"][@"paths"];
        if (paths && [paths isKindOfClass:[NSArray class]] && paths.count) {
            NSDictionary *route = [paths firstObject];
            CGFloat distance = [[route objectForKey:@"distance"] floatValue];
            CGFloat duration = [[route objectForKey:@"duration"] floatValue];
            weakself.loctionView.routeLB.text = [NSString stringWithFormat:@"总路程%.fkm    预计%.f分钟",distance/1000.0,duration/60.0];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark JTActivityLoctionViewDelegate
- (void)updateLocationAgain {
    [self.locationManager startUpdatingLocation];
}

- (void)transportationTypeChoosed:(MKDirectionsTransportType)transportType {
    if (self.overLays.count) {
       [self.mapView removeOverlays:self.overLays];
    }
    self.transportType = transportType;
    [self presentCurrentCourse];
}

- (void)startNavDistionation {
    CLAlertController *alertMore = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
    NSArray *appListArr = [self checkHasOwnApp];
    __weak typeof(self) weakself = self;
    
    [alertMore addAction:[CLAlertModel actionWithTitle:@"Apple 地图" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        CLLocationCoordinate2D from = weakself.locationManager.location.coordinate;
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil]];
        currentLocation.name = @"我的位置";
        //终点
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(weakself.latitude, weakself.longitude);
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        toLocation.name = weakself.destinationPalce;
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{
                                  MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                  MKLaunchOptionsMapTypeKey:
                                      [NSNumber numberWithInteger:MKMapTypeStandard],
                                  MKLaunchOptionsShowsTrafficKey:@YES
                                  };
        //打开苹果自身地图应用
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }]];
    if ([appListArr containsObject:@"Google地图"]) {
        [alertMore addAction:[CLAlertModel actionWithTitle:@"Google地图" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit", weakself.locationManager.location.coordinate.latitude, weakself.locationManager.location.coordinate.longitude, weakself.latitude, weakself.longitude];
            NSURL *r = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:r];
        }]];
    }
    if ([appListArr containsObject:@"高德地图"]) {
        [alertMore addAction:[CLAlertModel actionWithTitle:@"高德地图" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0", weakself.locationManager.location.coordinate.latitude, weakself.locationManager.location.coordinate.longitude, @"我的位置", weakself.latitude , weakself.longitude, weakself.destinationPalce] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *r = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:r];
        }]];
    }
    if ([appListArr containsObject:@"腾讯地图"]) {
        [alertMore addAction:[CLAlertModel actionWithTitle:@"腾讯地图" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            NSString *urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1", weakself.locationManager.location.coordinate.latitude, weakself.locationManager.location.coordinate.longitude, weakself.latitude, weakself.longitude];
            NSURL *r = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:r];
            
        }]];
    }
    [alertMore addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
    }]];
    [self presentToViewController:alertMore completion:nil];
}

-(void)centerMapWithRoutes:(NSArray *)routes {
    
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for(int idx = 0; idx < routes.count; idx++)
    {
        CLLocation *currentLocation = [routes objectAtIndex:idx];
        
        if(currentLocation.coordinate.latitude > maxLat) {
            maxLat = currentLocation.coordinate.latitude;
        }
        if(currentLocation.coordinate.latitude < minLat) {
            minLat = currentLocation.coordinate.latitude;
        }
        if(currentLocation.coordinate.longitude > maxLon) {
            maxLon = currentLocation.coordinate.longitude;
        }
        if(currentLocation.coordinate.longitude < minLon) {
            minLon = currentLocation.coordinate.longitude;
        }
    }
    
    region.center.latitude = (maxLat+minLat)/2.0;
    region.center.longitude = (maxLon+minLon)/2.0;
    region.span.latitudeDelta = maxLat-minLat;
    region.span.longitudeDelta = maxLon-minLon;
    [self.mapView setRegion:region animated:YES];
}

- (JTActivityLoctionView *)loctionView {
    if (!_loctionView) {
        _loctionView = [[[NSBundle mainBundle] loadNibNamed:@"JTActivityLoctionView" owner:nil options:nil] firstObject];
        if (App_Frame_Width < 355) {
            [_loctionView setWidth:300];
        }
        _loctionView.center = CGPointMake(App_Frame_Width/2.0, APP_Frame_Height-127);
        _loctionView.delegate = self;
        
        
    }
    return _loctionView;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
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

- (NSMutableArray *)overLays {
    if (!_overLays) {
        _overLays = [NSMutableArray array];
    }
    return _overLays;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSArray *)checkHasOwnApp {
    NSArray *mapSchemeArr = @[@"comgooglemaps://", @"iosamap://navi", @"baidumap://map/", @"qqmap://"];
    
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果原生地图", nil];
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0) {
                [appListArr addObject:@"Google地图"];
            }else if (i == 1){
                [appListArr addObject:@"高德地图"];
            }else if (i == 2){
                [appListArr addObject:@"百度地图"];
            }else if (i == 3){
                [appListArr addObject:@"腾讯地图"];
            }
        }
    }
    return appListArr;
}


@end
