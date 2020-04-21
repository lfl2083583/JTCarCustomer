//
//  JTAddCarViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTAddCarViewController.h"
#import "ZTTableViewHeaderFooterView.h"
#import "JTCarNumberTableViewCell.h"
#import "TFTitleTableViewCell.h"
#import "JTGradientButton.h"
#import "JTCarBrandViewController.h"
#import "JTAliasKeyboard.h"
#import "JTCarNumberKeyboard.h"
#import "ITDatePicker.h"
#import "ITContainerController.h"
#import "JTSmartMaintenanceViewController.h"
#import "JTParkingLotViewController.h"

@interface JTAddCarViewController () <UITableViewDataSource, TextViewDelegate, JTCarNumberTableViewCellDelegate, JTCarNumberKeyboardDelegate, JTCarModelViewControllerDelegate, ITAlertBoxDelegate>

@property (strong, nonatomic) JTCarNumberKeyboard *carNumberKeyboard;
@property (strong, nonatomic) JTGradientButton *saveBT;

@property (strong, nonatomic) NSString *carName;
@property (strong, nonatomic) NSString *carID;
@property (strong, nonatomic) NSString *carAlias;
@property (strong, nonatomic) NSString *carNumber;
@property (strong, nonatomic) NSString *carBuyTime;
@property (strong, nonatomic) NSString *carMileage;

@end

@implementation JTAddCarViewController

- (instancetype)initWithAddCarType:(JTAddCarType)addCarType
{
    self = [super init];
    if (self) {
        _addCarType = addCarType;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCarAlias:@"粤"];
    [self.navigationItem setTitle:@"添加爱车信息"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:40 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
    [self.tableview registerClass:[JTCarNumberTableViewCell class] forCellReuseIdentifier:carNumberIndentifier];
    [self.tableview registerClass:[TFTitleTableViewCell class] forCellReuseIdentifier:tfTitleIdentifier];
    [self.view addSubview:self.saveBT];
}

- (void)saveClick:(id)sender
{
    __weak typeof(self) weakself = self;
    if (!self.carID || [self.carID isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请选择车型"];
        return;
    }
    if (!self.carNumber || [self.carNumber isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入车牌号"];
        return;
    }
    NSString *plateNumber = [NSString stringWithFormat:@"%@%@", self.carAlias, self.carNumber];
    if (![plateNumber isCarNumber]) {
        [[HUDTool shareHUDTool] showHint:@"请输入正确车牌号"];
        return;
    }
    if (!self.carBuyTime || [self.carBuyTime isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请选择购车时间"];
        return;
    }
    if (!self.carMileage || [self.carMileage isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入行驶里程"];
        return;
    }
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(addCarApi) parameters:@{@"spec_id": self.carID, @"car_cards": plateNumber, @"buy_car_time": self.carBuyTime, @"car_mileage": self.carMileage} success:^(id responseObject, ResponseState state) {
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarApi) parameters:nil success:^(id responseObject, ResponseState state) {
            if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                [[JTUserInfo shareUserInfo] addCarModels:[JTCarModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            }
            [[JTUserInfo shareUserInfo] save];
            [[HUDTool shareHUDTool] showHint:@"添加成功" yOffset:0];
            if (weakself.addCarType == JTAddCarTypeNormal) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            else if (weakself.addCarType == JTAddCarTypeMaintain) {
                JTSmartMaintenanceViewController *smartMaintenanceVC = [[JTSmartMaintenanceViewController alloc] initWithCarModel:[[JTUserInfo shareUserInfo].myCarList objectAtIndex:0]];
                UIViewController *root = weakself.navigationController.viewControllers[0];
                [weakself.navigationController pushViewController:smartMaintenanceVC animated:YES];
                weakself.navigationController.viewControllers = @[root, smartMaintenanceVC];
            }
            else if (weakself.addCarType == JTAddCarTypeParkingLot) {
                JTParkingLotViewController *parkingLotVC = [[JTParkingLotViewController alloc] init];
                UIViewController *root = weakself.navigationController.viewControllers[0];
                [weakself.navigationController pushViewController:parkingLotVC animated:YES];
                weakself.navigationController.viewControllers = @[root, parkingLotVC];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMyCarListNotification object:nil];
        } failure:^(NSError *error) {
        }];
    } failure:^(NSError *error) {
    }];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
    footer.promptLB.text = @"请完善以下信息便于更精确的为您推荐套餐";
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        JTCarNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carNumberIndentifier];
        cell.delegate = nil;
        cell.carNumberTableViewCellDelegate = self;
        cell.titleLB.text = self.carAlias;
        cell.contentTF.font = Font(16);
        cell.contentTF.textColor = BlackLeverColor6;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentTF.placeholder = @"车牌号";
        cell.contentTF.text = self.carNumber;
        cell.contentTF.inputView = self.carNumberKeyboard;
        return cell;
    }
    else
    {
        TFTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfTitleIdentifier];
        cell.titleLB.font = Font(14);
        cell.titleLB.textColor = BlackLeverColor6;
        cell.contentTF.font = Font(16);
        cell.contentTF.textColor = BlackLeverColor6;
        cell.delegate = self;
        cell.indexPath = indexPath;
        if (indexPath.row == 0) {
            cell.titleLB.text = @"车型";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTF.userInteractionEnabled = NO;
            cell.contentTF.placeholder = @"必填";
            cell.contentTF.text = self.carName;
        }
        else if (indexPath.row == 2) {
            cell.titleLB.text = @"购车时间";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTF.userInteractionEnabled = NO;
            cell.contentTF.placeholder = @"必填";
            cell.contentTF.text = self.carBuyTime;
        }
        else if (indexPath.row == 3) {
            cell.titleLB.text = @"行驶里程(公里数KM)";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.contentTF.userInteractionEnabled = YES;
            cell.contentTF.placeholder = @"必填";
            cell.contentTF.text = self.carMileage;
            cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endEditing];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[[JTCarBrandViewController alloc] initWithDelegate:self] animated:YES];
    }
    else if (indexPath.row == 2) {
        ITDatePicker *datePicker = [[ITDatePicker alloc] init];
        datePicker.delegate = self;
        datePicker.showToday = NO;
        datePicker.showOutsideDate = YES;
        [self presentViewController:[[ITContainerController alloc] initWithContentView:datePicker animationType:ITAnimationTypeBottom] animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)text:(id)text changeEditingAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        self.carMileage = text;
    }
}

