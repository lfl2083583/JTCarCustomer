//
//  JTRealCertificationViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTRealCertificationView.h"
#import "JTRealCertificationViewController.h"

@interface JTRealCertificationViewController ()

@property (nonatomic, strong) JTRealCertificationView *unrealCertificationVIew;
@property (nonatomic, strong) JTRealCertificationAuditView *auditView;

@end

@implementation JTRealCertificationViewController

- (instancetype)initWithRealCertificationStatus:(JTRealCertificationStatus)status {
    if (self = [super init]) {
        self.status = status;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    if (self.status == JTRealCertificationStatusUnAuth || self.status == JTRealCertificationStatusAuthFail) {
         self.view = self.unrealCertificationVIew;
    }else {
        self.view = self.auditView;
    }
   
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

- (JTRealCertificationView *)unrealCertificationVIew {
    if (!_unrealCertificationVIew) {
        _unrealCertificationVIew = [[JTRealCertificationView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    }
    return _unrealCertificationVIew;
}

- (JTRealCertificationAuditView *)auditView {
    if (!_auditView) {
        _auditView = [[JTRealCertificationAuditView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height) realCertificationStatus:self.status];
    }
    return _auditView;
}

@end
