//
//  JTSettingViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTPersonalViewController.h"
#import "JTSettingViewController.h"
#import "JTAboutViewController.h"
#import "JTFeedBackViewController.h"
#import "JTBlackListViewController.h"
#import "JTAccountSecurityViewController.h"
#import "JTMessageNoticeSetViewController.h"
#import "JTPayPasswordSetViewController.h"

@implementation JTSettingHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLB];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (UILabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width-15, 40)];
        _leftLB.font = Font(24);
        _leftLB.text = @"设置";
    }
    return _leftLB;
}
@end

#import "JTWordItem.h"
@interface JTSettingViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTSettingHeadView *headView;

@end

@implementation JTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self setupComponent];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), App_Frame_Width, APP_Frame_Height-CGRectGetMaxY(self.headView.frame)) rowHeight:44 sectionHeaderHeight:0 sectionFooterHeight:5];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    JTWordItem *item1 = [self creatItemWithTitle:@"账号与安全" titleColor:BlackLeverColor6];
    JTWordItem *item2 = [self creatItemWithTitle:@"设置支付密码" titleColor:BlackLeverColor6];
    JTWordItem *item3 = [self creatItemWithTitle:@"身份认证中心" titleColor:BlackLeverColor6];
    JTWordItem *item4 = [self creatItemWithTitle:@"消息通知" titleColor:BlackLeverColor6];
    JTWordItem *item5 = [self creatItemWithTitle:@"黑名单" titleColor:BlackLeverColor6];
    JTWordItem *item6 = [self creatItemWithTitle:@"意见反馈" titleColor:BlackLeverColor6];
    JTWordItem *item7 = [self creatItemWithTitle:@"清空全部缓存" titleColor:BlackLeverColor6];
    JTWordItem *item8 = [self creatItemWithTitle:@"关于我们" titleColor:BlackLeverColor6];
    JTWordItem *item9 = [self creatItemWithTitle:@"退出当前账号" titleColor:BlueLeverColor1];
    self.dataArray = [NSMutableArray arrayWithArray:@[@[item1, item2, item3],@[item4, item5],@[item6, item7, item8], @[item9]]];
}

- (JTWordItem *)creatItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    JTWordItem *item  = [[JTWordItem alloc] init];
    item.title = title;
    item.titleColor = titleColor;
    return item;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *normalIndentfy = @"UITableViewCell";
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIndentfy];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIndentfy];
        cell.textLabel.textColor = BlackLeverColor6;
        cell.textLabel.font = Font(16);
        UIView *horizonView = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, App_Frame_Width-15, 0.5)];
        horizonView.backgroundColor = BlackLeverColor2;
        [cell.contentView addSubview:horizonView];
    }
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = item.titleColor;
    cell.accessoryType = ([item.title isEqualToString:@"退出当前账号"])?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    if ([item.title isEqualToString:@"账号与安全"])
    {
        [self.navigationController pushViewController:[[JTAccountSecurityViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"设置支付密码"])
    {
       [self.navigationController pushViewController:[[JTPayPasswordSetViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"身份认证中心"])
    {
        [self.navigationController pushViewController:[[JTPersonalViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"消息通知"])
    {
        [self.navigationController pushViewController:[[JTMessageNoticeSetViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"黑名单"])
    {
        [self.navigationController pushViewController:[[JTBlackListViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"意见反馈"])
    {
        [self.navigationController pushViewController:[[JTFeedBackViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"清空全部缓存"])
    {
        
    }
    else if ([item.title isEqualToString:@"关于我们"])
    {
        [self.navigationController pushViewController:[[JTAboutViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"退出当前账号"])
    {
        __weak typeof (self)weakSelf = self;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退出不会删除任何历史记录，下次登录依然可以使用此账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
             {
                 NSString *JTIMNotificationLogout = @"JTIMNotificationLogout";
                 [[NSNotificationCenter defaultCenter] postNotificationName:JTIMNotificationLogout object:nil];
                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             }];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JTSettingHeadView *)headView {
    if (!_headView) {
        _headView = [[JTSettingHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 40)];
    }
    return _headView;
}

@end
