//
//  JTCarCertificationViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "JTFlowView.h"
#import "JTCarCertificationFlowTableViewCell.h"
#import "JTCarCertificationRewardTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTCarCertificationViewController.h"
#import "JTCarCertificationComplainViewController.h"
#import "JTCarCertificationConfirmationViewController.h"

@interface JTCarCertificationViewController () <UITableViewDataSource, JTCarCertificationEntryTableViewCellDelegate>
{
    void (^_successHandler)(id);
    void (^_failHandler)(NSError *);
}
@property (nonatomic, strong) JTFlowView *tableHeadView;

@end

@implementation JTCarCertificationViewController

- (instancetype)initCarModel:(JTCarModel *)carModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _carModel = carModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆认证";
    [self setupComponent];
    [self configCallback];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:100 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview registerClass:[JTCarCertificationEntryTableViewCell class] forCellReuseIdentifier:carCertificationEntryIdentifier];
    [self.tableview registerClass:[JTCarCertificationDescribeTableViewCell class] forCellReuseIdentifier:carCertificationDescribeIdentifier];
}

- (void)setupComponent {
    self.dataArray = [NSMutableArray arrayWithArray:@[@{@"title" : @" 车辆要求", @"describe" : @"目前只针对平台已有的车型开放（对载重货车、摩托车、军车等暂不开放）"},
                                                      @{@"title" : @"证件要求", @"describe" : @"1.所提交证件必须真实，证件信息必须与您的车辆信息一致，且证件需要在有效期内。\n\n2.所有汉字、数字、图片都拍摄在内，以上信息不能有缺失，且不允许人为遮挡。证件周围不允许加上边框。\n\n3.所有审核的证件信息内容要求图片信息清洗：含底纹、字体、头像、无反光造成的盲点。\n\n4.提供的证件图片必须是彩色原件图片或扫描件，不允许复印。"}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        JTCarCertificationEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCertificationEntryIdentifier];
        cell.delegate = self;
        return cell;
    }
    else
    {
        JTCarCertificationDescribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCertificationDescribeIdentifier];
        NSDictionary *dictionary = self.dataArray[indexPath.row];
        cell.titleLB.text = [dictionary objectForKey:@"title"];
        cell.describeLB.text = [dictionary objectForKey:@"describe"];
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?1:2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?0:10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section == 0)
    {
        return [tableView fd_heightForCellWithIdentifier:carCertificationEntryIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        }];
    }
    else
    {
        __weak typeof(self)weakSelf = self;
        return [tableView fd_heightForCellWithIdentifier:carCertificationDescribeIdentifier cacheByIndexPath:indexPath configuration:^(JTCarCertificationDescribeTableViewCell *cell) {
            NSDictionary *dictionary = weakSelf.dataArray[indexPath.row];
            cell.titleLB.text = [dictionary objectForKey:@"title"];
            cell.describeLB.text = [dictionary objectForKey:@"describe"];
        }];
    }
}

#pragma mark JTCarCertificationEntryTableViewCellDelegate
- (void)recognizeLicence {
    __weak typeof(self)weakSelf = self;
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        weakSelf.licenseImage = image;
        [[HUDTool shareHUDTool] showHint:@"识别中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate];
        [[AipOcrService shardService] detectVehicleLicenseFromImage:image
                                                        withOptions:nil
                                                     successHandler:_successHandler
                                                        failHandler:_failHandler];
    }];
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    // 这是默认的识别成功的回调
    _successHandler = ^(id result) {
   
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.navigationController pushViewController:[[JTCarCertificationConfirmationViewController alloc] initWithLicenceImge:weakSelf.licenseImage result:result carModel:weakSelf.carModel] animated:YES];
        }];
        
    };
    
    _failHandler = ^(NSError *error) {
     
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[HUDTool shareHUDTool] showHint:@"行驶证识别失败" yOffset:0];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        
    };
}

- (JTFlowView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTFlowView alloc] initImageArray:@[@"icon_entery_seleted", @"icon_comfirm_normal", @"icon_success_normal"] titleArray:@[@"信息录入", @"信息确认", @"认证成功"] frame:CGRectMake(0, 0, App_Frame_Width, 94)];
        _tableHeadView.currentFlow = 1;
    }
    return _tableHeadView;
}

@end
