//
//  JTPayPasswordResetViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTPayPasswordResetViewController.h"
#import "JTSettingViewController.h"

@interface JTPayPasswordResetViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *anewPswTF;
@property (weak, nonatomic) IBOutlet UITextField *comfirmPswTF;

@end

@implementation JTPayPasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    self.phoneLB.text = [JTUserInfo shareUserInfo].userPhone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (IBAction)getCodeBtnClick:(UIButton *)sender {
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetPayPswSendSmsApi) parameters:@{@"phone" : [JTUserInfo shareUserInfo].userPhone} success:^(id responseObject, ResponseState state) {
        [Utility startTime:sender];
        [weakSelf.codeTF becomeFirstResponder];
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)comfirmBtnClick:(JTGradientButton *)sender {
    if (self.codeTF.text.length != 6) {
        [[HUDTool shareHUDTool] showHint:@"请输入6位验证码" yOffset:0];
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
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ResetPayPswApi) parameters:@{@"code" : self.codeTF.text, @"new_password" : self.comfirmPswTF.text} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"设置成功" yOffset:0];
        UIViewController *VC;
        for (UIViewController *viewController in self.navigationController.childViewControllers) {
            if ([viewController isKindOfClass:[JTSettingViewController class]]) {
                VC = viewController;
                break;
            }
        }
        [weakSelf.navigationController popToViewController:VC animated:YES];
    } failure:^(NSError *error) {
        
    }];
}


@end