- (void)carNumberTableViewCellAtChoiceAlias:(JTCarNumberTableViewCell *)carNumberTableViewCell
{
    [self endEditing];
    __weak typeof(self) weakself = self;
    [[[JTAliasKeyboard alloc] init] showInView:self.view choiceBlock:^(NSString *alias) {
        [weakself setCarAlias:alias];
        [weakself.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)carNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard didChangeText:(NSString *)text
{
    JTCarNumberTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.contentTF.text = text;
    self.carNumber = text;
}

- (void)cancelInCarNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard
{
    [self.view endEditing:YES];
}

- (void)carModelViewController:(JTCarModelViewController *)carModelViewController didSelectAtSource:(NSDictionary *)source
{
    [self setCarName:[source objectForKey:@"series_name"]];
    [self setCarID:[NSString stringWithFormat:@"%@", [source objectForKey:@"spec_id"]]];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)alertBox:(ITAlertBox *)alertBox didSelectedResult:(NSString *)dateString
{
    NSArray *array = [dateString componentsSeparatedByString:@"."];
    [self setCarBuyTime:[NSString stringWithFormat:@"%@-%@", array[0], array[1]]];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (JTCarNumberKeyboard *)carNumberKeyboard
{
    if (!_carNumberKeyboard) {
        _carNumberKeyboard = [[JTCarNumberKeyboard alloc] init];
        _carNumberKeyboard.delegate = self;
    }
    return _carNumberKeyboard;
}

- (JTGradientButton *)saveBT
{
    if (!_saveBT) {
        _saveBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        _saveBT.cornerRadius = .0f;
        [_saveBT setTitle:@"提交" forState:UIControlStateNormal];
        [_saveBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_saveBT.titleLabel setFont:Font(18)];
        [_saveBT setFrame:CGRectMake(0, APP_Frame_Height-44, App_Frame_Width, 44)];
        [_saveBT addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBT;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing];
}

- (void)endEditing
{
    [self.view endEditing:YES];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[JTAliasKeyboard class]]) {
            [(JTAliasKeyboard *)view hide];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
