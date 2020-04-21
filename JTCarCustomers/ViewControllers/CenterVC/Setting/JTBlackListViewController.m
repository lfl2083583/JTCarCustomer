//
//  JTBlackListViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTUserTableViewCell.h"
#import "JTUserSimpleTableViewCell.h"
#import "JTBlackListViewController.h"
#import "JTCardViewController.h"

@interface JTBlackListViewController () <UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) NSIndexPath *editingIndexPath;

@end

@implementation JTBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight+CGRectGetHeight(self.headView.frame), App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-CGRectGetHeight(self.headView.frame)) rowHeight:60 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview registerClass:[JTUserSimpleTableViewCell class] forCellReuseIdentifier:userSimpleCellIdentifier];
    [self.tableview setDataSource:self];
    [self setShowTableRefreshHeader:YES];
    [self setShowTableRefreshFooter:YES];
    [self.view addSubview:self.tipLB];
    [self staticRefreshFirstTableListData];
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

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(BlackListApi) parameters:@{@"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    JTUserSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userSimpleCellIdentifier];
    [cell.avatar setAvatarByUrlString:[dictionary[@"avatar"] avatarHandleWithSquare:40] defaultImage:DefaultSmallAvatar];
    cell.nameLB.text = dictionary[@"nick_name"];
    [cell.genderGradeImageView configGenderView:[dictionary[@"gender"] integerValue] grade:[JTUserTableViewCell caculateBirthWithBirthDate:dictionary[@"birth"]]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:[NSString stringWithFormat:@"%@",dictionary[@"uid"]]] animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setEditingIndexPath:indexPath];
    [self.view setNeedsLayout];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];
        [weakself deleteCollection:indexPath];
    }];
    deleteRowAction.backgroundColor = BlackLeverColor1;
    return @[deleteRowAction];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    __weak typeof(self) weakself = self;
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [tableView setEditing:NO animated:YES];
        [weakself deleteCollection:indexPath];
        completionHandler (YES);
    }];
    deleteRowAction.image = [UIImage imageNamed:@"icon_cell_delete"];
    deleteRowAction.backgroundColor = BlackLeverColor1;
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

- (void)deleteCollection:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SetBlackApi) parameters:@{@"fid" : [NSString stringWithFormat:@"%@",dictionary[@"uid"]], @"type" : @(0)} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"删除黑名单成功" yOffset:0];
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        [weakSelf.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}

- (void)configSwipeButtons
{
    if (IOS11)
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableview.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                [subview.subviews[0] setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
                [subview.subviews[0] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in cell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                [subview.subviews[0] setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
                [subview.subviews[0] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
}


- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 40)];
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, App_Frame_Width-15, 40)];
        titleLB.font = Font(24);
        titleLB.text = @"黑名单";
        [_headView addSubview:titleLB];
    }
    return _headView;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"暂时没有黑名单~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
