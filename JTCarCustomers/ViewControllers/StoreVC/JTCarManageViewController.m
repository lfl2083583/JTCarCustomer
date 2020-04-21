//
//  JTCarManageViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarManageViewController.h"
#import "JTCarTableViewCell.h"
#import "JTGradientButton.h"
#import "JTAddCarViewController.h"
#import "JTCarCertificationRewardViewController.h"
#import "JTCarEditViewController.h"
#import "JTMyLoveCarViewController.h"

@interface JTCarManageViewController () <UITableViewDataSource, JTCarNumberTableViewCellDelegate>

@property (nonatomic, strong) JTGradientButton *addBT;
@property (nonatomic, strong) UILabel *promptLB;
@property (nonatomic, assign) BOOL isUnsort;

@end

@implementation JTCarManageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    [super viewWillAppear:animated];
}

- (void)reloadData
{
    if (!self.isUnsort) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[JTUserInfo shareUserInfo].myCarList];
    }
    [self setIsUnsort:NO];
    [self reloadUI];
}

- (void)reloadUI
{
    [self.tableview setHidden:!self.dataArray.count];
    [self.promptLB setHidden:self.dataArray.count];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"管理车型"];
    [self.view addSubview:self.promptLB];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-self.addBT.height) rowHeight:150 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTCarTableViewCell class] forCellReuseIdentifier:carIndentifier];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.addBT];
}


- (void)addClick:(id)sender
{
    [self.navigationController pushViewController:[[JTAddCarViewController alloc] init] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carIndentifier];
    cell.delegate = self;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)carTableViewCell:(JTCarTableViewCell *)carTableViewCell carOperationType:(JTCarOperationType)carOperationType
{
    switch (carOperationType) {
        case JTCarOperationTypeDefault:
        {
            __weak typeof(self) weakself = self;
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(setCarApi) parameters:@{@"car_id": carTableViewCell.model.carID} success:^(id responseObject, ResponseState state) {
                [[JTUserInfo shareUserInfo] resetDefaultCarModel:carTableViewCell.model];
                [[JTUserInfo shareUserInfo] save];
                for (JTCarModel *model in weakself.dataArray) {
                    model.isDefault = [model.carID isEqualToString:carTableViewCell.model.carID];
                }
                [weakself.tableview reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMyCarListNotification object:nil];
            } failure:^(NSError *error) {
            }];
        }
            break;
        case JTCarOperationTypeAuth:
        {
            [self.navigationController pushViewController:[[JTCarCertificationRewardViewController alloc] initCarModel:carTableViewCell.model] animated:YES];
        }
            break;
        case JTCarOperationTypeEdit:
        {
            [self setIsUnsort:YES];
            [self.navigationController pushViewController:[[JTCarEditViewController alloc] initWithModel:carTableViewCell.model] animated:YES];
        }
            break;
        case JTCarOperationTypeDelete:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除车型后，车型数据将不再保留，" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            }]];
            __weak typeof(self) weakself = self;
            [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(delCarApi) parameters:@{@"car_id": carTableViewCell.model.carID} success:^(id responseObject, ResponseState state) {
                    if (!carTableViewCell.model.isDefault) {
                        [weakself.dataArray removeObject:carTableViewCell.model];
                        [weakself.tableview reloadData];
                        [[JTUserInfo shareUserInfo].myCarList removeObject:carTableViewCell.model];
                        [[JTUserInfo shareUserInfo] save];
                        [weakself handleMyCarListEmpty];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMyCarListNotification object:nil];
                    }
                    else
                    {
                        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCarApi) parameters:nil success:^(id responseObject, ResponseState state) {
                            [[JTUserInfo shareUserInfo].myCarList removeAllObjects];
                            if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                                [[JTUserInfo shareUserInfo].myCarList addObjectsFromArray:[JTCarModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
                            }
                            [[JTUserInfo shareUserInfo] save];
                            [[HUDTool shareHUDTool] showHint:@"删除成功" yOffset:0];
                            [weakself reloadData];
                            [weakself handleMyCarListEmpty];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMyCarListNotification object:nil];
                        } failure:^(NSError *error) {
                        }];
                    }
                } failure:^(NSError *error) {
                }];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)handleMyCarListEmpty {
    if (![JTUserInfo shareUserInfo].myCarList.count) {
        UIViewController *myLoveCarVC;
        UIViewController *carManagerVC;
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[JTMyLoveCarViewController class]]) {
                myLoveCarVC = viewController;
            } else if ([viewController isKindOfClass:[JTCarManageViewController class]])
            {
                carManagerVC = viewController;
            }
        }
        UIViewController *rootVC = self.navigationController.viewControllers[0];
        if (myLoveCarVC && carManagerVC) {
            self.navigationController.viewControllers  = @[rootVC, myLoveCarVC, carManagerVC];
        } else if (!myLoveCarVC && carManagerVC){
            self.navigationController.viewControllers  = @[rootVC, carManagerVC];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (JTGradientButton *)addBT
{
    if (!_addBT) {
        _addBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        _addBT.cornerRadius = .0f;
        [_addBT setTitle:@"+ 新增车型" forState:UIControlStateNormal];
        [_addBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_addBT.titleLabel setFont:Font(18)];
        [_addBT setFrame:CGRectMake(0, APP_Frame_Height-44, App_Frame_Width, 44)];
        [_addBT addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBT;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] init];
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.font = Font(16);
        _promptLB.textAlignment = NSTextAlignmentCenter;
        _promptLB.text = @"你还未添加爱车~";
        _promptLB.frame = CGRectMake(0, 200, App_Frame_Width, 20);
    }
    return _promptLB;
}

@end
