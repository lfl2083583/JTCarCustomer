//
//  JTSmartMaintenanceViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTSmartMaintenanceTableViewCell.h"
#import "JTReserveFlowTableViewCell.h"
#import "JTSmartMaintenanceTableHeadView.h"

#import "JTCarEditViewController.h"
#import "JTMyLoveCarViewController.h"
#import "JTFeeExplainViewController.h"
#import "JTReserveFlowViewController.h"
#import "JTCarManageViewController.h"
#import "JTSmartMaintenanceViewController.h"
#import "JTCarCertificationRewardViewController.h"

@interface JTSmartMaintenanceViewController () <UITableViewDataSource, JTSmartMaintenanceDelegate>

@property (nonatomic, strong) JTSmartMaintenanceTableHeadView *tableHeadView;
@property (nonatomic, strong) JTSmartMaintenanceFootView *footView;

@property (nonatomic, strong) NSMutableArray *seletedArray;
@property (nonatomic, strong) NSMutableDictionary *seletedDict;
@property (nonatomic, assign) CGFloat goodsPriceMin;
@property (nonatomic, assign) CGFloat goodsPriceMax;
@property (nonatomic, assign) CGFloat hoursPriceMin;
@property (nonatomic, assign) CGFloat hoursPriceMax;


@end

@implementation JTSmartMaintenanceViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateMyCarListNotification object:nil];
}

- (instancetype)initWithCarModel:(JTCarModel *)carModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _carModel = carModel;
    }
    return self;
}

- (void)rightBarButtonItemClick:(id)sender {
    [self.navigationController pushViewController:[[JTCarManageViewController alloc] init] animated:YES];
}

- (void)requestSmartMaintenance {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Programme/recommend") parameters:@{@"car_id" : self.carModel.carID, @"mileage" : self.carModel.mileageNum} success:^(id responseObject, ResponseState state) {
        NSArray *maintenances = responseObject[@"list"];
        if (maintenances && [maintenances isKindOfClass:[NSArray class]]) {
            
            for (int i = 0; i < maintenances.count; i++) {
                int num = 0;
                NSDictionary *dictionary = maintenances[i];
                NSArray *serviceArray = [dictionary objectForKey:@"service"];
                for (int j = 0; j < serviceArray.count; j++) {
                    NSDictionary *service = serviceArray[j];
                    CGFloat goodPriceMin = [[service objectForKey:@"goods_price_min"] floatValue];
                    CGFloat goodPriceMax = [[service objectForKey:@"goods_price_max"] floatValue];
                    CGFloat hoursPriceMin = [[service objectForKey:@"hours_price_min"] floatValue];
                    CGFloat hoursPriceMax = [[service objectForKey:@"hours_price_max"] floatValue];
                    
                    weakSelf.goodsPriceMin = weakSelf.goodsPriceMin + goodPriceMin;
                    weakSelf.goodsPriceMax = weakSelf.goodsPriceMax + goodPriceMax;
                    weakSelf.hoursPriceMin = weakSelf.hoursPriceMin + hoursPriceMin;
                    weakSelf.hoursPriceMax = weakSelf.hoursPriceMax + hoursPriceMax;
                    
                    if ([[service objectForKey:@"select"] boolValue] == YES) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                        [weakSelf.seletedArray addObject:indexPath];
                        num++;
                    }
                }
                if (num > 0) {
                    NSString *key = [NSString stringWithFormat:@"section_%d", i];
                    [weakSelf.seletedDict setValue:@(num) forKey:key];
                }
            }
            [weakSelf.dataArray addObjectsFromArray:maintenances];
            weakSelf.footView.estimatedCostLB.text = [NSString stringWithFormat:@"预计总价:￥%.2f-￥%.2f", weakSelf.goodsPriceMin+weakSelf.hoursPriceMin, weakSelf.goodsPriceMax+weakSelf.hoursPriceMax];
            weakSelf.footView.manhourCostLB.text = [NSString stringWithFormat:@"包含工时:￥%.2f-￥%.2f", weakSelf.hoursPriceMin, weakSelf.hoursPriceMax];
            [weakSelf.tableview reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"智能保养方案";
    [self.view addSubview:self.footView];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-100) rowHeight:100 sectionHeaderHeight:36 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTSmartMaintenanceTableViewCell class] forCellReuseIdentifier:smartMaintenanceIdentifier];
    [self.tableview registerClass:[JTReserveFlowTableViewCell class] forCellReuseIdentifier:reserveFlowIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyCarListNotification:) name:kUpdateMyCarListNotification object:nil];
    
    UIViewController *myLoveCarVC;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[JTMyLoveCarViewController class]]) {
            myLoveCarVC = viewController;
        }
    }
    if (!myLoveCarVC) {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理车型" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    }
   
    [self requestSmartMaintenance];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if ([JTUserInfo shareUserInfo].myCarList.count) {
        [self refreshUI];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != self.dataArray.count) {
        NSDictionary *dictionary = self.dataArray[indexPath.section];
        NSArray *serviceList = [dictionary objectForKey:@"service"];
        JTSmartMaintenanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:smartMaintenanceIdentifier];
        cell.maintenance = serviceList[indexPath.row];
        cell.checkBox.image = [self.seletedArray containsObject:indexPath]?[UIImage imageNamed:@"icon_accessory_selected"]:[UIImage imageNamed:@"icon_accessory_pressed"];
        return cell;
    }
    else
    {
        if (indexPath.row == 0) {
            return [self createTableViewCellWithTitle:@"预约流程" tableView:tableView cellForRowAtIndexPath:indexPath];
        }
        else
        {
            return [tableView dequeueReusableCellWithIdentifier:reserveFlowIdentifier];
        }
    }
}

