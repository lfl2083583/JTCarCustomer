//
//  JTAddFriendsViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTScanQRViewController.h"
#import "JTAddFriendsViewController.h"
#import "JTLocalContactsViewController.h"
#import "JTContractSearchResultViewController.h"

@interface JTAddFriendsViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation JTAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kTopBarHeight, App_Frame_Width, APP_Frame_Height - kTopBarHeight) rowHeight:60 sectionHeaderHeight:0 sectionFooterHeight:0];
    self.tableview.tableHeaderView = self.searchBar;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self setupComponent];
}

- (void)setupComponent {
    JTWordItem *item1 = [self createItemIcon:@"add_address_icon" title:@"添加手机联系人" className:@"JTLocalContactsViewController"];
    JTWordItem *item2 = [self createItemIcon:@"add_sweep_icon" title:@"扫一扫添加好友" className:@"JTScanQRViewController"];
    JTWordItem *item3 = [self createItemIcon:@"add_search_icon" title:@"按条件查找陌生人" className:@"JTSearchStrangerViewController"];
    JTWordItem *item4 = [self createItemIcon:@"add_nearby_icon" title:@"附近的人" className:@"JTNearbyContactsViewController"];
    self.dataArray = [NSMutableArray arrayWithArray:@[item1, item2, item3, item4]];
}

- (JTWordItem *)createItemIcon:(NSString *)icon title:(NSString *)title className:(NSString *)className {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.className = className;
    item.image = [UIImage imageNamed:icon];
    item.title = title;
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    JTWordItem *item = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(15);
        cell.textLabel.textColor = BlackLeverColor5;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.imageView.image = item.image;
    cell.textLabel.text = item.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.row];
    Class aVCClass = NSClassFromString(item.className);
    //创建vc对象
    UIViewController *vc = [[aVCClass alloc] init];
    [self.parentController.navigationController pushViewController:vc animated:YES];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.parentController.navigationController pushViewController:[[JTContractSearchResultViewController alloc] initWithSearchType:JTContractSearchTypeUser keywords:searchBar.text] animated:YES];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IOS11?56:44);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"手机号码/爱车号";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundImage = [UIImage graphicsImageWithColor:BlackLeverColor1 rect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IOS11?56:44)];
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}
@end
