//
//  JTRescueAddressSearchViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTRescueAddressSearchViewController.h"
#import "ZTTableViewHeaderFooterView.h"
#import "JTStoreModel.h"

@interface JTRescueAddressSearchViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *recommends;

@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation JTRescueAddressSearchViewController

- (instancetype)initWithRescueAddressType:(JTRescueAddressType)rescueAddressType currentPlacemark:(MKPlacemark *)currentPlacemark completedBlock:(void (^)(MKPlacemark *))completedBlock
{
    self = [super init];
    if (self) {
        _rescueAddressType = rescueAddressType;
        _currentPlacemark = currentPlacemark;
        _completedBlock = completedBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WhiteColor];
    NSString *searchPlaceHolder = (self.rescueAddressType == JTRescueAddressTypeLiftElectricity)?@"搜索地址（在哪搭电）":((self.rescueAddressType == JTRescueAddressTypeTrailerStart)?@"搜索地址（在哪拖车）":@"搜索地址（拖到哪去）");
    self.searchBar.placeholder = searchPlaceHolder;
    [self.view addSubview:self.searchBar];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, self.searchBar.bottom, App_Frame_Width, APP_Frame_Height-self.searchBar.bottom) rowHeight:60 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setDataSource:self];
    
    if (self.rescueAddressType == JTRescueAddressTypeTrailerEnd) {
        __weak typeof(self) weakself = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getStoreListApi) parameters:@{@"type": @"3"} success:^(id responseObject, ResponseState state) {
            if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                [weakself.recommends addObjectsFromArray:[JTStoreModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            }
            [weakself.tableview reloadData];
        } failure:^(NSError *error) {
        }];
    }
}

- (void)getListData:(void (^)(void))requestComplete
{
    NSString *location = [NSString stringWithFormat:@"%f,%f", self.currentPlacemark.location.coordinate.latitude, self.currentPlacemark.location.coordinate.longitude];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:LBS_Key forKey:@"key"];
    [parameters setObject:location forKey:@"location"];
    [parameters setObject:self.searchBar.text forKey:@"keywords"];
    [parameters setObject:@"500000" forKey:@"radius"];
    [parameters setObject:@"weight" forKey:@"sortrule"];
    [parameters setObject:@"20" forKey:@"offset"];
    [parameters setObject:@(self.page) forKey:@"page"];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:LBS_SearchApi parameters:parameters success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1)
        {
            [weakself.dataArray removeAllObjects];
        }
        if ([responseObject objectForKey:@"pois"] && [responseObject[@"pois"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:responseObject[@"pois"]];
        }
        [super getListData:requestComplete];
        
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        [self setIsSearch:YES];
        [self staticRefreshFirstTableListData];
        [self setShowTableRefreshFooter:YES];
    }
    else
    {
        [self.dataArray removeAllObjects];
        [self setIsSearch:NO];
        [self setShowTableRefreshFooter:NO];
        [self.tableview reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (!self.isSearch && self.rescueAddressType == JTRescueAddressTypeTrailerEnd && self.recommends.count) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.isSearch ? self.dataArray.count : 1;
    }
    else
    {
        return self.recommends.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 1) ? 30 : 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
        footer.promptLB.text = @"推荐溜车门店";
        return footer;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSearch && indexPath.section == 0) {
        static NSString *cellIdentifier = @"cell_1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(14);
            cell.textLabel.textColor = BlackLeverColor3;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = (self.rescueAddressType == JTRescueAddressTypeLiftElectricity)?@"目前平台仅支持深圳市内进行搭电服务~":@"目前平台仅支持深圳市内进行拖车服务~";
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"cell_2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(18);
            cell.textLabel.textColor = BlackLeverColor6;
            cell.detailTextLabel.font = Font(14);
            cell.detailTextLabel.textColor = BlackLeverColor3;
        }
        if (indexPath.section == 0) {
            NSDictionary *source = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = source[@"name"];
            NSArray *coordinateArray = [source[@"location"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            CLLocationDegrees latitude = [[coordinateArray objectAtIndex:1] doubleValue];
            CLLocationDegrees longitude = [[coordinateArray objectAtIndex:0] doubleValue];
            double distance = [self distanceBetweenOrderBy:self.currentPlacemark.location.coordinate.latitude :latitude :self.currentPlacemark.location.coordinate.longitude :longitude];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fkm %@", distance, [source[@"address"] isKindOfClass:[NSString class]]?source[@"address"]:source[@"adname"]];
        }
        else
        {
            JTStoreModel *model = [self.recommends objectAtIndex:indexPath.row];
            cell.textLabel.text = model.name;
            double distance = [self distanceBetweenOrderBy:self.currentPlacemark.location.coordinate.latitude :model.latitude :self.currentPlacemark.location.coordinate.longitude :model.longitude];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fkm %@", distance, model.address];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch && indexPath.section == 0) {
        NSDictionary *source = [self.dataArray objectAtIndex:indexPath.row];
        NSArray *coordinateArray = [source[@"location"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        CLLocationDegrees latitude = [[coordinateArray objectAtIndex:1] doubleValue];
        CLLocationDegrees longitude = [[coordinateArray objectAtIndex:0] doubleValue];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                          longitude:longitude];
        __weak typeof(self) weakself = self;
        [self.geocoder reverseGeocodeLocation:location
                            completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (placemarks.count > 0) {
                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
                 if (placemark) {
                     weakself.completedBlock(placemark);
                 }
                 [weakself dismissViewControllerAnimated:YES completion:nil];
             }
         }];
    }
    else if (indexPath.section == 1) {
        JTStoreModel *model = [self.recommends objectAtIndex:indexPath.row];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:model.latitude
                                                          longitude:model.longitude];
        __weak typeof(self) weakself = self;
        [self.geocoder reverseGeocodeLocation:location
                            completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (placemarks.count > 0) {
                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
                 if (placemark) {
                     weakself.completedBlock(placemark);
                 }
                 [weakself dismissViewControllerAnimated:YES completion:nil];
             }
         }];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2 {
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    return [curLocation distanceFromLocation:otherLocation]/1000;
}

- (NSMutableArray *)recommends
{
    if (!_recommends) {
        _recommends = [NSMutableArray array];
    }
    return _recommends;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width, IOS11?56:44);
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundImage = [UIImage graphicsImageWithColor:BlackLeverColor1 rect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_searchBar becomeFirstResponder];
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

@end
