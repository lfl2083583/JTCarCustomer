//
//  JTJoinTeamViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamInfoHandle.h"
#import "JTJoinTeamViewController.h"
#import "GCPlaceholderTextView.h"
#import "JTSessionViewController.h"

@interface JTJoinTeamViewController ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *describeLB;
@property (nonatomic, strong) GCPlaceholderTextView *textView;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation JTJoinTeamViewController

- (instancetype)initWithTeam:(NIMTeam *)team teamSource:(JTTeamSource)teamSource inviteID:(NSString *)inviteID {
    self = [super init];
    if (self) {
        self.team = team;
        self.inviteID = inviteID;
        self.teamSource = teamSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLB];
    [self.view addSubview:self.describeLB];
    [self.view addSubview:self.textView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
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

- (void)rightBtnClick:(id)sender {
    if (self.textView.text.length > 20) {
        [[HUDTool shareHUDTool] showHint:@"个人介绍为0~20字符" yOffset:0];
        return;
    }
    NSMutableDictionary *progrem = [NSMutableDictionary dictionary];
    [progrem setValue:self.team.teamId forKey:@"group_id"];
    [progrem setValue:self.textView.text forKey:@"introduce"];
    [progrem setValue:@(self.teamSource) forKey:@"join_type"];
    if (self.inviteID && [self.inviteID isKindOfClass:[NSString class]]) {
        [progrem setValue:self.inviteID forKey:@"invite"];
    }
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(NormalJoinTeamApi) parameters:progrem success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            BOOL isJoin = [responseObject[@"is_member"] boolValue];
            if (isJoin) {
                NIMSession *session = [NIMSession session:weakSelf.team.teamId type:NIMSessionTypeTeam];
                JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
                if (weakSelf.tabBarController.selectedIndex == 0) {
                    sessionVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:sessionVC animated:YES];
                    UIViewController *root = weakSelf.navigationController.viewControllers[0];
                    weakSelf.navigationController.viewControllers = @[root, sessionVC];
                }
                else
                {
                    [weakSelf.tabBarController setSelectedIndex:0];
                    [[weakSelf.tabBarController.selectedViewController topViewController] setHidesBottomBarWhenPushed:YES];
                    [sessionVC setHidesBottomBarWhenPushed:YES];
                    [weakSelf.tabBarController.selectedViewController pushViewController:sessionVC animated:YES];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            else {
                [[HUDTool shareHUDTool] showHint:@"已发送申请！" yOffset:0];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(22, kStatusBarHeight+kTopBarHeight, App_Frame_Width-44, 40)];
        _titleLB.font = Font(24);
        _titleLB.text = @"申请加群";
    }
    return _titleLB;
}

- (UILabel *)describeLB {
    if (!_describeLB) {
        _describeLB = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.titleLB.frame)+22, App_Frame_Width-44, 22)];
        _describeLB.font = Font(16);
        _describeLB.textColor = BlackLeverColor3;
        _describeLB.text = @"个人介绍0~20字符";
    }
    return _describeLB;
}

- (GCPlaceholderTextView *)textView {
    if (!_textView) {
        _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.describeLB.frame)+22, App_Frame_Width-44, 80)];
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderWidth = 1;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = BlackLeverColor2.CGColor;
        _textView.placeholder = @"请输入个人介绍";
    }
    return _textView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _rightBtn.titleLabel.font = Font(16);
        [_rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
