//
//  JTRescueEvaluateViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTRescueEvaluateTableFootView.h"
#import "JTRescueEvaluateTableHeadView.h"
#import "JTEvaluateTableViewCell.h"
#import "JTRescueEvaluateViewController.h"

@interface JTRescueEvaluateViewController () <UITableViewDataSource, JTEvaluateTableViewCellDelegate, JTRescueEvaluateTableHeadViewDelegate>

@property (nonatomic, strong) JTRescueEvaluateTableHeadView *tableHeadView;
@property (nonatomic, strong) JTRescueEvaluateTableFootView *tableFootView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) NSArray *evalutes;
@property (nonatomic, assign) CGFloat rowHight;

@end

@implementation JTRescueEvaluateViewController

- (void)bottomBtnClick:(UIButton *)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"评价"];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:44];
    [self.tableview setDataSource:self];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setBackgroundColor:WhiteColor];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview setTableFooterView:self.tableFootView];
    [self.tableview registerClass:[JTEvaluateTableViewCell class] forCellReuseIdentifier:evaluateTableViewCellIdentifier];
    [self.view addSubview:self.bottomBtn];
    [self setupComponent];
    
}

- (void)setupComponent
{
    self.evalutes = @[@"快速准时", @"风雨无阻", @"礼貌热情", @"仪表整洁", @"服务专业", @"位置填写错误"];
    self.rowHight = [JTEvaluateTableViewCell getViewHeightWithEvalutes:self.evalutes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:evaluateTableViewCellIdentifier];
    cell.evaluates = self.evalutes;
    cell.delegate = self;
    [cell.seletedArray removeAllObjects];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHight;
}

#pragma mark JTEvaluateTableViewCellDelegate
- (void)evalutesChanged:(NSArray *)evaluates
{
    NSLog(@"%@",evaluates);
}

- (void)textInputChanged:(NSString *)content
{
   NSLog(@"%@",content);
}

#pragma mark JTRescueEvaluateTableHeadViewDelegate
- (void)evaluateBtnClick:(NSInteger)flag
{
    self.evalutes = flag?@[@"路线不熟", @"态度差", @"未到指定地点", @"沟通困难", @"服务不专业", @"骚扰威胁", @"临时加收费用", @"拖车终点送错", @"其他"]:
                         @[@"快速准时", @"风雨无阻", @"礼貌热情", @"仪表整洁", @"服务专业", @"位置填写错误"];
    self.rowHight = [JTEvaluateTableViewCell getViewHeightWithEvalutes:self.evalutes];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JTRescueEvaluateTableHeadView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[JTRescueEvaluateTableHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 130)];
        _tableHeadView.delegate = self;
    }
    return _tableHeadView;
}

- (JTRescueEvaluateTableFootView *)tableFootView {
    if (!_tableFootView) {
        _tableFootView = [[JTRescueEvaluateTableFootView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 90)];
    }
    return _tableFootView;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.frame = CGRectMake(0, APP_Frame_Height-45, App_Frame_Width, 45);
        _bottomBtn.backgroundColor = BlueLeverColor1;
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
