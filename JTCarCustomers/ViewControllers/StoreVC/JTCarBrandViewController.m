//
//  JTCarBrandViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarBrandViewController.h"
#import "ZTTableViewHeaderFooterView.h"
#import "JTImageTableViewCell.h"
#import "JTHotCarBrandView.h"
#import "JTGroupTool.h"
#import "JTCarLineView.h"

@interface JTCarBrandViewController () <UITableViewDataSource, JTHotCarBrandViewDelegate, JTCarLineViewDelegate>

@property (strong, nonatomic) JTHotCarBrandView *hotCarBrandView;
@property (strong, nonatomic) JTCarLineView *carLineView;
@property (strong, nonatomic) NSMutableArray *hotCarBrandArray;
@property (copy, nonatomic) NSMutableArray *titleArray;
@property (copy, nonatomic) NSMutableArray *memberArray;

@end

@implementation JTCarBrandViewController

- (instancetype)initWithDelegate:(id<JTCarModelViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"自主选择车型"];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:25 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
    [self.tableview registerClass:[JTImageTableViewCell class] forCellReuseIdentifier:imageTableIndentifier];
    [self.tableview setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableview setSectionIndexColor:BlackLeverColor3];
    [self.tableview setTableHeaderView:self.hotCarBrandView];
    [self.view addSubview:self.carLineView];
    
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarBrandApi) parameters:nil cacheEnabled:YES success:^(id responseObject, ResponseState state) {
        [weakself.dataArray removeAllObjects];
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:responseObject[@"list"]];
            JTGroupTool *tool = [[JTGroupTool alloc] initWithGroupKey:@"bfirstletter" originalArray:weakself.dataArray];
            weakself.titleArray = tool.titleArray;
            weakself.memberArray = tool.memberArray;
        }
        if ([responseObject objectForKey:@"recommend"] && [responseObject[@"recommend"] isKindOfClass:[NSArray class]]) {
            [weakself.hotCarBrandArray addObjectsFromArray:responseObject[@"recommend"]];
            [weakself.hotCarBrandView setDataArray:weakself.hotCarBrandArray];
        }
        [weakself.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.titleArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.memberArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.memberArray[section] count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
    footer.promptLB.text = self.titleArray[section];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageTableIndentifier];
    NSDictionary *source = [[self.memberArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:[source[@"img"] avatarHandleWithSquare:60]]];
    [cell.titleLB setText:source[@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    NSDictionary *source = [[self.memberArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarLineApi) parameters:@{@"brand_id": source[@"id"]} cacheEnabled:YES placeholder:@"" success:^(id responseObject, ResponseState state) {
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.carLineView showDataArray:responseObject[@"list"]];
        }
    } failure:^(NSError *error) {
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)hotCarBrandView:(JTHotCarBrandView *)hotCarBrandView didSelectAtSoucre:(NSDictionary *)source
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarLineApi) parameters:@{@"brand_id": source[@"id"]} cacheEnabled:YES placeholder:@"" success:^(id responseObject, ResponseState state) {
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.carLineView showDataArray:responseObject[@"list"]];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)carLineView:(JTCarLineView *)carLineView didSelectAtSoucre:(NSDictionary *)source
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarModelApi) parameters:@{@"series_id": source[@"series_id"]} cacheEnabled:YES placeholder:@"" success:^(id responseObject, ResponseState state) {
        if (state == ResponseStateNormal) {
            if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                JTCarModelViewController *carModelVC = [[JTCarModelViewController alloc] initWithDelegate:weakself.delegate];
                [carModelVC.dataArray addObjectsFromArray:responseObject[@"list"]];
                [weakself.navigationController pushViewController:carModelVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (JTHotCarBrandView *)hotCarBrandView
{
    if (!_hotCarBrandView) {
        _hotCarBrandView = [[JTHotCarBrandView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, 165) delegate:self];
        _hotCarBrandView.backgroundColor = WhiteColor;
    }
    return _hotCarBrandView;
}

- (JTCarLineView *)carLineView
{
    if (!_carLineView) {
        _carLineView = [[JTCarLineView alloc] initWithFrame:self.tableview.frame delegate:self];
    }
    return _carLineView;
}

- (NSMutableArray *)hotCarBrandArray
{
    if (!_hotCarBrandArray) {
        _hotCarBrandArray = [NSMutableArray array];
    }
    return _hotCarBrandArray;
}
@end
