//
//  JTCarEditViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarEditViewController.h"
#import "JTCarEditHeaderView.h"
#import "TFTitleTableViewCell.h"
#import "ITDatePicker.h"
#import "ITContainerController.h"
#import "JTGradientButton.h"

@interface JTCarEditViewController () <UITableViewDataSource, TextViewDelegate, ITAlertBoxDelegate>

@property (strong, nonatomic) JTCarEditHeaderView *headerView;
@property (strong, nonatomic) JTGradientButton *saveBT;
@property (strong, nonatomic) NSString *carBuyTime;
@property (strong, nonatomic) NSString *carMileage;

@end

@implementation JTCarEditViewController

- (instancetype)initWithModel:(JTCarModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
        self.carBuyTime = model.buyTime;
        self.carMileage = model.mileageNum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"编辑爱车信息"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setTableHeaderView:self.headerView];
    [self.tableview registerClass:[TFTitleTableViewCell class] forCellReuseIdentifier:tfTitleIdentifier];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.view addSubview:self.saveBT];
}

- (void)saveClick:(id)sender
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(editCarApi) parameters:@{@"car_id": self.model.carID, @"buy_car_time": self.carBuyTime, @"car_mileage": self.carMileage} success:^(id responseObject, ResponseState state) {
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarApi) parameters:nil success:^(id responseObject, ResponseState state) {
            if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                [[JTUserInfo shareUserInfo] addCarModels:[JTCarModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            }
            [[JTUserInfo shareUserInfo] save];
            for (JTCarModel *model in [JTUserInfo shareUserInfo].myCarList) {
                if ([model.carID isEqualToString:weakself.model.carID]) {
                    [weakself.model setBuyTime:model.buyTime];
                    [weakself.model setMileageStr:model.mileageStr];
                    [weakself.model setMileageNum:model.mileageNum];
                }
            }
            [[HUDTool shareHUDTool] showHint:@"编辑成功" yOffset:0];
            [weakself.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMyCarListNotification object:nil];
        } failure:^(NSError *error) {
        }];
    } failure:^(NSError *error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfTitleIdentifier];
    cell.titleLB.font = Font(16);
    cell.titleLB.textColor = BlackLeverColor6;
    cell.contentTF.font = Font(14);
    cell.contentTF.textColor = BlackLeverColor3;
    cell.contentTF.textAlignment = NSTextAlignmentRight;
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row == 0) {
        cell.titleLB.text = @"购车时间";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentTF.userInteractionEnabled = NO;
        cell.contentTF.placeholder = @"必填";
        cell.contentTF.text = self.carBuyTime;
    }
    else if (indexPath.row == 1) {
        cell.titleLB.text = @"行驶里程(公里数KM)";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentTF.userInteractionEnabled = YES;
        cell.contentTF.placeholder = @"必填";
        cell.contentTF.text = self.carMileage;
        cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return cell;
}

- (void)text:(id)text changeEditingAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        self.carMileage = text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ITDatePicker *datePicker = [[ITDatePicker alloc] init];
        datePicker.delegate = self;
        datePicker.showToday = NO;
        datePicker.showOutsideDate = YES;
        [self presentViewController:[[ITContainerController alloc] initWithContentView:datePicker animationType:ITAnimationTypeBottom] animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertBox:(ITAlertBox *)alertBox didSelectedResult:(NSString *)dateString
{
    NSArray *array = [dateString componentsSeparatedByString:@"."];
    [self setCarBuyTime:[NSString stringWithFormat:@"%@-%@", array[0], array[1]]];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (JTGradientButton *)saveBT
{
    if (!_saveBT) {
        _saveBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        _saveBT.cornerRadius = .0f;
        [_saveBT setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_saveBT.titleLabel setFont:Font(18)];
        [_saveBT setFrame:CGRectMake(0, APP_Frame_Height-44, App_Frame_Width, 44)];
        [_saveBT addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBT;
}

- (JTCarEditHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTCarEditHeaderView alloc] initWithModel:self.model];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
