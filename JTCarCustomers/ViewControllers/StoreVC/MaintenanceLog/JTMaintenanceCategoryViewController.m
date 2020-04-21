//
//  JTMaintenanceCategoryViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMaintenanceLogTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTMaintenanceCategoryViewController.h"
#import "JTMaintenanceEditViewController.h"

@interface JTMaintenanceCategoryViewController () <UITableViewDataSource>

@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, copy) NSString *categoryName;

@end

@implementation JTMaintenanceCategoryViewController

- (instancetype)initWithMaintenanceLogType:(JTMaintenanceLogType)logType carModel:(JTCarModel *)carModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _logType = logType;
        _carModel = carModel;
        switch (logType) {
            case JTMaintenanceLogTypeForAll:
                _categoryName = @"全部保养记录";
                break;
            case JTMaintenanceLogTypeForManual:
                _categoryName = @"手动添加保养的记录";
                break;
            case JTMaintenanceLogTypeForSystem:
                _categoryName = @"溜车系统添加的保养记录";
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.categoryName;
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTMaintenanceLogTableViewCell class] forCellReuseIdentifier:maintenanceLogIdentifier];
    [self setShowTableRefreshFooter:YES];
    [self setShowTableRefreshHeader:YES];
    [self.tableview.mj_header beginRefreshing];
    [self.view addSubview:self.tipLB];
}

- (void)getListData:(void (^)(void))requestComplete {
    JTCarModel *model = [[JTUserInfo shareUserInfo].myCarList objectAtIndex:0];
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Log/get") parameters:@{@"type" : @(self.logType), @"car_id" : model.carID, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTMaintenanceLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:maintenanceLogIdentifier];
    cell.item = self.dataArray[indexPath.section];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:maintenanceLogIdentifier cacheByIndexPath:indexPath configuration:^(JTMaintenanceLogTableViewCell *cell) {
        cell.item = weakSelf.dataArray[indexPath.section];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[JTMaintenanceEditViewController alloc] initWithCarModel:self.carModel maintenanceDatas:self.dataArray[indexPath.row]] animated:YES];
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"暂时相关保养记录~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

@end
