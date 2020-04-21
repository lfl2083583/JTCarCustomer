//
//  JTMaintenanceLogViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTMaintenanceLogTableViewCell.h"
#import "JTMaintenanceRemindTableViewCell.h"
#import "JTSmartMaintenanceTableHeadView.h"

#import "JTMaintenanceLogViewController.h"
#import "JTMaintenanceEditViewController.h"
#import "JTMaintenanceCategoryViewController.h"
#import "JTSmartMaintenanceViewController.h"

@interface JTMaintenanceLogViewController () <UITableViewDataSource, JTMaintenanceRemindTableViewCellDelegate>

@property (nonatomic, strong) JTSmartMaintenanceTableHeadView *tableHeadView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, strong) NSDictionary *remindData;

@end

@implementation JTMaintenanceLogViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KMaintenanceLogChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateMyCarListNotification object:nil];
    CCLOG(@"JTMaintenanceLogViewController销毁了");
}

- (instancetype)initWithCarModel:(JTCarModel *)carModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _carModel = carModel;
    }
    return self;
}

- (void)bottomBtnClick:(id)sender {
    [self.navigationController pushViewController:[[JTMaintenanceEditViewController alloc] initWithCarModel:self.carModel] animated:YES];
}

- (void)rightBarButtonItemClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"全部保养记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController pushViewController:[[JTMaintenanceCategoryViewController alloc] initWithMaintenanceLogType:JTMaintenanceLogTypeForAll carModel:weakSelf.carModel] animated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"手动添加的记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController pushViewController:[[JTMaintenanceCategoryViewController alloc] initWithMaintenanceLogType:JTMaintenanceLogTypeForManual carModel:weakSelf.carModel] animated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"溜车系统添加的记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController pushViewController:[[JTMaintenanceCategoryViewController alloc] initWithMaintenanceLogType:JTMaintenanceLogTypeForSystem carModel:weakSelf.carModel] animated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"保养记录";
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-45) rowHeight:100 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self setShowTableRefreshFooter:YES];
    [self setShowTableRefreshHeader:YES];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview registerClass:[JTMaintenanceLogTableViewCell class] forCellReuseIdentifier:maintenanceLogIdentifier];
    [self.tableview registerClass:[JTMaintenanceRemindTableViewCell class] forCellReuseIdentifier:maintenanceRemindIdentifier];
    
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.tipLB];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultCarChanged) name:kUpdateMyCarListNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMaintenanceLog) name:@"KMaintenanceLogChangedNotification" object:nil];
    
    [self getMaintenanceLog];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)getMaintenanceLog {
    //获取保养提醒数据
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Programme/tip") parameters:@{@"car_id" : self.carModel.carID} success:^(id responseObject, ResponseState state) {
        NSDictionary *response = responseObject;
        weakSelf.remindData = (response && [response isKindOfClass:[NSDictionary class]] && response.allKeys.count)?response:nil;
        [weakSelf staticRefreshFirstTableListData];
    } failure:^(NSError *error) {
        [weakSelf staticRefreshFirstTableListData];
    }];
}

- (void)defaultCarChanged {
    if ([JTUserInfo shareUserInfo].myCarList.count) {
        JTCarModel *model = [[JTUserInfo shareUserInfo].myCarList firstObject];
        self.carModel = model;
        [self setupHeadView];
        [self getMaintenanceLog];
    }
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Log/get") parameters:@{@"type" : @(0), @"car_id" : self.carModel.carID, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
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
    if (self.remindData && indexPath.section == 0) {
        JTMaintenanceRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:maintenanceRemindIdentifier];
        cell.remindData = self.remindData;
        cell.delegate = self;
        return cell;
    } else {
        NSDictionary *item = self.remindData?self.dataArray[indexPath.section-1]:self.dataArray[indexPath.section];
        JTMaintenanceLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:maintenanceLogIdentifier];
        cell.item = item;
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count+(self.remindData?1:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.remindData && indexPath.section == 0) {
        __weak typeof(self)weakSelf = self;
        return [tableView fd_heightForCellWithIdentifier:maintenanceRemindIdentifier cacheByIndexPath:indexPath configuration:^(JTMaintenanceRemindTableViewCell *cell) {
            cell.remindData = weakSelf.remindData;
        }];
    } else {
        NSDictionary *item = self.remindData?self.dataArray[indexPath.section-1]:self.dataArray[indexPath.section];
        return [tableView fd_heightForCellWithIdentifier:maintenanceLogIdentifier cacheByIndexPath:indexPath configuration:^(JTMaintenanceLogTableViewCell *cell) {
            cell.item = item;
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && self.remindData) {
        return;
    }
    NSDictionary *maintenanceDatas = self.remindData?self.dataArray[indexPath.section-1]:self.dataArray[indexPath.section];
    [self.navigationController pushViewController:[[JTMaintenanceEditViewController alloc] initWithCarModel:self.carModel maintenanceDatas:maintenanceDatas] animated:YES];
}

#pragma mark JTMaintenanceRemindTableViewCellDelegate
- (void)smartMaintenancePlan {
    [self.navigationController pushViewController:[[JTSmartMaintenanceViewController alloc] initWithCarModel:self.carModel] animated:YES];
}

- (void)setupHeadView {
    [_tableHeadView.carIcon setAvatarByUrlString:[self.carModel.icon avatarHandleWithSquare:100] defaultImage:[UIImage imageNamed:@""]];
    _tableHeadView.nameLB.text = self.carModel.brand;
    _tableHeadView.modelLB.text = [NSString stringWithFormat:@"%@",self.carModel.name];
    [_tableHeadView.nameLB setY:20];
    [_tableHeadView.modelLB setY:CGRectGetMaxY(_tableHeadView.nameLB.frame)];
}

- (JTSmartMaintenanceTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTSmartMaintenanceTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, 90)];
        [self setupHeadView];
    }
    return _tableHeadView;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.frame = CGRectMake(0, APP_Frame_Height-45, App_Frame_Width, 45);
        _bottomBtn.backgroundColor = BlueLeverColor1;
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_bottomBtn setImage:[UIImage imageNamed:@"icon_mantenance_add"] forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"添加保养记录" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"您暂未添加保养记录~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}


@end
