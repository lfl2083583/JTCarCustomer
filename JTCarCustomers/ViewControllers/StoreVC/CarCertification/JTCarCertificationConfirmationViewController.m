//
//  JTCarCertificationConfirmationViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "ZTObtainPhotoTool.h"
#import "ZTFileNameTool.h"

#import "JTFlowView.h"
#import "JTAliasKeyboard.h"
#import "JTCarNumberKeyboard.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTCarCertificationFlowTableViewCell.h"
#import "JTCarCertificationPhotoTableViewCell.h"
#import "JTCarCertificationLicenseTableViewCell.h"
#import "JTCarCertificationConfirmationTableViewCell.h"

#import "JTCarCertificationConfirmationViewController.h"
#import "JTCarCertificationComplainViewController.h"
#import "JTCarCertificationRewardViewController.h"


@interface JTCarCertificationConfirmationViewController () <UITableViewDataSource, JTCarCertificationPhotoTableViewCellDelegate, JTCarCertificationLicenseTableViewCellDelegate, JTCarNumberKeyboardDelegate, TextViewDelegate>
{
    void (^_successHandler)(id);
    void (^_failHandler)(NSError *);
}
@property (nonatomic, strong) JTFlowView *tableHeadView;
@property (nonatomic, strong) JTCarNumberKeyboard *carNumberKeyboard;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UIImage *idcardImge;

@property (nonatomic, copy) NSString *carSite;
@property (nonatomic, copy) NSString *carLicense;
@property (nonatomic, copy) NSString *carVIN;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *idCardNum;
@property (nonatomic, assign) CGFloat tempY;
@property (nonatomic, assign) BOOL needRealAuth;

@end

@implementation JTCarCertificationConfirmationViewController

