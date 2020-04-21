//
//  JTBonusSetPasswodView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBonusSetPasswodView.h"
#import "UIView+Spring.h"
#import "JTBonusAgainSetPasswordView.h"

@interface JTBonusSetPasswodView ()

@property (weak, nonatomic) IBOutlet UITextField *payPasswordTF;
@property (strong, nonatomic) NSMutableArray *points;
@end

@implementation JTBonusSetPasswodView

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

- (IBAction)nextClick:(id)sender {
    if (self.payPasswordTF.text.length == 6) {
        JTBonusAgainSetPasswordView *bonusAgainSetPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"JTBonusAgainSetPasswordView" owner:nil options:nil] lastObject];
        bonusAgainSetPasswordView.lastPassword = self.payPasswordTF.text;
        [self pushView:bonusAgainSetPasswordView animated:YES];
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
