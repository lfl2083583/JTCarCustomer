//
//  JTAliCertificationViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTAliCertificationViewController.h"
#import "JTAliCertificationView.h"

@interface JTAliCertificationViewController ()

@property (nonatomic, strong) JTAliCertificationView *aliCertificationView;
@property (nonatomic, strong) JTAliCertificationAuditView *aliCertificationAuditView;

@end

@implementation JTAliCertificationViewController

- (void)loadView {
    [super loadView];
    self.view = self.aliCertificationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (JTAliCertificationView *)aliCertificationView {
    if (!_aliCertificationView) {
        _aliCertificationView = [[JTAliCertificationView alloc] initWithFrame:self.view.bounds];
    }
    return _aliCertificationView;
}

- (JTAliCertificationAuditView *)aliCertificationAuditView {
    if (!_aliCertificationAuditView) {
        _aliCertificationAuditView = [[JTAliCertificationAuditView alloc] initWithFrame:self.view.bounds];
    }
    return _aliCertificationAuditView;
}

@end