- (void)dealloc {
    CCLOG(@"JTCarCertificationConfirmationViewController销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithLicenceImge:(UIImage *)licenceImge result:(id)result carModel:(JTCarModel *)carModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _carModel = carModel;
        _licenceImge = licenceImge;
        _result = result;
        NSDictionary *wordsResult = [result objectForKey:@"words_result"];
        if (wordsResult && [wordsResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *licenseDict = [wordsResult objectForKey:@"号牌号码"];
            NSString *licenseNum = [licenseDict objectForKey:@"words"];
            NSDictionary *vinDict = [wordsResult objectForKey:@"车辆识别代号"];
            if (licenseNum && [licenseNum isKindOfClass:[NSString class]] && licenseNum.length > 1) {
                _carSite = [licenseNum substringWithRange:NSMakeRange(0, 1)];
                _carLicense = [licenseNum substringWithRange:NSMakeRange(1, licenseNum.length-1)];
            }
            _carVIN = [vinDict objectForKey:@"words"];
            _needRealAuth = ([JTUserInfo shareUserInfo].userAuthStatus == JTRealCertificationStatusUnAuth || [JTUserInfo shareUserInfo].userAuthStatus == JTRealCertificationStatusAuthFail)?YES:NO;
        }
    }
    return self;
}


- (void)bottomBtnClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    
    if (!self.carSite || [self.carSite isBlankString] || !self.carLicense || [self.carLicense isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入车牌号" yOffset:0];
        return;
    }
    
    if (!self.carVIN || [self.carVIN isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入车辆识别代号" yOffset:0];
        return;
    }
    
    if (self.needRealAuth && !self.idcardImge) {
        [[HUDTool shareHUDTool] showHint:@"请上传身份证照片" yOffset:0];
        return;
    }
    
    if (self.needRealAuth && (!self.realName || [self.realName isBlankString])) {
        [[HUDTool shareHUDTool] showHint:@"请输入真实姓名" yOffset:0];
        return;
    }
    if (self.needRealAuth && (!self.idCardNum || [self.idCardNum isBlankString])) {
        [[HUDTool shareHUDTool] showHint:@"请输入身份证号码" yOffset:0];
        return;
    }
    [[HttpRequestTool sharedInstance] uploadWithFileNames:[ZTFileNameTool showFileNamesForCarAuthFileNum:self.needRealAuth?2:1] uploadFileArr:self.needRealAuth?@[self.licenceImge, self.idcardImge]:@[self.licenceImge] success:^(id responseObject) {
        NSArray *array = responseObject;
        if (array && [array isKindOfClass:[NSArray class]]) {
            NSMutableDictionary *progrem = [NSMutableDictionary dictionary];
            [progrem setValue:weakSelf.carModel.carID forKey:@"car_id"];
            [progrem setValue:weakSelf.carVIN forKey:@"car_vin"];
            [progrem setValue:[NSString stringWithFormat:@"%@%@", weakSelf.carSite, weakSelf.carLicense] forKey:@"car_cards"];
            [progrem setValue:[NSString stringWithFormat:@"%@",array[0]] forKey:@"driving_license_positive"];
            
            if (weakSelf.needRealAuth) {
                [progrem setValue:weakSelf.realName forKey:@"full_name"];
                [progrem setValue:weakSelf.idCardNum forKey:@"card_license"];
                [progrem setValue:[NSString stringWithFormat:@"%@",array[1]] forKey:@"card_license_positive"];
            }
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/car/auth/add") parameters:progrem success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"提交认证成功" yOffset:0];
                UIViewController *viewController;
                for (UIViewController *vc in weakSelf.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[JTCarCertificationRewardViewController class]]) {
                        viewController = vc;
                    }
                }
                weakSelf.carModel.isAuth = 2;
                [[JTUserInfo shareUserInfo] save];
                [[NSNotificationCenter defaultCenter] postNotificationName:carCertificationChangeNotificationName object:nil];
                [weakSelf.navigationController popToViewController:viewController animated:YES];
                
            } failure:^(NSError *error) {
                
                if (error.code == 80092) {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"认证失败" message:@"您的身份信息已被其他账户认证，若不是本人操作，请尽快提交申诉，由客服为您处理，处理结果会在2个工作日内通过系统消息通知到您。" preferredStyle:UIAlertControllerStyleAlert];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"提交申诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf.navigationController pushViewController:[[JTCarCertificationComplainViewController alloc] init] animated:YES];
                    }]];
                    [weakSelf presentViewController:alertVC animated:YES completion:nil];
                    
                }
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆认证";
    [self setupComponent];
    [self configCallback];
    [self.view addSubview:self.bottomBtn];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-45) rowHeight:100 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview registerClass:[JTCarCertificationPhotoTableViewCell class] forCellReuseIdentifier:carCertificationPhotoIdentifier];
    [self.tableview registerClass:[JTCarCertificationLicenseTableViewCell class] forCellReuseIdentifier:carCertificationLicenseIdentifier];
    [self.tableview registerClass:[JTCarCertificationConfirmationTableViewCell class] forCellReuseIdentifier:carCertificationConfirmationIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupComponent {
    self.idcardImge = [UIImage imageNamed:@"certificate_photo"];
    self.dataArray = [NSMutableArray arrayWithArray:@[@"行驶证正面照片", @"车牌号码", @"车辆识别代号（VIN）"]];
    if (_needRealAuth) {
        [self.dataArray insertObject:@"身份证正面照片\n需要提供与行驶证所有人相同姓名的" atIndex:1];
        [self.dataArray addObjectsFromArray:@[@"姓名", @"身份证号"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *itemTitle = self.dataArray[indexPath.row];
    if ([itemTitle isEqualToString:@"行驶证正面照片"] || [itemTitle isEqualToString:@"身份证正面照片\n需要提供与行驶证所有人相同姓名的"])
    {
        JTCarCertificationPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCertificationPhotoIdentifier];
        cell.titleLB.text = self.dataArray[indexPath.row];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell.certificateBtn setImage:[itemTitle isEqualToString:@"行驶证正面照片"]?self.licenceImge:self.idcardImge forState:UIControlStateNormal];
        return cell;
    }
    else if (([itemTitle isEqualToString:@"车牌号码"]))
    {
        JTCarCertificationLicenseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCertificationLicenseIdentifier];
        cell.titleLB.text = self.dataArray[indexPath.row];
        [cell.siteBtn setTitle:self.carSite?self.carSite:@"粤" forState:UIControlStateNormal];
        [cell.licenseTF setText:self.carLicense];
        cell.licenseTF.inputView = self.carNumberKeyboard;
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    else
    {
        JTCarCertificationConfirmationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCertificationConfirmationIdentifier];
        cell.titleLB.text = self.dataArray[indexPath.row];
        cell.detailTF.placeholder = @"必填";
        cell.delegate = self;
        cell.indexPath = indexPath;
        if ([itemTitle isEqualToString:@"车辆识别代号（VIN）"]) {
            cell.detailTF.text = self.carVIN;
        }
        else if ([itemTitle isEqualToString:@"姓名"])
        {
           cell.detailTF.text = self.realName;
        }
        else if ([itemTitle isEqualToString:@"身份证号"])
        {
           cell.detailTF.text = self.idCardNum;
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    NSString *itemTitle = self.dataArray[indexPath.row];
   if ([itemTitle isEqualToString:@"行驶证正面照片"] ||  [itemTitle isEqualToString:@"身份证正面照片\n需要提供与行驶证所有人相同姓名的"])
    {
        return [tableView fd_heightForCellWithIdentifier:carCertificationPhotoIdentifier cacheByIndexPath:indexPath configuration:^(JTCarCertificationPhotoTableViewCell *cell) {
            cell.titleLB.text = weakSelf.dataArray[indexPath.row];
        }];
    }
    else if (([itemTitle isEqualToString:@"车牌号码"]))
    {
        return [tableView fd_heightForCellWithIdentifier:carCertificationLicenseIdentifier cacheByIndexPath:indexPath configuration:^(JTCarCertificationLicenseTableViewCell *cell) {
            
        }];
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:carCertificationConfirmationIdentifier cacheByIndexPath:indexPath configuration:^(JTCarCertificationConfirmationTableViewCell *cell) {
            
        }];
    }
}

#pragma mark JTCarCertificationLicenseTableViewCellDelegate
- (void)chooseCarSite:(id)sender indexPath:(NSIndexPath *)indexPath {
    [self endEditing];
    
    __weak typeof(self)weakSelf = self;
    JTAliasKeyboard *aliasKeyboard = [[JTAliasKeyboard alloc] init];
    [aliasKeyboard showInView:self.view choiceBlock:^(NSString *alias) {
        weakSelf.carSite = alias;
        [weakSelf endEditing];
        [weakSelf.tableview reloadData];
    }];
    
    aliasKeyboard.cancelBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.tableview setY:kStatusBarHeight+kTopBarHeight];
        }];
    };
    
    [self handleKeyboard:aliasKeyboard indexPath:indexPath];
}

