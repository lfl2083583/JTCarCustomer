//
//  JTRescueCancelViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTEvaluateTableViewCell.h"
#import "JTRescueEvaluateTableHeadView.h"
#import "JTRescueCancelViewController.h"

@interface JTRescueCancelViewController () <UITableViewDataSource, JTEvaluateTableViewCellDelegate>

@property (nonatomic, strong) JTRescueEvaluateTableHeadView *tableHeadView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UILabel *refundLB;
@property (nonatomic, strong) UILabel *discribLB;

@property (nonatomic, strong) NSArray *evalutes;

@end

@implementation JTRescueCancelViewController

- (void)bottomBtnClick:(UIButton *)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    [self.navigationItem setTitle:@"取消订单"];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:44];
    [self.tableview setDataSource:self];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setBackgroundColor:WhiteColor];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview registerClass:[JTEvaluateTableViewCell class] forCellReuseIdentifier:evaluateTableViewCellIdentifier];
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.refundLB];
    [self.view addSubview:self.discribLB];
    
}

- (void)setupComponent
{
    self.evalutes = @[@"位置填写错误", @"价格偏贵", @"临时加收费用", @"商家迟迟不接单",  @"拖车终点送错", @"其他"];
    [self.refundLB setText:@"退款金额  ￥55.32"];
    [Utility richTextLabel:self.refundLB fontNumber:Font(20) andRange:[@"退款金额  ￥55.32" rangeOfString:@"￥55.32"] andColor:RedLeverColor1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:evaluateTableViewCellIdentifier];
    cell.textView.placeholder = @"补充详细信息以便平台更快帮您处理(选填)";
    cell.evaluates = self.evalutes;
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JTEvaluateTableViewCell getViewHeightWithEvalutes:self.evalutes];
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

- (JTRescueEvaluateTableHeadView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[JTRescueEvaluateTableHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 70)];
        _tableHeadView.str1 = @"选择取消原因(至少选择一项)";
        _tableHeadView.leftBtn.hidden = YES;
        _tableHeadView.rightBtn.hidden = YES;
    }
    return _tableHeadView;
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

- (UILabel *)refundLB
{
    if (!_refundLB) {
        _refundLB = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(self.bottomBtn.frame)-50, App_Frame_Width-40, 20)];
        _refundLB.font = Font(14);
        _refundLB.textColor = BlackLeverColor5;
    }
    return _refundLB;
}

- (UILabel *)discribLB
{
    if (!_discribLB) {
        _discribLB = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.refundLB.frame)+5, App_Frame_Width-40, 20)];
        [_discribLB setFont:Font(14)];
        [_discribLB setTextColor:BlackLeverColor3];
        [_discribLB setText:@"金额退至原支付账户"];
    }
    return _discribLB;
}

@end
