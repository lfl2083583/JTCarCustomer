//
//  JTRescueInfoViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTRescueInfoViewController.h"
#import "JTCarNumberTableViewCell.h"
#import "TFTitleTableViewCell.h"
#import "JTSwitchDetailTableViewCell.h"

#import "JTCarBrandViewController.h"
#import "JTAliasKeyboard.h"
#import "JTCarNumberKeyboard.h"

#import "JTRescueOrderViewController.h"

@interface JTRescueInfoViewController () <UITableViewDataSource, TextViewDelegate, JTCarNumberTableViewCellDelegate, JTCarNumberKeyboardDelegate, JTCarModelViewControllerDelegate>

@property (strong, nonatomic) JTRescueOrderModel *model;

@property (strong, nonatomic) JTCarNumberKeyboard *carNumberKeyboard;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@end

@implementation JTRescueInfoViewController

- (instancetype)initWithRescueType:(JTRescueType)rescueType startPlacemark:(MKPlacemark *)startPlacemark dataDic:(NSDictionary *)dataDic
{
    return [self initWithRescueType:rescueType startPlacemark:startPlacemark endPlacemark:nil dataDic:dataDic];
}

- (instancetype)initWithRescueType:(JTRescueType)rescueType startPlacemark:(MKPlacemark *)startPlacemark endPlacemark:(MKPlacemark *)endPlacemark dataDic:(NSDictionary *)dataDic
{
    self = [super initWithNibName:@"JTRescueInfoViewController" bundle:nil];
    if (self) {
        _rescueType = rescueType;
        _startPlacemark = startPlacemark;
        _endPlacemark = endPlacemark;
        _dataDic = dataDic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.model setRescueType:self.rescueType];
    [self.model setPrice:[NSString stringWithFormat:@"%@", self.dataDic[@"price"]]];
    
    if (self.startPlacemark) {
        NSString *point = [NSString stringWithFormat:@"%.6f,%.6f", self.startPlacemark.location.coordinate.longitude, self.startPlacemark.location.coordinate.latitude];
        [self.model setStartPoint:point];
        [self.model setStartAddress:self.startPlacemark.title];
    }
    if (self.endPlacemark) {
        NSString *point = [NSString stringWithFormat:@"%.6f,%.6f", self.endPlacemark.location.coordinate.longitude, self.endPlacemark.location.coordinate.latitude];
        [self.model setEndPoint:point];
        [self.model setEndAddress:self.endPlacemark.title];
    }
    [self.model setCarAlias:@"粤"];
    if ([JTUserInfo shareUserInfo].isLogin) {
        self.model.contacts = [JTUserInfo shareUserInfo].userName;
        self.model.contactsNumber = [JTUserInfo shareUserInfo].userPhone;
    }
    [self.navigationItem setTitle:(self.rescueType == JTRescueTypeLiftElectricity)?@"搭电":@"拖车"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:0 sectionFooterHeight:10];
    [self.tableview setDataSource:self];
    [self.view insertSubview:self.tableview atIndex:0];
    [self.tableview registerClass:[JTCarNumberTableViewCell class] forCellReuseIdentifier:carNumberIndentifier];
    [self.tableview registerClass:[TFTitleTableViewCell class] forCellReuseIdentifier:tfTitleIdentifier];
    [self.tableview registerClass:[JTSwitchDetailTableViewCell class] forCellReuseIdentifier:switchDetailIdentifier];
    [self.bottomView setTop:APP_Frame_Height-kBottomBarHeight];
    
    NSString *string = [NSString stringWithFormat:@"￥%@ 平均40分钟内到达现场", self.model.price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3 range:[string rangeOfString:@"平均40分钟内到达现场"]];
    [attributedString addAttribute:NSFontAttributeName value:Font(16) range:[string rangeOfString:self.model.price]];
    self.infoLB.attributedText = attributedString;
}

