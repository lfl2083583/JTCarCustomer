//
//  JTActivityParticipateEditeViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTTextField.h"
#import "JTActivityParticipateEditeViewController.h"

@interface JTActivityParticipateEditeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet ZTTextField *nikeNameTF;
@property (weak, nonatomic) IBOutlet ZTTextField *contractTF;

@end

@implementation JTActivityParticipateEditeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑";
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight+20;
    self.nikeNameTF.layer.cornerRadius = 4;
    self.nikeNameTF.layer.borderWidth = 1;
    self.nikeNameTF.layer.borderColor = BlackLeverColor2.CGColor;
    self.nikeNameTF.layer.masksToBounds = YES;
    self.contractTF.layer.cornerRadius = 4;
    self.contractTF.layer.borderWidth = 1;
    self.contractTF.layer.borderColor = BlackLeverColor2.CGColor;
    self.contractTF.layer.masksToBounds = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_black"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
}

- (void)rightBarButtonItemClick:(id)sender {
    if (self.nikeNameTF.text.length < 2 || self.nikeNameTF.text.length > 8) {
        [[HUDTool shareHUDTool] showHint:@"请输入2~8位字符的昵称" yOffset:0];
        return;
    }
    if (!self.contractTF.text.length) {
        [[HUDTool shareHUDTool] showHint:@"请输入你的联系方式" yOffset:0];
        return;
    }
    if (self.callBack) {
        self.callBack(self.nikeNameTF.text, self.contractTF.text);
    }
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftBarButtonItemClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