- (void)carCertificationLicenseShouldBeginEditing:(id)sender indexPath:(NSIndexPath *)indexPath {
    [self handleKeyboard:self.carNumberKeyboard indexPath:indexPath];
}

- (void)carCertificationLicenseDidEndChangeEditing:(id)sender indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.tableview setY:kStatusBarHeight+kTopBarHeight];
    }];
}

- (void)handleKeyboard:(UIView *)keyboard indexPath:(NSIndexPath *)indexPath {
    //键盘遮挡处理
    CGRect rectInTableView = [self.tableview rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableview convertRect:rectInTableView toView:[self.tableview superview]];
    CGFloat tempY = rect.origin.y+80;
    CGFloat aliasKeyboardY = APP_Frame_Height-keyboard.height;
    CGFloat offset =  tempY-aliasKeyboardY;
    if (offset > 0) {
        [self.tableview setY:kStatusBarHeight+kTopBarHeight+aliasKeyboardY-tempY];
    }
}

#pragma mark JTCarNumberKeyboardDelegate
- (void)carNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard didChangeText:(NSString *)text
{
    JTCarCertificationLicenseTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:([JTUserInfo shareUserInfo].userAuthStatus == JTRealCertificationStatusUnAuth || [JTUserInfo shareUserInfo].userAuthStatus == JTRealCertificationStatusAuthFail)?2:1 inSection:0]];
    cell.licenseTF.text = text;
    self.carLicense = text;
}

