//
//  JTTeamQRViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTQRCode.h"
#import "JTTeamQRViewController.h"

@interface JTTeamQRViewController ()

@end

@implementation JTTeamQRViewController

- (instancetype)initWithTeam:(NIMTeam *)team {
    self = [super init];
    if (self) {
        self.team = team;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kIsIphonex?82:62;
    self.qrImgeView.image = [ZTQRCode createQRImageWithString:[NSString stringWithFormat:@"http://h5.6che.vip/jump?action=addgroup&groupid=%@&inviter=%@&t=%@&market=qr", self.team.teamId, [JTUserInfo shareUserInfo].userID, [Utility currentTime:[NSDate dateWithTimeIntervalSinceNow:0]]] size:self.qrImgeView.size];
    [self.avatrImgeView sd_setImageWithURL:[NSURL URLWithString:[self.team.avatarUrl avatarHandleWithSquare:100]] placeholderImage:[UIImage imageNamed:@"default_group_icon"]];
    self.topLB.text = self.team.teamName;
    self.bottomLB.text = [NSString stringWithFormat:@"群号：%@",self.team.teamId];
    
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

@end
