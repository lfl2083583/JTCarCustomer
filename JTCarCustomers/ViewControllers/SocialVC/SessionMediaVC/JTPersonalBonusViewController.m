//
//  JTPersonalBonusViewController.m
//  JTSocial
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTPersonalBonusViewController.h"
#import "GCPlaceholderTextView.h"
#import "JTBaseSpringView.h"
#import "JTBonusEnterPasswordView.h"
#import "JTBonusNoMoneyView.h"
#import "JTBonusSetPasswodView.h"
#import "JTTradeWebViewController.h"

@interface JTPersonalBonusViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *moneyTitleLB;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *moneyUnitLB;

@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;

@property (assign, nonatomic) double totalMoney;
@property (assign, nonatomic) BOOL isFrontError;
@property (assign, nonatomic) BOOL isTheMoneyStatus;

@property (weak, nonatomic) IBOutlet UIButton *theMoneyBT;

@end

@implementation JTPersonalBonusViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithNibName:@"JTPersonalBonusViewController" bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightClick:(id)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS11) {
        self.scrollview.top = kStatusBarHeight + kTopBarHeight;
    }
    self.scrollview.contentSize = CGSizeMake(0, self.scrollview.height + 100);
    [self.scrollview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(singleGesturePress:)]];
    [self.contentTV setPlaceholder:@"恭喜发财，大吉大利"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"红包明细" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.title = @"发红包";
    
    self.navigationController.navigationBar.barTintColor = RedLeverColor1;
    self.navigationController.navigationBar.tintColor = WhiteColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: Font(18), NSForegroundColorAttributeName: WhiteColor};
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: Font(14), NSForegroundColorAttributeName: WhiteColor} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: Font(14), NSForegroundColorAttributeName: WhiteColor} forState:UIControlStateNormal];
    
    self.totalMoney = 0;
}

- (void)textFieldEditChanged:(NSNotification *)notification {
    if ([notification.object isEqual:self.moneyTF]) {
        NSString *toBeString = self.moneyTF.text;
        NSArray *points = [toBeString componentsSeparatedByString:@"."];
        if (points.count > 2) {
            self.moneyTF.text = [NSString stringWithFormat:@"%@.%@", points[0], points[1]];
        }
        if (points.count == 2) {
            self.moneyTF.text = [NSString stringWithFormat:@"%@.%@", (([points[0] length] > 6) ? [points[0] substringToIndex:6] : points[0]), (([points[1] length] > 2) ? [points[1] substringToIndex:2] : points[1])];
        }
        else if (points.count == 1)
        {
            self.moneyTF.text = [NSString stringWithFormat:@"%@", (([points[0] length] > 6) ? [points[0] substringToIndex:6] : points[0])];
        }
        toBeString = self.moneyTF.text;
        self.totalMoney = [toBeString doubleValue];
        self.isFrontError = (self.totalMoney > 2000);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)theMoneyClick:(id)sender {
    if (self.totalMoney < 0.01) {
        [Utility showAlertMessage:@"单个红包金额不可低于0.01唐人币，请重新填写金额"];
        return;
    }
    
    [self.moneyTF resignFirstResponder];
    [self.contentTV resignFirstResponder];
    if ([JTUserInfo shareUserInfo].isUserPaymentPassword) {
        __weak typeof(self) weakself = self;
        if (self.totalMoney > [JTUserInfo shareUserInfo].userBalance) {
            JTBonusNoMoneyView *bonusNoMoneyView = [[JTBonusNoMoneyView alloc] initWithBonusMoney:self.totalMoney completionHandler:^{
                [weakself.navigationController pushViewController:[[JTTradeWebViewController alloc] init] animated:YES];
            }];
            JTBaseSpringView *springView = [[JTBaseSpringView alloc] initWithContentView:bonusNoMoneyView];
            [[Utility mainWindow] presentView:springView animated:YES completion:nil];
        }
        else
        {
            NSString *bonusTitle = (self.contentTV && self.contentTV.text.length > 0)?self.contentTV.text:self.contentTV.placeholder;
            NSString *toID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]];
            JTBonusEnterPasswordView *bonusEnterPasswordView = [[JTBonusEnterPasswordView alloc] initWithBonusMoney:self.totalMoney bonusType:JTBonusTypeNormal toID:toID bonusTitle:bonusTitle bonusNum:1 completionHandler:^(JTBonusPaymentResults bonusPaymentResults) {
                if (bonusPaymentResults == JTBonusPaymentResultsNoMoney) {
                    [[HUDTool shareHUDTool] showHint:@"唐人币余额不足，请充值" yOffset:0];
                }
                else
                {
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            JTBaseSpringView *springView = [[JTBaseSpringView alloc] initWithContentView:bonusEnterPasswordView];
            [[Utility mainWindow] presentView:springView animated:YES completion:nil];
        }
    }
    else
    {
        JTBonusSetPasswodView *bonusSetPasswodView = [[[NSBundle mainBundle] loadNibNamed:@"JTBonusSetPasswodView" owner:nil options:nil] lastObject];
        JTBaseSpringView *springView = [[JTBaseSpringView alloc] initWithContentView:bonusSetPasswodView];
        [[Utility mainWindow] presentView:springView animated:YES completion:nil];
    }
}

- (void)singleGesturePress:(UIGestureRecognizer *)gestureRecognizer
{
    [self.moneyTF resignFirstResponder];
    [self.contentTV resignFirstResponder];
}

- (void)setTotalMoney:(double)totalMoney
{
    _totalMoney = totalMoney;
    NSString *moneyText = [NSString stringWithFormat:@"%.2f 唐人币", self.totalMoney];
    NSMutableAttributedString *moneyAttributedString = [[NSMutableAttributedString alloc] initWithString:moneyText];
    NSRange range = [moneyText rangeOfString:@"唐人币"];
    [moneyAttributedString addAttribute:NSFontAttributeName value:Font(16) range:range];
    self.moneyLB.attributedText = moneyAttributedString;
}

- (void)setIsFrontError:(BOOL)isFrontError
{
    _isFrontError = isFrontError;
    self.moneyTitleLB.textColor = isFrontError ? RedLeverColor1 : BlackLeverColor5;
    self.moneyTF.textColor = isFrontError ? RedLeverColor1 : BlackLeverColor5;
    self.moneyUnitLB.textColor = isFrontError ? RedLeverColor1 : BlackLeverColor5;
    self.isTheMoneyStatus = (self.moneyTF.text.length > 0 && !_isFrontError);
}

- (void)setIsTheMoneyStatus:(BOOL)isTheMoneyStatus
{
    _isTheMoneyStatus = isTheMoneyStatus;
    if (_isTheMoneyStatus) {
        [self.theMoneyBT setBackgroundColor:RedLeverColor1];
        [self.theMoneyBT setUserInteractionEnabled:YES];
    }
    else
    {
        [self.theMoneyBT setBackgroundColor:[RedLeverColor1 colorWithAlphaComponent:.6]];
        [self.theMoneyBT setUserInteractionEnabled:NO];
    }
}
@end
