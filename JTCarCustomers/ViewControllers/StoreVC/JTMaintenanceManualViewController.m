//
//  JTMaintenanceManualViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMaintenanceManualViewController.h"
#import "JTMaintenanceManualHeaderView.h"
#import "ZTSegmentedControl.h"
#import "JTMaintenancePlanView.h"
#import "JTConfigurationParameterView.h"
#import "JTGradientButton.h"

@interface JTMaintenanceManualViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) JTMaintenanceManualHeaderView *headerView;
@property (nonatomic, strong) ZTSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JTMaintenancePlanView *maintenancePlanView;
@property (nonatomic, strong) JTConfigurationParameterView *configurationParameterView;
@property (nonatomic, strong) UILabel *promptLB;
@property (nonatomic, strong) JTGradientButton *nextBT;

@property (nonatomic, strong) NSMutableArray *maintenance_list;
@property (nonatomic, strong) NSMutableArray *params_list;
@end

@implementation JTMaintenanceManualViewController

- (instancetype)initWithModel:(JTCarModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:BlackLeverColor1];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.maintenancePlanView];
    [self.scrollView addSubview:self.configurationParameterView];
    [self.view addSubview:self.promptLB];
    [self.view addSubview:self.nextBT];
    
    self.navigationItem.title = @"保养手册";
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(maintenanceManualApi) parameters:@{@"car_id": self.model.carID} success:^(id responseObject, ResponseState state) {
        
        if ([responseObject objectForKey:@"maintenance_list"] && [responseObject[@"maintenance_list"] isKindOfClass:[NSArray class]]) {
            [weakself.maintenance_list addObjectsFromArray:responseObject[@"maintenance_list"]];
        }
        if ([responseObject objectForKey:@"params_list"] && [responseObject[@"params_list"] isKindOfClass:[NSArray class]]) {
            [weakself.params_list addObjectsFromArray:responseObject[@"params_list"]];
        }
        [weakself.maintenancePlanView setDataArray:weakself.maintenance_list];
        [weakself.configurationParameterView setDataArray:weakself.params_list];
        
    } failure:^(NSError *error) {
    }];
}

- (void)nextClick:(id)sender
{
    
}

- (JTMaintenanceManualHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTMaintenanceManualHeaderView alloc] initWithModel:self.model];
    }
    return _headerView;
}

- (ZTSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[ZTSegmentedControl alloc] initWithSectionTitles:@[@"标准保养计划", @"原厂配置参数"]];
        _segmentedControl.frame = CGRectMake(0, self.headerView.bottom, App_Frame_Width, 44);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.titleTextAttributes = @{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                  NSForegroundColorAttributeName : BlackLeverColor3,
                                                  };
        _segmentedControl.selectedTitleTextAttributes = @{
                                                          NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                          NSForegroundColorAttributeName : BlackLeverColor6,
                                                          };
        _segmentedControl.selectionIndicatorColor = BlackLeverColor6;
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.backgroundColor = WhiteColor;
        _segmentedControl.showHorizonLine = YES;
        __weak typeof(self) weakself = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            [weakself.scrollView setContentOffset:CGPointMake(App_Frame_Width*index, 0) animated:YES];
        };
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.bottom+15, App_Frame_Width, self.promptLB.top-self.segmentedControl.bottom-15)];
        _scrollView.contentSize = CGSizeMake(App_Frame_Width*2, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = WhiteColor;
    }
    return _scrollView;
}

- (JTMaintenancePlanView *)maintenancePlanView
{
    if (!_maintenancePlanView) {
        _maintenancePlanView = [[JTMaintenancePlanView alloc] initWithFrame:CGRectMake(15, 0, App_Frame_Width-30, self.scrollView.height)];
    }
    return _maintenancePlanView;
}

- (JTConfigurationParameterView *)configurationParameterView
{
    if (!_configurationParameterView) {
        _configurationParameterView = [[JTConfigurationParameterView alloc] initWithFrame:CGRectMake(App_Frame_Width+15, 0, App_Frame_Width-30, self.scrollView.height)];
    }
    return _configurationParameterView;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] initWithFrame:CGRectMake(15, self.nextBT.top-30, App_Frame_Width-30, 30)];
        _promptLB.text = @"此数据仅供参考，请以原厂保养手册为准";
        _promptLB.textColor = BlackLeverColor3;
        _promptLB.font = Font(12);
    }
    return _promptLB;
}

- (JTGradientButton *)nextBT
{
    if (!_nextBT) {
        _nextBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
        _nextBT.cornerRadius = .0f;
        [_nextBT setTitle:@"立即智能保养" forState:UIControlStateNormal];
        [_nextBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_nextBT.titleLabel setFont:Font(18)];
        [_nextBT setFrame:CGRectMake(0, APP_Frame_Height-44, App_Frame_Width, 44)];
        [_nextBT addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)maintenance_list
{
    if (!_maintenance_list) {
        _maintenance_list = [NSMutableArray array];
    }
    return _maintenance_list;
}

- (NSMutableArray *)params_list
{
    if (!_params_list) {
        _params_list = [NSMutableArray array];
    }
    return _params_list;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.bounds.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = (NSInteger)(fabs(offsetX / width));
    self.segmentedControl.selectedSegmentIndex = page;
}

@end