- (UITableViewCell *)createTableViewCellWithTitle:(NSString *)title tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *normalIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
        cell.textLabel.font = Font(16);
        cell.textLabel.textColor = BlackLeverColor6;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *horizonView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, App_Frame_Width, 0.5)];
        horizonView.backgroundColor = BlackLeverColor2;
        [cell.contentView addSubview:horizonView];
    }
    cell.textLabel.text = title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != self.dataArray.count) {
        NSDictionary *dictionary = self.dataArray[section];
        NSArray *serviceList = [dictionary objectForKey:@"service"];
        return serviceList.count;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count?self.dataArray.count+1:self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataArray.count && indexPath.row == 0) {
        return 45;
    }
    else if (indexPath.section == self.dataArray.count && indexPath.row == 1) {
        return 100;
    }
    else
    {
        NSDictionary *dictionary = self.dataArray[indexPath.section];
        NSArray *serviceList = [dictionary objectForKey:@"service"];
        return [tableView fd_heightForCellWithIdentifier:smartMaintenanceIdentifier cacheByIndexPath:indexPath configuration:^(JTSmartMaintenanceTableViewCell *cell) {
            cell.maintenance = serviceList[indexPath.row];
        }];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != self.dataArray.count) {
        JTSmartMaintenanceSectionHeadView *sectionHead = [tableView dequeueReusableHeaderFooterViewWithIdentifier:smartMaintenanceSectionIdentifier];
        if (!sectionHead) {
            sectionHead = [[JTSmartMaintenanceSectionHeadView alloc] initWithReuseIdentifier:smartMaintenanceSectionIdentifier];
        }
        NSDictionary *maintanceDict = self.dataArray[section];
        NSArray *serviceArray = [maintanceDict objectForKey:@"service"];
        NSString *seletedCount = [self.seletedDict objectForKey:[NSString stringWithFormat:@"section_%ld", section]];
        NSInteger num = seletedCount?[seletedCount integerValue]:0;
        sectionHead.titleLB.text = [NSString stringWithFormat:@"%@(%ld/%ld)", [maintanceDict objectForKey:@"name"], num, serviceArray.count];
        return sectionHead;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == self.dataArray.count) {
        [self.navigationController pushViewController:[[JTReserveFlowViewController alloc] init] animated:YES];
    } else {
        NSDictionary *maintanceDict = self.dataArray[indexPath.section];
        NSArray *serviceArray = [maintanceDict objectForKey:@"service"];
        NSDictionary *serviceDict = serviceArray[indexPath.row];
        CGFloat goodPriceMin = [[serviceDict objectForKey:@"goods_price_min"] floatValue];
        CGFloat goodPriceMax = [[serviceDict objectForKey:@"goods_price_max"] floatValue];
        CGFloat hoursPriceMin = [[serviceDict objectForKey:@"hours_price_min"] floatValue];
        CGFloat hoursPriceMax = [[serviceDict objectForKey:@"hours_price_max"] floatValue];
        NSString *key = [NSString stringWithFormat:@"section_%ld", indexPath.section];
        if ([self.seletedArray containsObject:indexPath]) {
            [self.seletedArray removeObject:indexPath];
            self.goodsPriceMin = self.goodsPriceMin - goodPriceMin;
            self.goodsPriceMax = self.goodsPriceMax - goodPriceMax;
            self.hoursPriceMin = self.hoursPriceMin - hoursPriceMin;
            self.hoursPriceMax = self.hoursPriceMax - hoursPriceMax;
            if ([self.seletedDict objectForKey:key]) {
                NSInteger num = [[self.seletedDict objectForKey:key] integerValue];
                num--;
                [self.seletedDict setValue:@(num) forKey:key];
            }
            
        } else {
            [self.seletedArray addObject:indexPath];
            self.goodsPriceMin = self.goodsPriceMin + goodPriceMin;
            self.goodsPriceMax = self.goodsPriceMax + goodPriceMax;
            self.hoursPriceMin = self.hoursPriceMin + hoursPriceMin;
            self.hoursPriceMax = self.hoursPriceMax + hoursPriceMax;
            if ([self.seletedDict objectForKey:key]) {
                NSInteger num = [[self.seletedDict objectForKey:key] integerValue];
                num++;
                [self.seletedDict setValue:@(num) forKey:key];
            } else {
                [self.seletedDict setValue:@(1) forKey:key];
            }
        }
        self.footView.estimatedCostLB.text = [NSString stringWithFormat:@"预计总价:￥%.2f-￥%.2f", self.goodsPriceMin+self.hoursPriceMin, self.goodsPriceMax+self.hoursPriceMax];
        self.footView.manhourCostLB.text = [NSString stringWithFormat:@"包含工时:￥%.2f-￥%.2f", self.hoursPriceMin, self.hoursPriceMax];
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == self.dataArray.count?10:43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.dataArray.count?30:0;
}

