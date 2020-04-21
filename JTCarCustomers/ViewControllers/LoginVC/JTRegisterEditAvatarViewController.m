//
//  JTRegisterEditAvatarViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTRegisterEditAvatarViewController.h"
#import "JTRegisterEditSexViewController.h"
#import "ZTObtainPhotoTool.h"
#import "UIButton+WebCache.h"

@interface JTRegisterEditAvatarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIButton *avtarBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNikeNameTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *nikeName;
@end

@implementation JTRegisterEditAvatarViewController

- (void)dealloc {
    CCLOG(@"JTRegisterEditAvatarViewController销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (instancetype)initWithAvatarUrl:(NSString *)avatarUrl nikeName:(NSString *)nikeName{
    if (self = [super init]) {
        _nikeName = nikeName;
        _avatarUrl = avatarUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextStepBtn.layer.cornerRadius = 4;
    self.nextStepBtn.layer.borderWidth = 1;
    self.nextStepBtn.layer.borderColor = BlackLeverColor3.CGColor;
    self.nextStepBtn.layer.masksToBounds = YES;
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    
    if (self.avatarUrl) {
        [self.avtarBtn sd_setImageWithURL:[NSURL URLWithString:self.avatarUrl] forState:UIControlStateNormal];
        self.userNikeNameTF.text = self.nikeName;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (IBAction)takePhotoClick:(UIButton *)sender {
    __weak typeof (self)weakSelf = self;
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary photoEditType:JTPhotoEditTypeCustom success:^(UIImage *image) {
        weakSelf.avatar = image;
        [weakSelf.avtarBtn setImage:image forState:UIControlStateNormal];
    } cancel:^{
        
    }];
}

- (IBAction)avatarBtnClick:(UIButton *)sender {
    __weak typeof (self)weakSelf = self;
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:self photoEditType:JTPhotoEditTypeCustom success:^(UIImage *image) {
        weakSelf.avatar = image;
        [weakSelf.avtarBtn setImage:image forState:UIControlStateNormal];
    } cancel:^{
        
    }];
}

- (IBAction)uploadPhotoClick:(UIButton *)sender {
    __weak typeof (self)weakSelf = self;
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:self sourceType:UIImagePickerControllerSourceTypeCamera photoEditType:JTPhotoEditTypeCustom success:^(UIImage *image) {
        weakSelf.avatar = image;
        [weakSelf.avtarBtn setImage:image forState:UIControlStateNormal];
    } cancel:^{
        
    }];
}

- (IBAction)nextStepBtnClick:(UIButton *)sender {
    if (!self.avatar && !self.avatarUrl) {
        [[HUDTool shareHUDTool] showHint:@"请上传一张用户头像" yOffset:0];
        return;
    }
    
    if (!self.userNikeNameTF.text.length || self.userNikeNameTF.text.length > 9) {
        [[HUDTool shareHUDTool] showHint:@"请输入9字以内用户昵称" yOffset:0];
        return;
    }
    [self.navigationController pushViewController:[[JTRegisterEditSexViewController alloc] initWithAvatar:self.avatar ?self.avatar:self.avtarBtn.imageView.image nikeName:self.userNikeNameTF.text] animated:YES];
}

#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frame.origin.y < self.userNikeNameTF.y+30) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setY:frame.origin.y-self.userNikeNameTF.y-30-15];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setY:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
