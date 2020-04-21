//
//  JTWalletViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTWordItem.h"
#import "JTWalletMoneyDetailViewController.h"
#import "JTWalletViewController.h"
#import "JTTradeWebViewController.h"
#import "JTBonusContainerViewController.h"

@implementation JTWalletHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLB];
        [self addSubview:self.bottomImgV];
        [self addSubview:self.bottomLB];
        [self addSubview:self.rightLB];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (UILabel *)topLB {
    if (!_topLB) {
        _topLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, self.bounds.size.width-15, 40)];
        _topLB.font = Font(24);
        _topLB.text = @"我的钱包";
    }
    return _topLB;
}

- (UIImageView *)bottomImgV {
    if (!_bottomImgV) {
        _bottomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.topLB.frame)+22, self.bounds.size.width-30, 162)];
        _bottomImgV.image = [UIImage imageNamed:@"center_payfor"];
    }
    return _bottomImgV;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMinY(self.bottomImgV.frame)+25, self.bounds.size.width-60, 54)];
        _bottomLB.font = Font(24);
        _bottomLB.textColor = BlackLeverColor6;
    }
    return _bottomLB;
}

- (UILabel *)rightLB {
    if (!_rightLB) {
        _rightLB = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.bottomLB.frame)+10, 70, 30)];
        _rightLB.backgroundColor = WhiteColor;
        _rightLB.textColor = BlackLeverColor6;
        _rightLB.font = Font(14);
        _rightLB.textAlignment = NSTextAlignmentCenter;
        _rightLB.layer.cornerRadius = 15;
        _rightLB.layer.masksToBounds = YES;
        _rightLB.text = @"立即充值";
    }
    return _rightLB;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(walletRecharge)]) {
        [_delegate walletRecharge];
    }
}

@end


@interface JTWalletViewController () <UITableViewDataSource, JTWalletHeadViewDelegate>

@property (nonatomic, strong) JTWalletHeadView *headView;

@end

@implementation JTWalletViewController

- (void)rightBarButtonItemClick:(id)sender {
    [self.navigationController pushViewController:[[JTWalletMoneyDetailViewController alloc] init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    self.view.backgroundColor = WhiteColor;
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:60];
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = self.headView;
    NSString *userBlance = [NSString stringWithFormat:@"%.2f",[JTUserInfo shareUserInfo].userBalance];
    self.headView.bottomLB.text = [NSString stringWithFormat:@"金额%@溜车币",userBlance];
    [Utility richTextLabel:self.headView.bottomLB fontNumber:[UIFont fontWithName:@"Avenir Next Condensed Medium" size:36] andRange:NSMakeRange(2, userBlance.length) andColor:BlackLeverColor6];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"零钱明细" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)setupComponent {
    JTWordItem *item1 = [self creatItem:@"红包" subtitle:@""];
    JTWordItem *item2 = [self creatItem:@"会员卡" subtitle:@""];
    JTWordItem *item3 = [self creatItem:@"优惠券" subtitle:@""];
    self.dataArray = [NSMutableArray arrayWithArray:@[item1, item2, item3]];
    
}

- (JTWordItem *)creatItem:(NSString *)title subtitle:(NSString *)subtitle {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.subTitle = subtitle;
    return item;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.row];
    static NSString *normalIndenify = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIndenify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalIndenify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = Font(16);
        cell.textLabel.textColor = BlackLeverColor6;
        cell.detailTextLabel.font = Font(15);
        cell.detailTextLabel.textColor = BlackLeverColor3;
    }
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTWordItem *item = self.dataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([item.title isEqualToString:@"红包"]) {
        [self.navigationController pushViewController:[[JTBonusContainerViewController alloc] init] animated:YES];
    }

}

#pragma mark JTWalletHeadViewDelegate
- (void)walletRecharge {
    [self.navigationController pushViewController:[[JTTradeWebViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JTWalletHeadView *)headView {
    if (!_headView) {
        _headView  = [[JTWalletHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 240)];
        _headView.delegate = self;
    }
    return _headView;
}

@end
