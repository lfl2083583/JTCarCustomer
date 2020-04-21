//
//  JTTeamBonusViewController.m
//  JTSocial
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTeamBonusViewController.h"
#import "GCPlaceholderTextView.h"
#import "JTBaseSpringView.h"
#import "JTBonusEnterPasswordView.h"
#import "JTBonusNoMoneyView.h"
#import "JTBonusSetPasswodView.h"
#import "JTTradeWebViewController.h"

@interface JTTeamBonusViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *moneyTitleLB;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *moneyUnitLB;
@property (weak, nonatomic) IBOutlet UILabel *promptMoneyLB;

@property (weak, nonatomic) IBOutlet UILabel *numberTitleLB;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UILabel *numberUnitLB;
@property (weak, nonatomic) IBOutlet UILabel *promptNumberLB;

@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;

@property (assign, nonatomic) BOOL isFight;
@property (assign, nonatomic) double totalMoney;
@property (assign, nonatomic) BOOL isFrontError;
@property (assign, nonatomic) BOOL isRearError;
@property (assign, nonatomic) BOOL isTheMoneyStatus;

@property (weak, nonatomic) IBOutlet UIButton *theMoneyBT;

@end

@implementation JTTeamBonusViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithNibName:@"JTTeamBonusViewController" bundle:nil];
    if (self) {
        _session = session;
        _isFight = YES;
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
    
    [self updateUI];
    self.promptNumberLB.text = [NSString stringWithFormat:@"本群共%ld人", [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId].memberNumber];
    self.totalMoney = 0;
}

- (void)handleTextField:(UITextField *)textTF
{
    if ([textTF isEqual:self.moneyTF])
    {
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
        if (_isFight) {
            self.totalMoney = [toBeString doubleValue];
            if (self.numberTF.text.length > 0) {
                CGFloat singleMoney = self.totalMoney / [self.numberTF.text integerValue];
                self.isFrontError = (singleMoney > 2000);
            }
            else
            {
                self.isFrontError = NO;
            }
        }
        else
        {
            double singleMoney = [toBeString doubleValue];
            self.isFrontError = (singleMoney > 2000);
            NSInteger number = (self.numberTF.text.length > 0) ? [self.numberTF.text integerValue] : 0;
            self.totalMoney = singleMoney * number;
        }
    }
    else if ([textTF isEqual:self.numberTF])
    {
        NSInteger number = [self.numberTF.text integerValue];
        self.isRearError = (number > 100);
        if (_isFight) {
            self.totalMoney = [self.moneyTF.text doubleValue];
            if (self.numberTF.text.length > 0) {
                double singleMoney = self.totalMoney / number;
                self.isFrontError = (singleMoney > 2000);
            }
            else
            {
                self.isFrontError = NO;
            }
        }
        else
        {
            CGFloat singleMoney = (self.moneyTF.text.length > 0) ? [self.moneyTF.text doubleValue] : 0;
            self.isFrontError = (singleMoney > 2000);
            self.totalMoney = singleMoney * number;
        }
    }
}

- (void)textFieldEditChanged:(NSNotification *)notification {
    if ([notification.object isEqual:self.moneyTF])
    {
        [self handleTextField:self.moneyTF];
    }
    else if ([notification.object isEqual:self.numberTF])
    {
        [self handleTextField:self.numberTF];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)theMoneyClick:(id)sender {
    if (self.totalMoney < 0.01*[self.numberTF.text integerValue]) {
        [Utility showAlertMessage:@"单个红包金额不可低于0.01唐人币，请重新填写金额"];
        return;
    }
    
    [self.moneyTF resignFirstResponder];
    [self.numberTF resignFirstResponder];
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
            JTBonusEnterPasswordView *bonusEnterPasswordView = [[JTBonusEnterPasswordView alloc] initWithBonusMoney:self.totalMoney bonusType:self.isFight?JTBonusTypeTeamLuck:JTBonusTypeTeamAverage toID:self.session.sessionId bonusTitle:bonusTitle bonusNum:[self.numberTF.text integerValue] completionHandler:^(JTBonusPaymentResults bonusPaymentResults) {
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
    CGPoint touchPoint = [gestureRecognizer locationInView:self.scrollview];
    if (CGRectContainsPoint(CGRectMake(135, self.promptMoneyLB.y, 80, self.promptMoneyLB.height), touchPoint)) {
        _isFight = !_isFight;
        [self updateUI];
    }
    else
    {
        [self.moneyTF resignFirstResponder];
        [self.numberTF resignFirstResponder];
        [self.contentTV resignFirstResponder];
    }
}

- (void)updateUI
{
    if (_isFight) {

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" 总金额"];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2.5, 16, 16);
        attach.image = [UIImage imageNamed:@"icon_fight"];
        NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
        [attributedString insertAttributedString:strAtt atIndex:0];
        self.moneyTitleLB.attributedText = attributedString;

        NSString *prompt = @"当前为拼手气红包，改为普通红包";
        NSMutableAttributedString *promptAttributedString = [[NSMutableAttributedString alloc] initWithString:prompt];
        NSRange range = [prompt rangeOfString:@"改为普通红包"];
        [promptAttributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
        self.promptMoneyLB.attributedText = promptAttributedString;
        if (self.moneyTF.text.length > 0 && self.numberTF.text.length > 0) {
            self.moneyTF.text = [NSString stringWithFormat:@"%.2f", [self.moneyTF.text floatValue]*[self.numberTF.text integerValue]];
        }
    }
    else
    {
        self.moneyTitleLB.text = @"单个金额";
        NSString *prompt = @"当前为普通红包，改为拼手气红包";
        NSMutableAttributedString *promptAttributedString = [[NSMutableAttributedString alloc] initWithString:prompt];
        NSRange range = [prompt rangeOfString:@"改为拼手气红包"];
        [promptAttributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
        self.promptMoneyLB.attributedText = promptAttributedString;
        
        if (self.moneyTF.text.length > 0 && self.numberTF.text.length > 0) {
            self.moneyTF.text = [NSString stringWithFormat:@"%.2f", [self.moneyTF.text floatValue]/[self.numberTF.text integerValue]];
        }
    }
    [self handleTextField:self.moneyTF];
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
    self.isTheMoneyStatus = (self.moneyTF.text.length > 0 && self.numberTF.text.length > 0 && !_isFrontError && !_isRearError);
}

- (void)setIsRearError:(BOOL)isRearError
{
    _isRearError = isRearError;
    self.numberTitleLB.textColor = isRearError ? RedLeverColor1 : BlackLeverColor5;
    self.numberTF.textColor = isRearError ? RedLeverColor1 : BlackLeverColor5;
    self.numberUnitLB.textColor = isRearError ? RedLeverColor1 : BlackLeverColor5;
    self.isTheMoneyStatus = (self.moneyTF.text.length > 0 && self.numberTF.text.length > 0 && !_isFrontError && !_isRearError);
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
