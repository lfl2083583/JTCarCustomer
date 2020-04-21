//
//  JTMapMarkViewController.m
//  JTSocial
//
//  Created by apple on 2017/7/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTMapMarkViewController.h"
#import <MapKit/MapKit.h>
#import "JTMessageMaker.h"
#import "JTNavigationBar.h"
#import "CLAlertController.h"
#import "NSObject+ZTExtension.h"

@interface JTMapMarkViewController () <JTNavigationBarDelegate>

@property (nonatomic) JTMapMarkType mapMarkType;
@property (strong, nonatomic) NIMMessage *message;
@property (strong, nonatomic) NSString *collectionID;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *locationTitle;
@property (nonatomic, strong) NSString *locationSubTitle;

@property (strong, nonatomic) JTMapMarkNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLB;
@property (nonatomic, strong) MKPointAnnotation *annotation;

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation JTMapMarkViewController

- (instancetype)initWithMessage:(NIMMessage *)message
{
    self = [super initWithNibName:@"JTMapMarkViewController" bundle:nil];
    if (self) {
        self.mapMarkType = JTMapMarkTypeMessage;
        self.message = message;
        NIMLocationObject *object = (NIMLocationObject *)[_message messageObject];
        self.latitude = object.latitude;
        self.longitude = object.longitude;
        NSArray *array = [object.title componentsSeparatedByString:@"&&&&&&"];
        if (array.count >= 2) {
            self.locationTitle = [array objectAtIndex:0];
            self.locationSubTitle = [array objectAtIndex:1];
        }
    }
    return self;
}

- (instancetype _Nullable)initWithCollection:(NSString *)collectionID
                                    latitude:(double)latitude
                                   longitude:(double)longitude
                                       title:(nullable NSString *)title
                                    subTitle:(nullable NSString *)subTitle
{
    self = [super initWithNibName:@"JTMapMarkViewController" bundle:nil];
    if (self) {
        self.mapMarkType = JTMapMarkTypeCollection;
        self.message = [JTMessageMaker messageWithLocation:latitude longitude:longitude title:[NSString stringWithFormat:@"%@&&&&&&%@", title, subTitle]];
        self.collectionID = collectionID;
        self.latitude = latitude;
        self.longitude = longitude;
        self.locationTitle = title;
        self.locationSubTitle = subTitle;
    }
    return self;
}

- (instancetype)initWithLocation:(double)latitude
                       longitude:(double)longitude
                           title:(nullable NSString *)title
                        subTitle:(nullable NSString *)subTitle
{
    self = [super initWithNibName:@"JTMapMarkViewController" bundle:nil];
    if (self) {
        self.mapMarkType = JTMapMarkTypeNone;
        self.message = [JTMessageMaker messageWithLocation:latitude longitude:longitude title:[NSString stringWithFormat:@"%@&&&&&&%@", title, subTitle]];
        self.latitude = latitude;
        self.longitude = longitude;
        self.locationTitle = title;
        self.locationSubTitle = subTitle;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"释放 JTMapMarkViewController");
}

- (void)navigationBarToLeft:(id)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarToRight:(id)navigationBar
{
    CLAlertController *alertMore = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
    __weak typeof(self) weakself = self;
    [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给好友" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=1", kJTCarCustomersScheme, (self.mapMarkType == JTMapMarkTypeMessage)?JTPlatformRepeatNormalMessage:JTPlatformSendNormalMessage, [weakself.message zt_string]];
        [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
    }]];
    [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给群聊" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=2", kJTCarCustomersScheme, (self.mapMarkType == JTMapMarkTypeMessage)?JTPlatformRepeatNormalMessage:JTPlatformSendNormalMessage, [weakself.message zt_string]];
        [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
    }]];
    if (self.mapMarkType == JTMapMarkTypeMessage) {
        [alertMore addAction:[CLAlertModel actionWithTitle:@"收藏" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            NSString *content = [@{@"address": [NSString stringWithFormat:@"%@&&&&&&%@", weakself.locationTitle, weakself.locationSubTitle], @"lat": @(weakself.latitude), @"lng": @(weakself.longitude)} mj_JSONString];
            [parameters setObject:content forKey:@"content"];
            [parameters setObject:@"4" forKey:@"type"];
            NSString *source = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:weakself.message.from]];
            [parameters setObject:source forKey:@"source"];
            if (weakself.message.session.sessionType == NIMSessionTypeP2P) {
                NSString *joinID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:weakself.message.session.sessionId]];
                [parameters setObject:joinID forKey:@"join_id"];
                [parameters setObject:@"1" forKey:@"join_type"];
            }
            else
            {
                [parameters setObject:weakself.message.session.sessionId forKey:@"join_id"];
                [parameters setObject:@"2" forKey:@"join_type"];
            }
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(AddFavoriteApi) parameters:parameters success:^(id responseObject, ResponseState state) {
                
                [[HUDTool shareHUDTool] showHint:@"收藏成功"];
            } failure:^(NSError *error) {
            }];
        }]];
    }
    else if (self.mapMarkType == JTMapMarkTypeCollection) {
        [alertMore addAction:[CLAlertModel actionWithTitle:@"删除" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(delfavoriteApi) parameters:@{@"id": weakself.collectionID} placeholder:@"" success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"删除成功"];
                [[HUDTool shareHUDTool] hideHUD];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteCollectionNotification object:weakself.collectionID];
                [weakself.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
            }];
        }]];
    }
    [alertMore addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
    }]];
    [self presentToViewController:alertMore completion:nil];
}

