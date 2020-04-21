//
//  JTPayPasswordSetViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTPayPasswordResetViewController.h"
#import "JTPayPasswordSetViewController.h"

@interface JTPayPasswordSetViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *orginalPswView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswViewHightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *orginalPswTF;
@property (weak, nonatomic) IBOutlet UITextField *anewPswTF;
@property (weak, nonatomic) IBOutlet UITextField *comfirmPswTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (copy, nonatomic) NSString *requestUrl;

@end

@implementation JTPayPasswordSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    if ([JTUserInfo shareUserInfo].isUserPaymentPassword) {
        self.titleLB.text = @"设置支付密码";
        self.requestUrl = EditePayPswApi;
    } else {
        self.titleLB.text = @"首次设置支付密码";
        self.orginalPswView.hidden = YES;
        self.pswViewHightConstraint.constant = 0;
        self.requestUrl = SetPayPswApi;
    }
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

- (IBAction)lostBtnClick:(UIButton *)sender {
    [self.navigationController pushViewController:[[JTPayPasswordResetViewController alloc] init] animated:YES];
}

- (IBAction)comfirmBtnClick:(JTGradientButton *)sender {
    
    if ([JTUserInfo shareUserInfo].isUserPaymentPassword && self.orginalPswTF.text.length != 6) {
        [[HUDTool shareHUDTool] showHint:@"请输入6位旧支付密码" yOffset:0];
        return;
    }
    if (self.anewPswTF.text.length != 6 || self.comfirmPswTF.text.length != 6) {
        [[HUDTool shareHUDTool] showHint:@"请输入6位新支付密码" yOffset:0];
        return;
    }
    if (![self.anewPswTF.text isEqualToString:self.comfirmPswTF.text]) {
        [[HUDTool shareHUDTool] showHint:@"两次输入密码不一致，请重新输入" yOffset:0];
        return;
    }
    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
    [progem setValue:self.comfirmPswTF.text forKey:@"new_password"];
    if ([JTUserInfo shareUserInfo].isUserPaymentPassword) {
        [progem setValue:self.orginalPswTF.text forKey:@"old_password"];
    }
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(self.requestUrl) parameters:progem success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"设置成功" yOffset:0];
        [JTUserInfo shareUserInfo].isUserPaymentPassword = YES;
        [[JTUserInfo shareUserInfo] save];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
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
