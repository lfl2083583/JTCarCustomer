//
//  JTLoginViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTLoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "JTRegisterEditAvatarViewController.h"
#import "JTRegisterEditSexViewController.h"
#import "JTBindingPhoneViewController.h"
#import "NSString+AES256.h"

@interface JTLoginViewController ()

@property (weak, nonatomic) IBOutlet JTGradientButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTF;

@end

@implementation JTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *agreementString = [[NSMutableAttributedString alloc] initWithString:@"登录即代表你同意 ，并同意《用户注册协议》"];
    [agreementString addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3  range:NSMakeRange(0, 13)];
    [self.agreementBtn setAttributedTitle:agreementString forState:UIControlStateNormal];
    [self.phoneNumTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventAllEditingEvents];
    [self.phoneCodeTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventAllEditingEvents];
}

/**
 获取验证码

 @param sender 获取验证码按钮
 */
- (IBAction)obtainCodeClick:(UIButton *)sender {
    if (self.phoneNumTF.text.length < 11) {
        self.phoneNumTF.text = @"";
        [[HUDTool shareHUDTool] showHint:@"手机格式输入错误，请重新输入" yOffset:0];
        return;
    }
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SendSmsApi) parameters:@{@"phone" : self.phoneNumTF.text} success:^(id responseObject, ResponseState state) {
        [Utility startTime:sender];
        [weakSelf.phoneCodeTF becomeFirstResponder];
    } failure:^(NSError *error) {
        
    }];
}

/**
 用户注册协议

 @param sender 用户注册协议按钮
 */
- (IBAction)rgisterAgreementClick:(UIButton *)sender {
    
}

/**
 用户登录/注册

 @param sender 用户登录/注册按钮
 */
- (IBAction)loginClick:(UIButton *)sender {
    if (!self.phoneNumTF.text.length) {
        [[HUDTool shareHUDTool] showHint:@"请输入手机号码" yOffset:0];
        return;
    }
    if (!self.phoneCodeTF.text.length) {
        [[HUDTool shareHUDTool] showHint:@"请输入短信验证码" yOffset:0];
        return;
    }
    [self.view endEditing:YES];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(PhoneLoginApi) parameters:@{@"phone" : self.phoneNumTF.text, @"code" : self.phoneCodeTF.text} success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            JTUserInfo *userInfo = [JTUserInfo mj_objectWithKeyValues:responseObject];
            userInfo.userToken = [userInfo.userToken aes256_decrypt:JTHttpAppKey];
            [weakself chooseNextResponderViewController];
        }
    } failure:^(NSError *error) {
    }];
}


/**
 第三方登录

 @param sender 第三方登录按钮
 */
- (IBAction)thirdPartyLoginClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case JTLoginTypeWeChat:
        {
            [self thirdLoginMethod:UMSocialPlatformType_WechatSession loginType:JTLoginTypeWeChat];
        }
            break;
        case JTLoginTypeQQ:
        {
           [self thirdLoginMethod:UMSocialPlatformType_QQ loginType:JTLoginTypeQQ];
        }
            break;
        default:
            break;
    }
}

/**
 退出登录界面

 @param sender 关闭按钮
 */
- (IBAction)rightCloseClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseNextResponderViewController {
    JTUserInfo *userInfo = [JTUserInfo shareUserInfo];
    if ([userInfo.userAvatar isBlankString] || [userInfo.userName isBlankString]) {
        [self.navigationController pushViewController:[[JTRegisterEditAvatarViewController alloc] init] animated:YES];
    } else {
        [self socialLoginSeccess:userInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - Method
- (void)thirdLoginMethod:(UMSocialPlatformType)type loginType:(JTLoginType)loginType {
   
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        if (!resp) {
            [[HUDTool shareHUDTool] showHint:@"登录失败" yOffset:0];
        } else {
            [[HUDTool shareHUDTool] showHint:@"登录中" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
            __weak typeof(self) weakself = self;
            ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:nil atCacheEnabled:NO];
            configParam.isEncrypt = YES;
            configParam.isNeedUserTokenAndUserID = YES;
            [[HttpRequestTool sharedInstance] startRequestURLString:kBase_url(ThirdLoginApi) parameters:@{@"access_token" : resp.accessToken, @"openid" : resp.openid, @"logintype" : @(loginType)} httpType:HttpRequestTypePost configParam:configParam success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] hideHUD];
                //判断是否已绑定手机号码
                NSString *bindID = responseObject[@"bind_id"];
                if (bindID && [bindID isKindOfClass:[NSString class]]) {
                    [weakself.navigationController pushViewController:[[JTBindingPhoneViewController alloc] initWithBindID:bindID] animated:YES];
                } else {
                    JTUserInfo *userInfo = [JTUserInfo mj_objectWithKeyValues:responseObject];
                    userInfo.userToken = [userInfo.userToken aes256_decrypt:JTHttpAppKey];
                    [weakself chooseNextResponderViewController];
                }
                
            } failure:^(NSError *error) {
                [[HUDTool shareHUDTool] hideHUD];
            }];
        }
    }];
}

- (void)textFieldContentChange:(UITextField *)sender {
    if (self.phoneNumTF.text.length >= 11 && self.phoneCodeTF.text.length == 6) {
        self.loginBtn.alpha = 1;
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.alpha = 0.6;
        self.loginBtn.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
