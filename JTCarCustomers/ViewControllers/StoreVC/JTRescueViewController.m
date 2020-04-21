//
//  JTRescueViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTRescueViewController.h"
#import <MapKit/MapKit.h>
#import "JTGradientButton.h"
#import "JTRescueAddressSearchViewController.h"
#import "JTRescueInfoViewController.h"

@interface JTRescueViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *startAnnotation;
@property (nonatomic, strong) MKPointAnnotation *endAnnotation;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *promptLB;
@property (weak, nonatomic) IBOutlet JTGradientButton *confirmBT;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftBT;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightBT;
@property (weak, nonatomic) IBOutlet UIImageView *startPoint;
@property (weak, nonatomic) IBOutlet UILabel *startPromptLB;
@property (weak, nonatomic) IBOutlet UITextField *startAddressTF;
@property (weak, nonatomic) IBOutlet UIImageView *endPoint;
@property (weak, nonatomic) IBOutlet UILabel *endPromptLB;
@property (weak, nonatomic) IBOutlet UITextField *endAddressTF;

@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) NSMutableDictionary *priceDic;
@property (assign, nonatomic) JTRescueType rescueType;
@property (strong, nonatomic) MKPlacemark *currentPlacemark;
@property (strong, nonatomic) MKPlacemark *startPlacemark;
@property (strong, nonatomic) MKPlacemark *endPlacemark;

@end

@implementation JTRescueViewController

