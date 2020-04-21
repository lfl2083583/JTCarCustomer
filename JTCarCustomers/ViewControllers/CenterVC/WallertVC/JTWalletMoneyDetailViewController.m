//
//  JTWalletMoneyDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMoneyDetailViewController.h"
#import "JTWalletMoneyDetailViewController.h"
#import "JTWalletMoneyDetailTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "JTWalletMoneyDetailPickerView.h"

@implementation JTWalletMoneyDetailTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLB];
        self.backgroundColor = WhiteColor;
    }
    return self;;
}

- (UILabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.width - 30, 40)];
        _leftLB.font = Font(24);
        _leftLB.text = @"零钱明细";
    }
    return _leftLB;
}

@end


@interface JTWalletMoneyDetailViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTWalletMoneyDetailTableHeadView *tableHeadView;
@property (nonatomic, strong) JTWalletMoneyDetailPickerView *pickerView;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, copy) NSString *payType;

@end

@implementation JTWalletMoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableHeadView];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight+self.tableHeadView.height, App_Frame_Width, APP_Frame_Height-self.tableHeadView.height-kStatusBarHeight-kTopBarHeight) rowHeight:60 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview registerClass:[JTWalletMoneyDetailTableViewCell class] forCellReuseIdentifier:walletDeatailCellIndentify];
    [self.tableview setDataSource:self];
    [self setShowTableRefreshHeader:YES];
    [self setShowTableRefreshFooter:YES];
    [self.view addSubview:self.tipLB];
    self.payType = @"0";
    [self staticRefreshFirstTableListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClick{
    __weak typeof (self)weakSelf = self;
    [self.pickerView showWithItemArray:self.itemArray seletedBlock:^(JTWalletMoneyDetailType type) {
        weakSelf.payType = [NSString stringWithFormat:@"%ld",type];
        [weakSelf.tableview.mj_header beginRefreshing];
    }];
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetAccLogApi) parameters:@{@"type" : self.payType, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        if (responseObject[@"type"] && [responseObject[@"type"] isKindOfClass:[NSArray class]]) {
            weakSelf.itemArray = responseObject[@"type"];
        }
        weakSelf.navigationItem.rightBarButtonItem = weakSelf.itemArray.count?weakSelf.rightBarItem:nil;
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWalletMoneyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:walletDeatailCellIndentify];
    [cell configWalletMoneyDetailTableViewCellWithInfo:self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:walletDeatailCellIndentify cacheByIndexPath:indexPath configuration:^(JTWalletMoneyDetailTableViewCell *cell) {
        [cell configWalletMoneyDetailTableViewCellWithInfo:weakSelf.dataArray[indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[JTMoneyDetailViewController alloc] initWithSource:self.dataArray[indexPath.row]] animated:YES];
}

- (JTWalletMoneyDetailTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTWalletMoneyDetailTableHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 40)];
    }
    return _tableHeadView;
}

- (UIBarButtonItem *)rightBarItem {
    if (!_rightBarItem) {
        _rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    }
    return _rightBarItem;
}

- (JTWalletMoneyDetailPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[JTWalletMoneyDetailPickerView alloc] initWithFrame:self.view.bounds];
    }
    return _pickerView;
}


- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"暂时没有零钱明细数据~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end

