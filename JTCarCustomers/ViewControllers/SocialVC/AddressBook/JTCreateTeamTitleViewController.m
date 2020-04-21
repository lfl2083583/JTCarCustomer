//
//  JTCreateTeamTitleViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/16.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMessageMaker.h"
#import "JTSessionViewController.h"
#import "JTCreateTeamTitleViewController.h"
#import "GCPlaceholderTextView.h"
#import "JTGradientButton.h"
#import "ZTObtainPhotoTool.h"
#import "ZTFileNameTool.h"

@interface JTCreateTeamTitleViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teamAvatarConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teamNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTF;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *teamDescribeTV;
@property (weak, nonatomic) IBOutlet UIButton *teamAvatar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLB;

@property (nonatomic, assign) JTTeamPositionType positionType;
@property (nonatomic, assign) JTTeamCategoryType classfy;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) UIImage *avatar;

@end

@implementation JTCreateTeamTitleViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (instancetype)initWithTeamNearby:(JTTeamPositionType)positionType lng:(NSString *)lng lat:(NSString *)lat address:(NSString *)address classfy:(JTTeamCategoryType)classfy {
    if (self = [super init]) {
        self.positionType = positionType;
        self.lng = lng;
        self.lat = lat;
        self.address = address;
        self.classfy = classfy;
    }
    return self;
}

- (instancetype)initWithTeam:(NIMTeam *)team callBack:(zt_TeamInfoBlock)callBack {
    self = [super init];
    if (self) {
        self.team = team;
        [self setCallBack:callBack];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kIsIphonex?82:62;
    if (kIsIphone4s || kIsIphone5) {
        self.teamAvatarConstraint.constant = 10;
        self.teamNameConstraint.constant = 15;
        self.bottomBtnConstraint.constant = 10;
    }
    self.teamNameTF.layer.borderColor = BlackLeverColor2.CGColor;
    self.teamNameTF.layer.borderWidth = 1;
    self.teamNameTF.layer.cornerRadius = 5;
    self.teamNameTF.layer.masksToBounds = YES;
    self.teamDescribeTV.layer.borderColor = BlackLeverColor2.CGColor;
    self.teamDescribeTV.layer.borderWidth = 1;
    self.teamDescribeTV.layer.cornerRadius = 5;
    self.teamDescribeTV.layer.masksToBounds = YES;
    self.teamDescribeTV.placeholder = @"描述这是怎样的群组15~300字";
    self.teamNameTF.returnKeyType = UIReturnKeyNext;
    self.teamDescribeTV.returnKeyType = UIReturnKeyDone;
    self.teamNameTF.delegate = self;
    self.teamDescribeTV.delegate = self;
    NSString *str = @"提交代表同意《服务声明》";
    self.bottomLB.text = str;
    [Utility richTextLabel:self.bottomLB fontNumber:Font(12) andRange:[str rangeOfString:@"《服务声明》"] andColor:BlueLeverColor1];
    UITapGestureRecognizer *tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuestureEvent:)];
    tapGuester.numberOfTapsRequired = 1;
    self.bottomLB.userInteractionEnabled = YES;
    [self.bottomLB addGestureRecognizer:tapGuester];
    self.scrollerView.contentSize = CGSizeMake(App_Frame_Width, APP_Frame_Height+APP_Frame_Height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat originalY = kIsIphonex?82:62;
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frame.origin.y < self.teamDescribeTV.y) {
        CGFloat offsety = self.teamDescribeTV.y - frame.origin.y + 90;
        [UIView animateWithDuration:0.25 animations:^{
            self.topConstraint.constant = originalY-offsety;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat originalY = kIsIphonex?82:62;
    [UIView animateWithDuration:0.2 animations:^{
        self.topConstraint.constant = originalY;
    }];
}

- (IBAction)choosePhotoBtnClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:self success:^(UIImage *image) {
        weakSelf.avatar = image;
        [weakSelf.teamAvatar setImage:image forState:UIControlStateNormal];
    } cancel:^{
        
    }];
}

- (IBAction)submitBtnClick:(JTGradientButton *)sender {
    
    if (self.team) {
        if (!self.teamAvatar && (self.teamNameTF.text.length < 2 || self.teamNameTF.text.length > 10) && (self.teamDescribeTV.text.length < 15 || self.teamDescribeTV.text.length > 300)) {
            [[HUDTool shareHUDTool] showHint:@"请正确的修改群资料" yOffset:0];
        }
        if (self.callBack) {
            self.callBack(self.avatar, self.teamNameTF.text, self.teamDescribeTV.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (!self.avatar) {
            [[HUDTool shareHUDTool] showHint:@"请选择群头像" yOffset:0];
            return;
        }
        if (self.teamNameTF.text.length < 2 || self.teamNameTF.text.length > 10) {
            [[HUDTool shareHUDTool] showHint:@"请输入2~10位字符群昵称" yOffset:0];
            return;
        }
        if (self.teamDescribeTV.text.length < 15 || self.teamDescribeTV.text.length > 300) {
            [[HUDTool shareHUDTool] showHint:@"请输入15~300位字符群描述" yOffset:0];
            return;
        }
        __weak typeof (self)weakSelf = self;
        [[HttpRequestTool sharedInstance] uploadWithFileNames:[ZTFileNameTool showFileNamesForTeamAvatar] uploadFileArr:@[self.avatar] success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
                NSArray *array = responseObject;
                NSString *teamAvatr = [array firstObject];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setValue:weakSelf.teamNameTF.text forKey:@"name"];
                [param setValue:weakSelf.teamDescribeTV.text forKey:@"describe"];
                [param setValue:teamAvatr  forKey:@"head_image"];
                [param setValue:@(weakSelf.classfy) forKey:@"category"];
                [param setValue:@(weakSelf.positionType) forKey:@"position"];
                [param setValue:weakSelf.address forKey:@"address"];
                [param setValue:weakSelf.lng forKey:@"longitude"];
                [param setValue:weakSelf.lat forKey:@"latitude"];
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(CreatTeamApi) parameters:param success:^(id responseObject, ResponseState state) {
                    CCLOG(@"%@",responseObject);
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                        NSString *sessionID = responseObject[@"group_id"];
                        NIMSession *session = [NIMSession session:sessionID type:NIMSessionTypeTeam];
                        NIMMessage *message = [JTMessageMaker messageWithTeamOwnerTip:@"群聊创建成功\n邀请好友加人，或分享群聊给大家"];
                        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                        JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
                        if (weakSelf.tabBarController.selectedIndex == 0) {
                            sessionVC.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:sessionVC animated:YES];
                            UIViewController *root = weakSelf.navigationController.viewControllers[0];
                            weakSelf.navigationController.viewControllers = @[root, sessionVC];
                        }
                        else
                        {
                            [weakSelf.tabBarController setSelectedIndex:0];
                            [[weakSelf.tabBarController.selectedViewController topViewController] setHidesBottomBarWhenPushed:YES];
                            [sessionVC setHidesBottomBarWhenPushed:YES];
                            [weakSelf.tabBarController.selectedViewController pushViewController:sessionVC animated:YES];
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}

//服务声明
- (void)tapGuestureEvent:(UITapGestureRecognizer *)sender {
    
}

- (IBAction)tapBackGround:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate | UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.teamDescribeTV becomeFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
