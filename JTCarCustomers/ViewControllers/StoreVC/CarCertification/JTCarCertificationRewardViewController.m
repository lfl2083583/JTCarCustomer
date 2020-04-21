//
//  JTCarCertificationRewardViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIImage+Extension.h"
#import "JTCarCertificationStatusView.h"
#import "JTCarCertificationHelpTableViewCell.h"
#import "JTSmartMaintenanceTableHeadView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTCarCertificationRewardTableViewCell.h"

#import "JTCarCertificationRewardViewController.h"
#import "JTCarCertificationViewController.h"

@interface JTCarCertificationRewardViewController () <UITableViewDataSource, JTSmartMaintenanceDelegate>

@property (nonatomic, strong) JTSmartMaintenanceTableHeadView *maintenanceView;
@property (nonatomic, strong) JTCarCertificationStatusView *authStatusView;
@property (nonatomic, strong) UIView *approveView;

@end

@implementation JTCarCertificationRewardViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:carCertificationChangeNotificationName object:nil];
}

- (instancetype)initCarModel:(JTCarModel *)carModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _carModel = carModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证有礼";
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:100 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setTableHeaderView:(self.carModel.isAuth == -1)?self.maintenanceView:self.authStatusView];
    [self.tableview registerClass:[JTCarCertificationRewardTableViewCell class] forCellReuseIdentifier:carCertificationRewardIdentifier];
    [self.tableview registerClass:[JTCarCertificationHelpTableViewCell class] forCellReuseIdentifier:carCertificationHelpIdentifier];
    
    [self carCertificationStatusChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carCertificationStatusChanged) name:carCertificationChangeNotificationName object:nil];
    // Do any additional setup after loading the view.
}

- (void)carCertificationStatusChanged
{
    if (self.carModel.isAuth == 2) {
        [self.tableview setTableHeaderView:self.authStatusView];
        [self requestData];
    } else {
        [self.tableview reloadData];
    }
}

- (void)requestData {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/system/qa/faqs") parameters:@{@"type_id" : @(1)} success:^(id responseObject, ResponseState state) {
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        [weakSelf.tableview reloadData];
    } failure:^(NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.carModel.isAuth == 2) {
        if (indexPath.row == 0) {
            static NSString *normalIdentifier = @"UITableViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
                cell.textLabel.font = Font(14);
                cell.textLabel.textColor = BlackLeverColor6;
                cell.userInteractionEnabled = NO;
            }
            cell.imageView.image = [UIImage graphicsImageWithColor:BlueLeverColor1 rect:CGRectMake(0, 0, 4, 14)];
            cell.textLabel.text = @"认证常见问题";
            return cell;
        }
        else
        {
            JTCarCertificationHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCertificationHelpIdentifier];
            cell.source = self.dataArray[indexPath.row-1];
            cell.userInteractionEnabled = NO;
            return cell;
        }
        
    }
    else
    {
        JTCarCertificationRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carCertificationRewardIdentifier];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.carModel.isAuth == 2)?self.dataArray.count+1:1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.carModel.isAuth == 2)?1:self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     __weak typeof(self)weakSelf = self;
    if (self.carModel.isAuth == 2) {
        if (indexPath.row == 0) {
            return 30;
        }
        else
        {
           
            return [tableView fd_heightForCellWithIdentifier:carCertificationHelpIdentifier cacheByIndexPath:indexPath configuration:^(JTCarCertificationHelpTableViewCell *cell) {
                cell.source = weakSelf.dataArray[indexPath.row-1];
            }];
        }
        
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:carCertificationRewardIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            
        }];
    }
}

#pragma mark JTSmartMaintenanceDelegate 去认证车辆

- (void)chooseLoveCar {
    [self.navigationController pushViewController:[[JTCarCertificationViewController alloc] initCarModel:self.carModel] animated:YES];
}

- (JTSmartMaintenanceTableHeadView *)maintenanceView {
    if (!_maintenanceView) {
        _maintenanceView = [[JTSmartMaintenanceTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, 90)];
        _maintenanceView.delegate = self;
        _maintenanceView.rightBtn.enabled = YES;
        [_maintenanceView.carIcon setAvatarByUrlString:[self.carModel.icon avatarHandleWithSquare:100] defaultImage:[UIImage imageNamed:@""]];
        _maintenanceView.nameLB.text = self.carModel.brand;
        _maintenanceView.modelLB.text = [NSString stringWithFormat:@"%@",self.carModel.name];
        _maintenanceView.travelLB.text = [NSString stringWithFormat:@"%@",self.carModel.mileageStr];
        [_maintenanceView.rightBtn setTitle:@"去认证" forState:UIControlStateNormal];
    }
    return _maintenanceView;
}

- (JTCarCertificationStatusView *)authStatusView {
    if (!_authStatusView) {
        _authStatusView = [[JTCarCertificationStatusView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, (self.carModel.isAuth == 1)?250:304) carAuthStatus:self.carModel.isAuth];
    }
    return _authStatusView;
}


@end
