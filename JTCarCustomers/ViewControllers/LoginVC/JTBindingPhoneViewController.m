//
//  JTBindingPhoneViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTBindingPhoneViewController.h"
#import "JTBindingAndLoginViewController.h"

@interface JTBindingPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet JTGradientButton *nextBtn;

@end

@implementation JTBindingPhoneViewController

- (instancetype)initWithBindID:(NSString *)bindID {
    self = [super init];
    if (self) {
        self.bindID = bindID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kIsIphonex?48+22:48;
    [self.phoneNumTF becomeFirstResponder];
    [self.phoneNumTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventAllEditingEvents];
}


/**
 关闭

 @param sender UIButton
 */
- (IBAction)rightBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 绑定手机号下一步

 @param sender 下一步按钮
 */
- (IBAction)bindingPhoneNextStep:(UIButton *)sender {
    if (self.phoneNumTF.text.length < 11) {
        [[HUDTool shareHUDTool] showHint:@"手机格式输入错误，请重新输入" yOffset:0];
    } else {
        __weak typeof(self)weakSelf = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(CheckOauthPhoneApi) parameters:@{@"phone" : self.phoneNumTF.text} success:^(id responseObject, ResponseState state) {
            [weakSelf.navigationController pushViewController:[[JTBindingAndLoginViewController alloc] initWithBundingPhoneNum:weakSelf.phoneNumTF.text bindID:self.bindID] animated:YES];
        } failure:^(NSError *error) {
            
        }];
        
    }
}

- (void)textFieldContentChange:(UITextField *)sender {
    if (self.phoneNumTF.text.length >= 11) {
        self.nextBtn.alpha = 1;
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.alpha = 0.6;
        self.nextBtn.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