- (IBAction)payClick:(id)sender {
    if (!self.model.carID || [self.model.carID isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请选择车型"];
        return;
    }
    if (!self.model.carNumber || [self.model.carNumber isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入车牌号"];
        return;
    }
    NSString *plateNumber = [NSString stringWithFormat:@"%@%@", self.model.carAlias, self.model.carNumber];
    if (![plateNumber isCarNumber]) {
        [[HUDTool shareHUDTool] showHint:@"请输入正确车牌号"];
        return;
    }
    if (!self.model.contacts || [self.model.contacts isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入救援联系人"];
        return;
    }
    if (!self.model.contactsNumber || [self.model.contactsNumber isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入手机号"];
        return;
    }
    if (![self.model.contactsNumber isMobileNumber]) {
        [[HUDTool shareHUDTool] showHint:@"请输入正确的手机号码"];
        return;
    }
    [self.navigationController pushViewController:[[JTRescueOrderViewController alloc] initWithModel:self.model] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return (self.rescueType == JTRescueTypeLiftElectricity) ? 1 : 2;
    }
    else if (section == 1) {
        return 4;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"cell_1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(16);
            cell.textLabel.textColor = BlackLeverColor6;
        }
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"point_green"];
            
            NSString *string = [NSString stringWithFormat:@"位置：%@", self.startPlacemark.title];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3 range:[string rangeOfString:@"位置："]];
            cell.textLabel.attributedText = attributedString;
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"point_orange"];
            
            NSString *string = [NSString stringWithFormat:@"终点：%@", self.endPlacemark.title];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3 range:[string rangeOfString:@"终点："]];
            cell.textLabel.attributedText =attributedString;
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 1) {
            JTCarNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carNumberIndentifier];
            cell.delegate = nil;
            cell.carNumberTableViewCellDelegate = self;
            cell.titleLB.text = self.model.carAlias;
            cell.contentTF.font = Font(16);
            cell.contentTF.textColor = BlackLeverColor6;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.contentTF.placeholder = @"请输入车牌号";
            cell.contentTF.text = self.model.carNumber;
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
                cell.contentTF.text = self.model.carName;
            }
            else if (indexPath.row == 2) {
                cell.titleLB.text = @"救援联系人";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.contentTF.userInteractionEnabled = YES;
                cell.contentTF.placeholder = @"请输入联系人姓名";
                cell.contentTF.text = self.model.contacts;
            }
            else if (indexPath.row == 3) {
                cell.titleLB.text = @"手机号";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.contentTF.userInteractionEnabled = YES;
                cell.contentTF.placeholder = @"请输入联系人手机号";
                cell.contentTF.text = self.model.contactsNumber;
                cell.contentTF.keyboardType = UIKeyboardTypePhonePad;
            }
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0) {
            JTSwitchDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchDetailIdentifier];
            cell.textLabel.text = @"发票";
            cell.textLabel.font = Font(14);
            cell.textLabel.textColor = BlackLeverColor6;
            cell.detailLB.text = @"不需要发票";
            cell.detailLB.font = Font(16);
            cell.detailLB.textColor = BlackLeverColor3;
            cell.detailLB.textAlignment = NSTextAlignmentRight;
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"cell_2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.textLabel.font = Font(16);
                cell.textLabel.textColor = BlackLeverColor6;
                cell.detailTextLabel.font = Font(16);
                cell.detailTextLabel.textColor = BlackLeverColor3;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.imageView.image = [UIImage imageNamed:@"icon_ticket"];
            cell.textLabel.text = @"我的优惠券";
            cell.detailTextLabel.text = @"无可用优惠券";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.navigationController pushViewController:[[JTCarBrandViewController alloc] initWithDelegate:self] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)text:(id)text changeEditingAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            self.model.contacts = text;
        }
        else
        {
            self.model.contactsNumber = text;
        }
    }
}

- (void)carNumberTableViewCellAtChoiceAlias:(JTCarNumberTableViewCell *)carNumberTableViewCell
{
    [self endEditing];
    __weak typeof(self) weakself = self;
    [[[JTAliasKeyboard alloc] init] showInView:self.view choiceBlock:^(NSString *alias) {
        [weakself.model setCarAlias:alias];
        [weakself.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)carNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard didChangeText:(NSString *)text
{
    JTCarNumberTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.contentTF.text = text;
    self.model.carNumber = text;
}

- (void)cancelInCarNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard
{
    [self.view endEditing:YES];
}

- (void)carModelViewController:(JTCarModelViewController *)carModelViewController didSelectAtSource:(NSDictionary *)source
{
    [self.model setCarName:[source objectForKey:@"series_name"]];
    [self.model setCarID:[NSString stringWithFormat:@"%@", [source objectForKey:@"spec_id"]]];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

- (JTCarNumberKeyboard *)carNumberKeyboard
{
    if (!_carNumberKeyboard) {
        _carNumberKeyboard = [[JTCarNumberKeyboard alloc] init];
        _carNumberKeyboard.delegate = self;
    }
    return _carNumberKeyboard;
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

- (JTRescueOrderModel *)model
{
    if (!_model) {
        _model = [[JTRescueOrderModel alloc] init];
    }
    return _model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
