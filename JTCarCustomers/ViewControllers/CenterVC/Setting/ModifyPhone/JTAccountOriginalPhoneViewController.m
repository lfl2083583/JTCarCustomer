//
//  JTAccountOriginalPhoneViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTAccountOriginalPhoneViewController.h"
#import "JTAccountNewPhoneViewController.h"

@interface JTAccountOriginalPhoneViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (nonatomic, copy) NSString *randCode;

@end

@implementation JTAccountOriginalPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    self.phoneLB.text = [JTUserInfo shareUserInfo].userPhone;
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

- (IBAction)getCodeBtnClick:(UIButton *)sender {
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SendSmsForOriginalApi) parameters:@{@"phone" : [JTUserInfo shareUserInfo].userPhone} success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            weakSelf.randCode = responseObject[@"rand_str_check_code"];
            [Utility startTime:sender];
            [weakSelf.codeTF becomeFirstResponder];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)nextBtnClick:(JTGradientButton *)sender {
    if (!self.randCode) {
        [[HUDTool shareHUDTool] showHint:@"请获取验证码" yOffset:0];
        return;
    }
    if (!self.codeTF.text.length) {
        [[HUDTool shareHUDTool] showHint:@"请输入验证码" yOffset:0];
        return;
    }
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(CheckCodeForOriginalApi) parameters:@{@"rand_str_check_code" : self.randCode,@"code" : self.codeTF.text} success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
           [weakSelf.navigationController pushViewController:[[JTAccountNewPhoneViewController alloc] initWithRandCode:responseObject[@"rand_str_check_phone"]] animated:YES];
        }
        
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
