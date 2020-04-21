//
//  JTBulletInputView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBulletInputView.h"
#import "ZTBullet.h"

@interface JTBulletInputView ()


@end

@implementation JTBulletInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame fuid:(NSString *)fuid{
    self = [super initWithFrame:frame];
    if (self) {
        self.fuid = fuid;
        [self addSubview:self.leftTF];
        [self addSubview:self.rightBtn];
        self.backgroundColor = WhiteColor;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.2 animations:^{
        [self setY:APP_Frame_Height-frame.size.height-self.height];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        [self setY:APP_Frame_Height];
    }];
}

- (void)rightBtnClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SendBarrageApi) parameters:@{@"to_uid" : self.fuid,@"message" : self.leftTF.text} success:^(id responseObject, ResponseState state) {
        [[ZTBulletManager sharedInstance] zt_insertBulletView:@{@"message" : weakSelf.leftTF.text, @"avatar" : [JTUserInfo shareUserInfo].userAvatar, @"nick_name" : [JTUserInfo shareUserInfo].userName}];
        weakSelf.leftTF.text = @"";
    } failure:^(NSError *error) {
        
    }];
}

- (void)leftTFEditeChanged:(UITextField *)sender {
    if (sender.text.length > 20) {
        sender.text = [sender.text substringToIndex:20];
    }
}

- (UITextField *)leftTF {
    if (!_leftTF) {
        _leftTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.width-70, self.height-10)];
        _leftTF.layer.borderWidth = 0.5;
        _leftTF.layer.borderColor = BlackLeverColor2.CGColor;
        _leftTF.layer.cornerRadius = 4;
        _leftTF.layer.masksToBounds = YES;
        [_leftTF addTarget:self action:@selector(leftTFEditeChanged:) forControlEvents:UIControlEventAllEditingEvents];
    }
    return _leftTF;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftTF.frame)+10, 5, 40, self.height-10)];
        _rightBtn.titleLabel.font = Font(16);
        [_rightBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
