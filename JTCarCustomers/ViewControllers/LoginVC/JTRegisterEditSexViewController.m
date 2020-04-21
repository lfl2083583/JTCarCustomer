//
//  JTRegisterEditSexViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTFileNameTool.h"
#import "JTServiceApi.h"
#import "JTRegisterEditSexViewController.h"
#import "JTRegisterPersonTagViewController.h"
#import "JTHobbyTableViewCell.h"

@interface JTRegisterEditSexViewController ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, assign) JTUserGender gender;
@property (nonatomic, strong) UIImage *avatarImg;
@property (nonatomic, copy) NSString *nikeName;

@end

@implementation JTRegisterEditSexViewController
- (instancetype)initWithAvatar:(UIImage *)avatar nikeName:(NSString *)nikeName{
    if (self = [super init]) {
        self.avatarImg = avatar;
        self.nikeName = nikeName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comfirmBtn.layer.cornerRadius = 4;
    self.comfirmBtn.layer.borderWidth = 1;
    self.comfirmBtn.layer.borderColor = BlackLeverColor3.CGColor;
    self.comfirmBtn.layer.masksToBounds = YES;
    self.topConstraint.constant = 59+(kIsIphonex?24:0);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [dateFormatter dateFromString:@"1971-01-01"];
    [self.dataPickerView setMinimumDate:minDate];
    [self.dataPickerView setMaximumDate:[NSDate date]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}



/**
 用户性别选择

 @param sender 性别按钮
 */
- (IBAction)genderChooseClick:(UIButton *)sender {
    self.manBtn.selected = NO;
    self.womanBtn.selected = NO;
    self.leftLabel.textColor = BlackLeverColor4;
    self.rightLabel.textColor = BlackLeverColor4;
    if (sender.tag == 10) {
        self.manBtn.selected = YES;
        self.gender = JTUserGenderMan;
        self.leftLabel.textColor = BlueLeverColor1;
    } else {
        self.womanBtn.selected = YES;
        self.gender = JTUserGenderWoman;
        self.rightLabel.textColor = BlueLeverColor1;
    }
}

/**
 设置用户性别&生日

 @param sender 确定按钮
 */
- (IBAction)comfirmClick:(UIButton *)sender {
    NSDate *date = self.dataPickerView.date;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *birth = [formate stringFromDate:date];
    
    if (self.gender == JTUserGenderUnKnown) {
        [[HUDTool shareHUDTool] showHint:@"请选择用户性别" yOffset:0];
        return;
    }
    
    if (self.avatarImg) {
        [[HttpRequestTool sharedInstance] uploadWithFileNames:[ZTFileNameTool showFileNamesForAvatar] uploadFileArr:@[self.avatarImg] success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
                NSArray *urlArrary = responseObject;
                __weak typeof(self)weakSelf = self;
                ConfigParam *configParam = [[ConfigParam alloc] initWithPlaceholder:nil atCacheEnabled:NO];
                configParam.isEncrypt = YES;
                configParam.isNeedUserTokenAndUserID = YES;
                [[HttpRequestTool sharedInstance] startRequestURLString:kBase_url(EditeUserInfoApi) parameters:@{@"nick_name" : weakSelf.nikeName, @"avatar" : [urlArrary firstObject], @"gender" : @(self.gender), @"birth" : birth} httpType:HttpRequestTypePost configParam:configParam success:^(id responseObject, ResponseState state) {
                    CCLOG(@"%@",responseObject);
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                        NSString *userAvatar = responseObject[@"avatar"];
                        NSString *userName = responseObject[@"nick_name"];
                        NSString *userBirth = responseObject[@"birth"];
                        NSString *userGender = responseObject[@"gender"];
                        [JTUserInfo shareUserInfo].userBirth = [NSString stringWithFormat:@"%@",userBirth];
                        [JTUserInfo shareUserInfo].userGenter = [userGender integerValue];
                        [JTUserInfo shareUserInfo].userAvatar = [NSString stringWithFormat:@"%@",userAvatar];
                        [JTUserInfo shareUserInfo].userName = [NSString stringWithFormat:@"%@",userName];
                        [weakSelf socialLoginSeccess:[JTUserInfo shareUserInfo]];
                        [weakSelf.navigationController pushViewController:[[JTRegisterPersonTagViewController alloc] init]  animated:YES];
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