- (IBAction)moreClick:(id)sender {
    
    CLAlertController *alertMore = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
    NSArray *appListArr = [self checkHasOwnApp];
    __weak typeof(self) weakself = self;
    [alertMore addAction:[CLAlertModel actionWithTitle:@"路线" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:weakself.latitude
                                                          longitude:weakself.longitude];
        [weakself.geocoder reverseGeocodeLocation:location
                                completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error == nil) {
                 if (placemarks.count > 0) {
                     
                     MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks lastObject]];
                     MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                     MKMapItem *startMapItem = [MKMapItem mapItemForCurrentLocation];
                     if (startMapItem && endMapItem) {
                         [weakself startRoute:startMapItem withMapItem:endMapItem];
                     }
                 }
             }
         }];
    }]];
    [alertMore addAction:[CLAlertModel actionWithTitle:@"Apple 地图" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        CLLocationCoordinate2D from = weakself.locationManager.location.coordinate;
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil]];
        currentLocation.name = @"我的位置";
        //终点
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(weakself.latitude, weakself.longitude);
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        toLocation.name = weakself.locationTitle;
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
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0", weakself.locationManager.location.coordinate.latitude, weakself.locationManager.location.coordinate.longitude, @"我的位置", weakself.latitude , weakself.longitude, weakself.locationTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.locationManager requestAlwaysAuthorization];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.mapMarkType == JTMapMarkTypeNone) {
        [self.navigationBar.rightBT setHidden:YES];
    }
    [self.view addSubview:self.navigationBar];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [self.titleLB setText:self.locationTitle];
    [self.subTitleLB setText:self.locationSubTitle];
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            [[HUDTool shareHUDTool] showHint:@"请在设置-隐私里允许程序使用地理位置服务"];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
            [self.mapView addAnnotation:self.annotation];
            [self.annotation setCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.latitude, self.longitude), MKCoordinateSpanMake(.01f, .01f))];
        }
    } else {
        [[HUDTool shareHUDTool] showHint:@"请打开地理位置服务"];
    }
}

//设置线的颜色和粗细
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.lineWidth = 4.0;
    render.strokeColor = UIColorFromRGB(0x9596FC);
    return render;
}

- (void)startRoute:(MKMapItem *)startMapItem withMapItem:(MKMapItem *)endMapItem {
    //创建request对象
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    //给request设置起点和终点
    request.source = startMapItem;
    request.destination = endMapItem;
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
                }
            }
        }
    }];
}

- (JTMapMarkNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[JTMapMarkNavigationBar alloc] init];
        _navigationBar.frame = CGRectMake(0, kStatusBarHeight, App_Frame_Width, kTopBarHeight);
        _navigationBar.delegate = self;
    }
    return _navigationBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)checkHasOwnApp {
    NSArray *mapSchemeArr = @[@"comgooglemaps://", @"iosamap://navi", @"baidumap://map/", @"qqmap://"];
    
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果原生地图", nil];
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0) {
                [appListArr addObject:@"Google地图"];
            } else if (i == 1) {
                [appListArr addObject:@"高德地图"];
            } else if (i == 2) {
                [appListArr addObject:@"百度地图"];
            } else if (i == 3) {
                [appListArr addObject:@"腾讯地图"];
            }
        }
    }
    return appListArr;
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

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

@end