#pragma mark JTSmartMaintenanceDelegate
- (void)chooseMaintenanceStore {
    [self.navigationController pushViewController:[[JTCarCertificationRewardViewController alloc] initCarModel:self.carModel] animated:YES];
}

- (void)feeDetailExplain {
    [self.navigationController pushViewController:[[JTFeeExplainViewController alloc] init] animated:YES];
}

- (void)chooseLoveCar {
    [self.navigationController pushViewController:[[JTCarEditViewController alloc] initWithModel:self.carModel] animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.footView.explainBtn setHidden:YES];
    [self.tableview setHeight:APP_Frame_Height-kStatusBarHeight-kTopBarHeight-70];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.footView.explainBtn setHidden:NO];
    [self.tableview setHeight:APP_Frame_Height-kStatusBarHeight-kTopBarHeight-100];
}

#pragma mark NSNotification
- (void)updateMyCarListNotification:(NSNotification *)notification
{
    if ([JTUserInfo shareUserInfo].myCarList.count) {
        JTCarModel *model = [[JTUserInfo shareUserInfo].myCarList firstObject];
        self.carModel = model;
        [self refreshUI];
        [self requestSmartMaintenance];
    }
}

- (void)refreshUI {
    [_tableHeadView.carIcon setAvatarByUrlString:[self.carModel.icon avatarHandleWithSquare:100] defaultImage:[UIImage imageNamed:@""]];
    [_tableHeadView.nameLB setText:self.carModel.brand];
    [_tableHeadView.modelLB setText:self.carModel.name];
    [_tableHeadView.travelLB setText:self.carModel.mileageStr];
    CGSize size = [Utility getTextString:self.carModel.mileageStr textFont:Font(12) frameWidth:App_Frame_Width-100 attributedString:nil];
    [_tableHeadView.rightBtn setFrame:CGRectMake(100+size.width, CGRectGetMinY(_tableHeadView.travelLB.frame), 40, 20)];
}

- (JTSmartMaintenanceTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTSmartMaintenanceTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, 90)];
        [_tableHeadView.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _tableHeadView.delegate = self;
        [_tableHeadView.rightBtn setEnabled:YES];
        [self refreshUI];
    }
    return _tableHeadView;
}

- (JTSmartMaintenanceFootView *)footView {
    if (!_footView) {
        _footView = [[JTSmartMaintenanceFootView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-100, App_Frame_Width, 100)];
        _footView.delegate = self;
    }
    return _footView;
}

- (NSMutableArray *)seletedArray {
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray array];
    }
    return _seletedArray;
}

- (NSMutableDictionary *)seletedDict {
    if (!_seletedDict) {
        _seletedDict = [NSMutableDictionary dictionary];
    }
    return _seletedDict;
}
@end
