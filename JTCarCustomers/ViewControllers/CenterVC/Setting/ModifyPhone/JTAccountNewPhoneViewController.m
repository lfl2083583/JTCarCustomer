//
//  JTAccountNewPhoneViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTAccountNewPhoneViewController.h"
#import "JTAccountModifyPhoneViewController.h"

@interface JTAccountNewPhoneViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation JTAccountNewPhoneViewController

- (instancetype)initWithRandCode:(NSString *)randCode {
    self = [super init];
    if (self) {
        self.randCode = randCode;
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

- (IBAction)nextBtnClick:(JTGradientButton *)sender {
    if (self.phoneTF.text.length != 11) {
        [[HUDTool shareHUDTool] showHint:@"请输入正确的手机号码" yOffset:0];
    }
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(CheckPhoneForNewApi) parameters:@{@"rand_str_check_phone" : self.randCode, @"phone" : self.phoneTF.text} success:^(id responseObject, ResponseState state) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf.navigationController pushViewController:[[JTAccountModifyPhoneViewController alloc] initWithRandCode:responseObject[@"rand_str_send_code"] newPhone:weakSelf.phoneTF.text] animated:YES];
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
