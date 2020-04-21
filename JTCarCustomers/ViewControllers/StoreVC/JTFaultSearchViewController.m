//
//  JTFaultSearchViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTFaultSearchViewController.h"
#import "ZTTableViewHeaderFooterView.h"
#import "UIImage+Extension.h"
#import "NormalWebViewController.h"

@interface JTFaultSearchViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation JTFaultSearchViewController


- (void)viewDidLoad {
    [self.view addSubview:self.searchBar];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, self.searchBar.bottom, App_Frame_Width, APP_Frame_Height-self.searchBar.bottom) rowHeight:44 sectionHeaderHeight:30 sectionFooterHeight:0];
    [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setDataSource:self];
    [super viewDidLoad];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(searchFaultApi) parameters:@{@"keyword": self.searchBar.text} success:^(id responseObject, ResponseState state) {
        [weakself.dataArray removeLastObject];
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        [weakself.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
    footer.promptLB.text = @"常见故障";
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(16);
        cell.textLabel.textColor = BlackLeverColor6;
    }
    NSString *title = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = [title rangeOfString:self.searchBar.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
    cell.textLabel.attributedText = attributedString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *navTitle = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];;
    NSString *urlString = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"h5_url"];
    [self.navigationController pushViewController:[[NormalWebViewController alloc] initWithNavTitle:navTitle urlString:urlString] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width, IOS11?56:44);
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundImage = [UIImage graphicsImageWithColor:BlackLeverColor1 rect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        [_searchBar becomeFirstResponder];
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
