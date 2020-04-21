//
//  JTCarCertificationComplainViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTFileNameTool.h"
#import "JTWordItem.h"
#import "JTFlowView.h"
#import "JTRealCertificationView.h"
#import "JTTFTitleTableViewCell.h"
#import "JTCarCertificationComplainViewController.h"

static NSString *const normalIdentifier = @"UITableViewCell";

@interface JTCarCertificationComplainViewController () <UITableViewDataSource, JTRealCertificationViewDelegate, JTTFTitleTableViewCellDelegate>

@property (nonatomic, strong) JTFlowView *tableHeadView;
@property (nonatomic, strong) JTRealCertificationFootView *tableFootView;

@property (nonatomic, strong) UIImage *IDCardImge1;
@property (nonatomic, strong) UIImage *IDCardImge2;
@property (nonatomic, strong) UIImage *IDCardImge3;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *IDNum;
@property (nonatomic, copy) NSString *phoneNum;

@end

@implementation JTCarCertificationComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆认证";
    [self setupComponent];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview setTableFooterView:self.tableFootView];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:normalIdentifier];
    [self.tableview registerNib:[UINib nibWithNibName:@"JTTFTitleTableViewCell" bundle:nil] forCellReuseIdentifier:tfTitleIdentifier];
}
     
- (void)setupComponent {
    JTWordItem *item0 = [self creatItemWithTitle:@"*身份证验证申诉" placeHolder:@"" identifier:normalIdentifier];
    JTWordItem *item1 = [self creatItemWithTitle:@"真实姓名" placeHolder:@"请填写真实姓名" identifier:tfTitleIdentifier];
    JTWordItem *item2 = [self creatItemWithTitle:@"身份证号" placeHolder:@"请填写真实身份证号码" identifier:tfTitleIdentifier];
    JTWordItem *item3 = [self creatItemWithTitle:@"联系电话" placeHolder:@"当前可联系到本人的电话号码" identifier:tfTitleIdentifier];
    self.dataArray = [NSMutableArray arrayWithArray:@[item0, item1, item2, item3]];
}

- (JTWordItem *)creatItemWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder identifier:(NSString *)identifier {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.placeholder = placeHolder;
    item.tagID = identifier;
    return item;
 }
     
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.row];
    if ([item.tagID isEqualToString:normalIdentifier]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
        cell.textLabel.text = item.title;
        cell.textLabel.font = Font(18);
        cell.textLabel.textColor = BlackLeverColor6;
        cell.backgroundColor = BlackLeverColor1;
        cell.userInteractionEnabled = NO;
        return cell;
    } else {
        JTTFTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfTitleIdentifier];
        cell.delegate = self;
        [cell configCellTitle:item.title subtitle:item.subTitle placeHolder:item.placeholder indexPath:indexPath textfieldEnable:YES];
        return cell;
    }
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark JTRealCertificationViewDelegate
- (void)realCertificationViewPhotoChoosedIndex:(NSInteger)index image:(UIImage *)image {
    if (index == 0) {
        self.IDCardImge1 = image;
    } else if (index == 1) {
        self.IDCardImge2 = image;
    } else {
        self.IDCardImge3 = image;
    }
}

- (void)realCertificationViewComfirmBtnClick:(id)sender {
    if (!self.realName || [self.realName isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入真实姓名" yOffset:0];
        return;
    }
    if (!self.IDNum || [self.IDNum isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入身份证号码" yOffset:0];
        return;
    }
    if (!self.phoneNum || [self.phoneNum isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入手机号码" yOffset:0];
        return;
    }
    if (self.phoneNum && [self.phoneNum isKindOfClass:[NSString class]] && self.phoneNum.length != 11) {
        [[HUDTool shareHUDTool] showHint:@"请输入正确的手机号码" yOffset:0];
        return;
    }
    if (!self.IDCardImge1 || !self.IDCardImge2 || !self.IDCardImge3) {
        [[HUDTool shareHUDTool] showHint:@"请上传身份证照片" yOffset:0];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] uploadWithFileNames:[ZTFileNameTool showFileNamesForVeriComplainFileNum:3] uploadFileArr:@[self.IDCardImge1, self.IDCardImge2, self.IDCardImge3] success:^(id responseObject) {
        NSArray *array = responseObject;
        if (array && [array isKindOfClass:[NSArray class]] && array.count == 3) {
            NSMutableDictionary *pragrem = [NSMutableDictionary dictionary];
            [pragrem setValue:weakSelf.realName forKey:@"full_name"];
            [pragrem setValue:weakSelf.IDNum forKey:@"card_license"];
            [pragrem setValue:weakSelf.phoneNum forKey:@"contact"];
            [pragrem setValue:[NSString stringWithFormat:@"%@",array[0]] forKey:@"card_license_positive"];
            [pragrem setValue:[NSString stringWithFormat:@"%@",array[1]] forKey:@"card_license_reverse"];
            [pragrem setValue:[NSString stringWithFormat:@"%@",array[2]] forKey:@"card_license_carried"];
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/system/appeal/add") parameters:pragrem success:^(id responseObject, ResponseState state) {
                CCLOG(@"%@",responseObject);
                [[HUDTool shareHUDTool] showHint:@"提交审核成功" yOffset:0];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSError *error) {

            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark JTTFTitleTableViewCellDelegate
- (void)titleTableViewCellTfChanged:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        self.realName = content;
    } else if (indexPath.row == 2) {
        self.IDNum = content;
    } else {
        self.phoneNum = content;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JTRealCertificationFootView *)tableFootView {
 if (!_tableFootView) {
     CGFloat height = 11*(self.view.bounds.size.width-40)/16+200;
     _tableFootView = [[JTRealCertificationFootView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
     [_tableFootView.bottomBtn setTitle:@"提交审核" forState:UIControlStateNormal];
     _tableFootView.delegate = self;
 }
 return _tableFootView;
}

- (JTFlowView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTFlowView alloc] initImageArray:@[@"icon_entery_seleted", @"icon_comfirm_seleted", @"icon_card_seleted", @"icon_success_normal"] titleArray:@[@"信息录入", @"信息确认", @"上传身份证", @"认证成功"] frame:CGRectMake(0, 0, App_Frame_Width, 93)];
        _tableHeadView.currentFlow = 3;
    }
    return _tableHeadView;
}

@end
