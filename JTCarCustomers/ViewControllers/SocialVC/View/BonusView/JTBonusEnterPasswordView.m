//
//  JTBonusEnterPasswordView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBonusEnterPasswordView.h"
#import "UIView+Spring.h"

@interface JTBonusEnterPasswordView ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;
@property (weak, nonatomic) IBOutlet UITextField *payPasswordTF;
@property (strong, nonatomic) NSMutableArray *points;

@end

@implementation JTBonusEnterPasswordView

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

- (instancetype)initWithBonusMoney:(double)bonusMoney bonusType:(JTBonusType)bonusType toID:(NSString *)toID bonusTitle:(NSString *)bonusTitle  bonusNum:(NSInteger)bonusNum completionHandler:(void (^)(JTBonusPaymentResults bonusPaymentResults))completionHandler
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"JTBonusEnterPasswordView" owner:nil options:nil] lastObject];
    if (self) {
        self.bonusMoney = bonusMoney;
        self.bonusType = bonusType;
        self.toID = toID;
        self.bonusTitle = bonusTitle;
        self.bonusNum = bonusNum;
        self.completionHandler = completionHandler;
    }
    return self;
}

- (void)textFieldEditChanged:(NSNotification *)obj {
    
    if ([obj.object isEqual:self.payPasswordTF]) {
        NSString *toBeString = self.payPasswordTF.text;
        if (toBeString.length <= 6) {
            for (NSInteger i = 0; i < 6; i ++) {
                [self.points[i] setHidden:(i >= toBeString.length)];
            }
            if (toBeString.length == 6) {
                [self requestServiceVerification];
            }
        }
        else
        {
            self.payPasswordTF.text = [toBeString substringToIndex:6];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    NSString *moneyText = [NSString stringWithFormat:@"%.2f唐人币", self.bonusMoney];
    NSMutableAttributedString *moneyAttributedString = [[NSMutableAttributedString alloc] initWithString:moneyText];
    NSRange range = [moneyText rangeOfString:@"唐人币"];
    [moneyAttributedString addAttribute:NSFontAttributeName value:Font(16) range:range];
    self.moneyLB.attributedText = moneyAttributedString;
    self.balanceLB.text = [NSString stringWithFormat:@"%.2f唐人币", [JTUserInfo shareUserInfo].userBalance];
    
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

- (void)requestServiceVerification
{
    if (self.completionHandler) {
        if (self.bonusMoney > [JTUserInfo shareUserInfo].userBalance) {
            self.completionHandler(JTBonusPaymentResultsNoMoney);
        }
        else
        {
            __weak typeof(self) weakself = self;
            NSDictionary *parameters = @{@"type": @(self.bonusType), @"toid": self.toID, @"pass": self.payPasswordTF.text, @"title": self.bonusTitle, @"amount": @(self.bonusMoney), @"num": @(self.bonusNum)};
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SendPacketApi) parameters:parameters placeholder:@"" success:^(id responseObject, ResponseState state) {
                [JTUserInfo shareUserInfo].userBalance -= weakself.bonusMoney;
                [[JTUserInfo shareUserInfo] save];
                [weakself.superview.superview dismissViewAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBalanceNotification object:nil];
                weakself.completionHandler(JTBonusPaymentResultsSuccess);
            } failure:^(NSError *error) {
                
            }];
        }
    }
}
@end