- (void)cancelInCarNumberKeyboard:(JTCarNumberKeyboard *)carNumberKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark TextViewDelegate
- (void)textUI:(id)textUI startEditingAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rectInTableView = [self.tableview rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableview convertRect:rectInTableView toView:[self.tableview superview]];
    self.tempY = rect.origin.y+80;
    
}

#pragma mark JTCarCertificationPhotoTableViewCellDelegate
- (void)recognizeCard:(NSIndexPath *)indexPath {
    NSString *itemTitle = self.dataArray[indexPath.row];
    if ([itemTitle isEqualToString:@"身份证正面照片\n需要提供与行驶证所有人相同姓名的"]) {
        __weak typeof(self)weakSelf = self;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController * vc =
            [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                         andImageHandler:^(UIImage *image) {
                                             weakSelf.idcardImge = image;
                                             [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                          withOptions:nil
                                                                                       successHandler:_successHandler
                                                                                          failHandler:_failHandler];
                                         }];
            
            [weakSelf presentViewController:vc animated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZTObtainPhotoTool shareObtainPhotoTool] show:weakSelf sourceType:1 photoEditType:JTPhotoEditTypeDisable success:^(UIImage *image) {
                weakSelf.idcardImge = image;
                [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                             withOptions:nil
                                                          successHandler:_successHandler
                                                             failHandler:_failHandler];
            } cancel:^{
                
            }];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    _successHandler = ^(id result) {
        NSLog(@"%@", result);
        NSDictionary *wordsResult = [result objectForKey:@"words_result"];
        if (wordsResult && [wordsResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *idNumDict = [wordsResult objectForKey:@"公民身份号码"];
            NSDictionary *realNameDict = [wordsResult objectForKey:@"姓名"];
            weakSelf.idCardNum = [idNumDict objectForKey:@"words"];
            weakSelf.realName = [realNameDict objectForKey:@"words"];
            
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.tableview reloadData];
        
    };
    
    _failHandler = ^(NSError *error) {
        NSLog(@"%@", error);
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.tableview reloadData];
    };
}

#pragma mark NSNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = self.tempY-frame.origin.y;
    if (offset > 0) {
        [self.tableview setY:kStatusBarHeight+kTopBarHeight+frame.origin.y-self.tempY];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.tableview setY:kStatusBarHeight+kTopBarHeight];
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

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.frame = CGRectMake(0, APP_Frame_Height-45, App_Frame_Width, 45);
        _bottomBtn.backgroundColor = BlueLeverColor1;
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (JTFlowView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTFlowView alloc] initImageArray:@[@"icon_entery_seleted", @"icon_comfirm_seleted", @"icon_success_normal"] titleArray:@[@"信息录入", @"信息确认", @"认证成功"] frame:CGRectMake(0, 0, App_Frame_Width, 94)];
        _tableHeadView.currentFlow = 2;
    }
    return _tableHeadView;
}

- (JTCarNumberKeyboard *)carNumberKeyboard
{
    if (!_carNumberKeyboard) {
        _carNumberKeyboard = [[JTCarNumberKeyboard alloc] init];
        _carNumberKeyboard.delegate = self;
    }
    return _carNumberKeyboard;
}

@end
