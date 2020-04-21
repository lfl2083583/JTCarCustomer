//
//  JTAccountAboutPhoneViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTAccountAboutPhoneViewController.h"
#import "JTAccountOriginalPhoneViewController.h"

@interface JTAccountAboutPhoneViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;

@end

@implementation JTAccountAboutPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    NSString *phoneStr = [JTUserInfo shareUserInfo].userPhone;
    self.phoneLB.text = [NSString stringWithFormat:@"当前手机号：%@****%@",[phoneStr substringToIndex:3],[phoneStr substringWithRange:NSMakeRange(phoneStr.length-4, 4)]];
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

- (IBAction)bottomBtnClick:(JTGradientButton *)sender {
    [self.navigationController pushViewController:[[JTAccountOriginalPhoneViewController alloc] init] animated:YES];
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
