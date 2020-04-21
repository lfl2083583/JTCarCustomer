//
//  JTFeeExplainViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTFeeExplainViewController.h"

@interface JTFeeExplainViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation JTFeeExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"金额明细说明";
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