- (void)leftClick:(id)sender
{
    if (self.rescueType == JTRescueTypeTrailer && self.endPlacemark && self.endAddressTF.text.length > 0) {
        [self setEndPlacemark:nil];
        [self.endAddressTF setText:@""];
        [self reloadUI];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightClick:(id)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"道路救援"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_black"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_help"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)]];
    
    [self.view setBackgroundColor:WhiteColor];
    [self.view insertSubview:self.mapView atIndex:0];
    [self.mapView addAnnotation:self.startAnnotation];
    
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
    
    self.callView.top = self.mapView.top + 20;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.callView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                                         cornerRadii:CGSizeMake(17.5f, 17.5f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.callView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.callView.layer.mask = maskLayer;
    
    self.bottomView.layer.shadowColor = UIColorFromRGBoraAlpha(0x000000, .4).CGColor;
    self.bottomRightBT.layer.borderColor = BlackLeverColor2.CGColor;
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(RescueOutlayApi) parameters:nil success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [weakself.dataDic addEntriesFromDictionary:responseObject];
            [weakself.promptLB setText:responseObject[@"electricity"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)menuClick:(UIButton *)sender {
    [self setRescueType:sender.tag];
    [self reloadUI];
}

- (IBAction)confirmClick:(id)sender {
    if (self.rescueType == JTRescueTypeLiftElectricity && (!self.startPlacemark || self.dataDic)) {
        if (self.startPlacemark && self.dataDic) {
            [self.navigationController pushViewController:[[JTRescueInfoViewController alloc] initWithRescueType:self.rescueType startPlacemark:self.startPlacemark dataDic:self.dataDic] animated:YES];
        }
    }
    else if (self.rescueType == JTRescueTypeTrailer)
    {
        if (self.startPlacemark && self.endPlacemark && self.priceDic) {
            [self.navigationController pushViewController:[[JTRescueInfoViewController alloc] initWithRescueType:self.rescueType startPlacemark:self.startPlacemark endPlacemark:self.endPlacemark dataDic:self.priceDic] animated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.callView.frame, [[touches anyObject] locationInView:self.view])) {
        
    }
    else
    {
        // 拖车状态，有起点，终点，价格数据，不能再继续操作
        if (self.rescueType == JTRescueTypeTrailer && self.endPlacemark && self.endAddressTF.text.length > 0 && self.priceDic.count > 0) {
            return;
        }
        CGPoint touchPoint = [[touches anyObject] locationInView:self.bottomView];
        __weak typeof(self) weakself = self;
        if (CGRectContainsPoint(self.startAddressTF.frame, touchPoint)) {
            [self presentViewController:[[JTRescueAddressSearchViewController alloc] initWithRescueAddressType:(self.rescueType == JTRescueTypeLiftElectricity)?JTRescueAddressTypeLiftElectricity:JTRescueAddressTypeTrailerStart currentPlacemark:self.currentPlacemark completedBlock:^(MKPlacemark *placemark) {
                [weakself setStartPlacemark:[placemark copy]];
                [weakself.startAddressTF setText:placemark.name];
                [weakself.startAnnotation setCoordinate:placemark.coordinate];
                [weakself reloadUI];
            }] animated:YES completion:nil];
        }
        else if (CGRectContainsPoint(self.endAddressTF.frame, touchPoint)) {
            [self presentViewController:[[JTRescueAddressSearchViewController alloc] initWithRescueAddressType:JTRescueAddressTypeTrailerEnd currentPlacemark:self.currentPlacemark completedBlock:^(MKPlacemark *placemark) {
                NSString *startPoint = [NSString stringWithFormat:@"%.6f,%.6f", weakself.startPlacemark.location.coordinate.longitude, weakself.startPlacemark.location.coordinate.latitude];
                NSString *endPoint = [NSString stringWithFormat:@"%.6f,%.6f", placemark.location.coordinate.longitude, placemark.location.coordinate.latitude];
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(TrailerPriceApi) parameters:@{@"origin": startPoint, @"destination": endPoint} success:^(id responseObject, ResponseState state) {
                    
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                        [weakself.priceDic addEntriesFromDictionary:responseObject];
                        [weakself setEndPlacemark:[placemark copy]];
                        [weakself.endAddressTF setText:placemark.name];
                        [weakself.endAnnotation setCoordinate:placemark.coordinate];
                        [weakself.mapView addAnnotation:weakself.endAnnotation];
                        [weakself reloadUI];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }] animated:YES completion:nil];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    __weak typeof(self) weakself = self;
    [self.geocoder reverseGeocodeLocation:userLocation.location
                        completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (placemarks.count > 0) {
             MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
             if (placemark) {
                 if (!weakself.startPlacemark || weakself.startAddressTF.text.length == 0) {
                     weakself.startPlacemark = [placemark copy];
                     weakself.startAddressTF.text = placemark.name;
                     weakself.startAnnotation.coordinate = userLocation.coordinate;
                 }
                 weakself.currentPlacemark = [placemark copy];
             }
         }
     }];
}

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight)];
        _mapView.delegate = self;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    return _mapView;
}

- (MKPointAnnotation *)startAnnotation
{
    if (!_startAnnotation) {
        _startAnnotation = [[MKPointAnnotation alloc] init];
    }
    return _startAnnotation;
}

- (MKPointAnnotation *)endAnnotation
{
    if (!_endAnnotation) {
        _endAnnotation = [[MKPointAnnotation alloc] init];
    }
    return _endAnnotation;
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

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (NSMutableDictionary *)priceDic
{
    if (!_priceDic) {
        _priceDic = [NSMutableDictionary dictionary];
    }
    return _priceDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadUI
{
    if (self.rescueType == JTRescueTypeLiftElectricity) {
        
        [self.confirmBT setHidden:NO];
        [self.mapView removeAnnotation:self.endAnnotation];
        [self.startPoint setHidden:NO];
        [self.startPromptLB setHidden:NO];
        [self.startAddressTF setHidden:NO];
        self.endPoint.top = self.endPromptLB.top = self.endAddressTF.top = self.startPoint.bottom;
        if (self.dataDic.count > 0) {
            [self.promptLB setText:self.dataDic[@"electricity"]];
        }
        [self.mapView removeOverlays:self.mapView.overlays];
        
        [self.bottomLeftBT setBackgroundColor:BlueLeverColor1];
        [self.bottomLeftBT.layer setBorderWidth:0];
        [self.bottomLeftBT.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.bottomLeftBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.bottomRightBT setBackgroundColor:[UIColor clearColor]];
        [self.bottomRightBT.layer setBorderWidth:.5];
        [self.bottomRightBT.layer setBorderColor:BlackLeverColor2.CGColor];
        [self.bottomRightBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
    }
    else
    {
        if (self.endPlacemark && self.endAddressTF.text.length > 0 && self.priceDic.count > 0) {
            [self.confirmBT setHidden:NO];
            [self.mapView addAnnotation:self.endAnnotation];
            [self.endAnnotation setCoordinate:self.endPlacemark.coordinate];
            [self.startPoint setHidden:YES];
            [self.startPromptLB setHidden:YES];
            [self.startAddressTF setHidden:YES];
            self.endPoint.top = self.endPromptLB.top = self.endAddressTF.top = self.startPoint.top;
            NSString *string = [NSString stringWithFormat:@"￥%@ 约%@km", self.priceDic[@"price"], self.priceDic[@"distance"]];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString addAttribute:NSFontAttributeName value:Font(20) range:[string rangeOfString:[self.priceDic[@"price"] stringValue]]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3 range:NSMakeRange(0, string.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RedLeverColor1 range:[string rangeOfString:@"￥"]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RedLeverColor1 range:[string rangeOfString:[self.priceDic[@"price"] stringValue]]];
            self.promptLB.attributedText = attributedString;
            [self startRoute:[[MKMapItem alloc] initWithPlacemark:self.startPlacemark] withMapItem:[[MKMapItem alloc] initWithPlacemark:self.endPlacemark]];
        }
        else
        {
            [self.confirmBT setHidden:YES];
            [self.mapView removeAnnotation:self.endAnnotation];
            [self.startPoint setHidden:NO];
            [self.startPromptLB setHidden:NO];
            [self.startAddressTF setHidden:NO];
            self.endPoint.top = self.endPromptLB.top = self.endAddressTF.top = self.startPoint.bottom;
            if (self.dataDic.count > 0) {
                [self.promptLB setText:self.dataDic[@"trailer"]];
            }
            [self.mapView removeOverlays:self.mapView.overlays];
        }
        
        [self.bottomLeftBT setBackgroundColor:[UIColor clearColor]];
        [self.bottomLeftBT.layer setBorderWidth:.5];
        [self.bottomLeftBT.layer setBorderColor:BlackLeverColor2.CGColor];
        [self.bottomLeftBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [self.bottomRightBT setBackgroundColor:BlueLeverColor1];
        [self.bottomRightBT.layer setBorderWidth:0];
        [self.bottomRightBT.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.bottomRightBT setTitleColor:WhiteColor forState:UIControlStateNormal];
    }
    [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
}

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapView.annotations count];
    if ( count == 0 ) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for(int i = 0; i < count; i ++) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ) { region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
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

@end
