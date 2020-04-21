//
//  JTAccountSecurityViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import <UMSocialCore/UMSocialCore.h>
#import "JTWordItem.h"
#import "JTAccountSecurityViewController.h"
#import "JTAccountAboutPhoneViewController.h"

@interface JTAccountSecurityViewController () <UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;

@end

@implementation JTAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), App_Frame_Width, APP_Frame_Height-CGRectGetMaxY(self.headView.frame)) rowHeight:44 sectionHeaderHeight:0 sectionFooterHeight:0];
    self.tableview.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self setupComponent];
    [self.tableview reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)setupComponent {
    JTWordItem *item1 = [self creatItemWithTitle:@"溜车号" subtitle:[JTUserInfo shareUserInfo].userNumberCode];
    NSString *phoneStr = [JTUserInfo shareUserInfo].userPhone;
    NSString *userPhone = [NSString stringWithFormat:@"%@****%@",[phoneStr substringToIndex:3],[phoneStr substringWithRange:NSMakeRange(phoneStr.length-4, 4)]];
    JTWordItem *item2 = [self creatItemWithTitle:@"手机号码" subtitle:userPhone];
    JTWordItem *item3 = [self creatItemWithTitle:@"QQ登录" subtitle:[JTUserInfo shareUserInfo].isBindQQ?@"已绑定": @"未绑定"];
    JTWordItem *item4 = [self creatItemWithTitle:@"微信登录" subtitle:[JTUserInfo shareUserInfo].isBindWeiChat?@"已绑定": @"未绑定"];
    JTWordItem *item5 = [self creatItemWithTitle:@"修改手机号码" subtitle:@""];
    self.dataArray = [NSMutableArray arrayWithArray:@[item1, item2, item3, item4, item5]];
}

- (JTWordItem *)creatItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    JTWordItem *item  = [[JTWordItem alloc] init];
    item.title = title;
    item.subTitle = subtitle;
    return item;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *normalIndentfy = @"UITableViewCell";
    JTWordItem *item = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIndentfy];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalIndentfy];
        cell.textLabel.textColor = BlackLeverColor6;
        cell.detailTextLabel.textColor = BlackLeverColor3;
        cell.textLabel.font = Font(16);
        cell.detailTextLabel.font = Font(14);
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    cell.accessoryType = ([item.title isEqualToString:@"修改手机号码"])?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.row];
    if ([item.title isEqualToString:@"修改手机号码"])
    {
        [self.navigationController pushViewController:[[JTAccountAboutPhoneViewController alloc] init] animated:YES];
    }
    else if ([item.title isEqualToString:@"微信登录"] && ![JTUserInfo shareUserInfo].isBindWeiChat)
    {
        [self thirdBindMethod:UMSocialPlatformType_WechatSession loginType:JTLoginTypeWeChat];
    }
    else if ([item.title isEqualToString:@"QQ登录"] && ![JTUserInfo shareUserInfo].isBindQQ)
    {
        [self thirdBindMethod:UMSocialPlatformType_QQ loginType:JTLoginTypeQQ];
    }
}

#pragma mark - Method
- (void)thirdBindMethod:(UMSocialPlatformType)type loginType:(JTLoginType)loginType {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        if (!resp) {
            [[HUDTool shareHUDTool] showHint:@"绑定失败" yOffset:0];
        } else {
            [[HUDTool shareHUDTool] showHint:@"绑定中" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
            __weak typeof(self) weakself = self;
            ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:nil atCacheEnabled:NO];
            configParam.isEncrypt = YES;
            configParam.isNeedUserTokenAndUserID = YES;
            [[HttpRequestTool sharedInstance] startRequestURLString:kBase_url(BindUserApi) parameters:@{@"access_token" : resp.accessToken, @"openid" : resp.openid, @"logintype" : @(loginType)} httpType:HttpRequestTypePost configParam:configParam success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"绑定成功" yOffset:0];
                if (loginType == JTLoginTypeQQ) {
                    [JTUserInfo shareUserInfo].isBindQQ = YES;
                } else {
                    [JTUserInfo shareUserInfo].isBindWeiChat = YES;
                }
                [[JTUserInfo shareUserInfo] save];
                [weakself setupComponent];
                [weakself.tableview reloadData];
               
            } failure:^(NSError *error) {
                [[HUDTool shareHUDTool] hideHUD];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 40)];
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, App_Frame_Width-15, 40)];
        titleLB.font = Font(24);
        titleLB.text = @"账号与安全";
        [_headView addSubview:titleLB];
    }
    return _headView;
}

@end
