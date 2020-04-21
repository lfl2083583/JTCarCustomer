//
//  JTAccountModifyPhoneViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTAccountSecurityViewController.h"
#import "JTAccountModifyPhoneViewController.h"

@interface JTAccountModifyPhoneViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (nonatomic, copy) NSString *replaceCode;

@end

@implementation JTAccountModifyPhoneViewController

- (instancetype)initWithRandCode:(NSString *)randCode newPhone:(NSString *)newPhone {
    self = [super init];
    if (self) {
        self.randCode = randCode;
        self.phone = newPhone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    // Do any additional setup after loading the view from its nib.
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
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SendSmsForNewApi) parameters:@{@"phone" : weakSelf.phone,@"rand_str_send_code" : self.randCode} success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            weakSelf.replaceCode = responseObject[@"rand_str_replace_phone"];
            [Utility startTime:sender];
            [weakSelf.codeTF becomeFirstResponder];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)completeBtnClick:(JTGradientButton *)sender {
    
    if (!self.codeTF.text.length) {
        [[HUDTool shareHUDTool] showHint:@"请输入验证码" yOffset:0];
        return;
    }
    if (!self.replaceCode) {
        [[HUDTool shareHUDTool] showHint:@"请获取验证码" yOffset:0];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ReplacePhoneApi) parameters:@{@"rand_str_replace_phone" : self.replaceCode,@"phone" : self.phone,@"code" : self.codeTF.text} success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        [JTUserInfo shareUserInfo].userPhone = weakSelf.phone;
        [[JTUserInfo shareUserInfo] save];
        UIViewController *vc;
        for (UIViewController *viewController in self.navigationController.childViewControllers) {
            if ([viewController isKindOfClass:[JTAccountSecurityViewController class]]) {
                vc = viewController;
                break;
            }
        }
        if (vc) {
            [weakSelf.navigationController popToViewController:vc animated:YES];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
