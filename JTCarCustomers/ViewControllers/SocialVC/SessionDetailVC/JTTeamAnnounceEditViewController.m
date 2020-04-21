//
//  JTTeamAnnounceEditViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "GCPlaceholderTextView.h"
#import "JTTeamAnnounceEditViewController.h"
#import "JTTeamAnnounceViewController.h"

@interface JTTeamAnnounceEditViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UITextField *topTF;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *bottomTextView;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) NSString *requestUrl;

@end

@implementation JTTeamAnnounceEditViewController

- (instancetype)initWithTeam:(NIMTeam *)team {
    self = [super init];
    if (self) {
        self.team = team;
    }
    return self;
}

- (instancetype)initWithTeam:(NIMTeam *)team announceID:(NSString *)announceID{
    self = [self initWithTeam:team];
    if (self) {
        self.announceID = announceID;
    }
    return self;
}

- (void)setTeam:(NIMTeam *)team {
    _team = team;
}

- (void)setAnnounceID:(NSString *)announceID {
    _announceID = announceID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kIsIphonex?88:62;
    self.bottomTextView.placeholder = @"本公告会自动发送给新成员，15-500字";
    self.requestUrl = self.announceID?@"client/social/group/editGroupNotice":PostAnnounceApi;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)rightBtnClick:(UIButton *)sender {
    if (self.topTF.text.length < 4 || self.topTF.text.length > 40) {
        [[HUDTool shareHUDTool] showHint:@"请输入4~40字群公告标题" yOffset:0];
        return;
    }
    if (self.bottomTextView.text.length < 15 || self.bottomTextView.text.length > 500) {
        [[HUDTool shareHUDTool] showHint:@"请输入15~500字群公告内容" yOffset:0];
        return;
    }
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
    [progem setValue:self.team.teamId forKey:@"group_id"];
    [progem setValue:self.topTF.text forKey:@"title"];
    [progem setValue:self.bottomTextView.text forKey:@"content"];
    if (self.announceID) {
        [progem setValue:self.announceID forKey:@"id"];
    }
    [[HUDTool shareHUDTool] showHint:@"发送中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(self.requestUrl) parameters:progem success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
        UIViewController *tempVC;
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
            if ([vc isKindOfClass:[JTTeamAnnounceViewController class]]) {
                tempVC = vc;
                break;
            }
        }
        NSMutableDictionary *announceDict = [NSMutableDictionary dictionary];
        [announceDict setValue:[Utility currentTime:[NSDate date]] forKey:@"announceTime"];
        [[NIMSDK sharedSDK].teamManager updateMyCustomInfo:[announceDict mj_JSONString] inTeam:weakSelf.team.teamId completion:^(NSError * _Nullable error) {
            
        }];
        [weakSelf.navigationController popToViewController:tempVC animated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        _rightBtn.titleLabel.font = Font(14);
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
