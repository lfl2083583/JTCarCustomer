//
//  JTBindingAndLoginViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "NSString+AES256.h"
#import "JTGradientButton.h"
#import "JTBindingAndLoginViewController.h"
#import "JTRegisterEditAvatarViewController.h"

@interface JTBindingAndLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTF;
@property (weak, nonatomic) IBOutlet JTGradientButton *bindBtn;


@end

@implementation JTBindingAndLoginViewController

- (instancetype)initWithBundingPhoneNum:(NSString *)phoneNum bindID:(NSString *)bindID{
    if (self = [super init]) {
        self.phoneNum = phoneNum;
        self.bindID = bindID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumTF.text = self.phoneNum;
    self.topConstraint.constant = kIsIphonex?48+22:48;
    [self.phoneCodeTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 关闭

 @param sender UIButton
 */
- (IBAction)rightBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 获取验证码
 
 @param sender UIButton
 */
- (IBAction)obtainCodeClick:(UIButton *)sender {
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SendSmsApi) parameters:@{@"phone" : self.phoneNum} success:^(id responseObject, ResponseState state) {
        [Utility startTime:sender];
        [weakSelf.phoneCodeTF becomeFirstResponder];
    } failure:^(NSError *error) {
        
    }];
}

/**
 绑定手机号并登录

 @param sender UIButton
 */
- (IBAction)loginClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:nil atCacheEnabled:NO];
    configParam.isEncrypt = YES;
    configParam.isNeedUserTokenAndUserID = YES;
    [[HttpRequestTool sharedInstance] startRequestURLString:kBase_url(BindingPhoneApi) parameters:@{@"phone" : self.phoneNum, @"code" : self.phoneCodeTF.text, @"bind_id" : self.bindID} httpType:HttpRequestTypePost configParam:configParam success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        JTUserInfo *userInfo = [JTUserInfo mj_objectWithKeyValues:responseObject];
        userInfo.userToken = [userInfo.userToken aes256_decrypt:JTHttpAppKey];
        if (([JTUserInfo shareUserInfo].userName && [[JTUserInfo shareUserInfo].userName isKindOfClass:[NSString class]] && [JTUserInfo shareUserInfo].userName.length) || [JTUserInfo shareUserInfo].userGenter) {
            [weakSelf socialLoginSeccess:[JTUserInfo shareUserInfo]];
            UIViewController *root = self.navigationController.viewControllers[0];
            weakSelf.navigationController.viewControllers = @[root];
            [root dismissViewControllerAnimated:YES completion:nil];
        }else{
            [weakSelf.navigationController pushViewController:[[JTRegisterEditAvatarViewController alloc] initWithAvatarUrl:[JTUserInfo shareUserInfo].userAvatar nikeName:[JTUserInfo shareUserInfo].userName] animated:YES];
        }
    } failure:^(NSError *error) {
        [[HUDTool shareHUDTool] hideHUD];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textFieldContentChange:(UITextField *)sender {
    if (self.phoneCodeTF.text.length == 6) {
        self.bindBtn.alpha = 1;
        self.bindBtn.enabled = YES;
    } else {
        self.bindBtn.alpha = 0.6;
        self.bindBtn.enabled = NO;
    }
}

@end
