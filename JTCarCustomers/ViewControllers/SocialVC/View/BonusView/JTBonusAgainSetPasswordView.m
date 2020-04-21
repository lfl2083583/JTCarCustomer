//
//  JTBonusAgainSetPasswordView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBonusAgainSetPasswordView.h"
#import "UIView+Spring.h"

@interface JTBonusAgainSetPasswordView ()

@property (weak, nonatomic) IBOutlet UITextField *payPasswordTF;
@property (strong, nonatomic) NSMutableArray *points;

@end


@implementation JTBonusAgainSetPasswordView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:)
                                                     name:@"UITextFieldTextDidChangeNotification"
                                                   object:nil];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.points = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i ++) {
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.payPasswordTF.frame)+12.5+40.0 * i, CGRectGetMinY(self.payPasswordTF.frame)+12.5, 15, 15)];
        point.backgroundColor = [UIColor blackColor];
        point.layer.masksToBounds = YES;
        point.layer.cornerRadius = 7.5;
        [self addSubview:point];
        [self.points addObject:point];
        point.hidden = YES;
    }
    [self.payPasswordTF becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (IBAction)completeClick:(id)sender {
    if (self.payPasswordTF.text.length == 6) {
        if ([self.payPasswordTF.text isEqualToString:self.lastPassword]) {
            NSDictionary *parameters = @{@"new_password": self.lastPassword};
            __weak typeof(self) weakself = self;
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SetPasswordApi) parameters:parameters placeholder:@"" success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"设置支付密码成功" yOffset:0];
                [[JTUserInfo shareUserInfo] setIsUserPaymentPassword:YES];
                [[JTUserInfo shareUserInfo] save];
                [weakself.superview.superview dismissViewAnimated:YES completion:nil];
            } failure:^(NSError *error) {
                
            }];
        }
        else
        {
            self.payPasswordTF.text = @"";
            for (NSInteger i = 0; i < 6; i ++) {
                [self.points[i] setHidden:YES];
            }
            [[HUDTool shareHUDTool] showHint:@"两次输入不一样，请重新输入" yOffset:0];
        }
    }
}

- (void)textFieldEditChanged:(NSNotification *)obj {
    
    if ([obj.object isEqual:self.payPasswordTF]) {
        NSString *toBeString = self.payPasswordTF.text;
        if (toBeString.length <= 6) {
            for (NSInteger i = 0; i < 6; i ++) {
                [self.points[i] setHidden:(i >= toBeString.length)];
            }
        }
        else
        {
            self.payPasswordTF.text = [toBeString substringToIndex:6];
        }
    }
}

@end
