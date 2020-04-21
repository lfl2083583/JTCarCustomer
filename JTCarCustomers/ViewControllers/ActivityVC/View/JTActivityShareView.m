//
//  JTActivityShareView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIView+Spring.h"
#import "JTActivityShareView.h"

@interface JTActivityShareView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *themeLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *siteLB;
@property (weak, nonatomic) IBOutlet UITextField *notesTF;

@end

@implementation JTActivityShareView

- (void)dealloc {
    CCLOG(@"JTActivityShareView销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (instancetype)initWithActivityInfo:(id)activityInfo
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"JTActivityShareView" owner:nil options:nil] lastObject];
    if (self) {
        self.activityInfo = activityInfo;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setWidth:App_Frame_Width];
    [self setHeight:APP_Frame_Height];
    self.notesTF.layer.borderWidth = 1;
    self.notesTF.layer.borderColor = BlackLeverColor2.CGColor;
    self.notesTF.layer.cornerRadius = 4;
    self.notesTF.layer.masksToBounds = YES;
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self endEditing:YES];
    [self dismissViewAnimated:YES completion:nil];
}

- (IBAction)sendBtnClick:(UIButton *)sender {
    [self endEditing:YES];
    [self dismissViewAnimated:YES completion:nil];
    if (self.callBack) {
        self.callBack(nil);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ((self.height-300)/2.0 < frame.size.height) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.contentView setCenterY:self.height-frame.size.height-160.0];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView setCenterY:self.height/2.0];
    }];
}

@end
