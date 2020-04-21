//
//  JTRescueOrderViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTRescueOrderViewController.h"

@implementation JTRescueOrderModel

@end

@interface JTRescueOrderViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topView_1;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLB;
@property (weak, nonatomic) IBOutlet UILabel *projectLB;

@property (weak, nonatomic) IBOutlet UILabel *moneyLB_1;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLB_1;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLB_1;
@property (weak, nonatomic) IBOutlet UILabel *projectLB_1;

@property (weak, nonatomic) IBOutlet UILabel *modelLB;
@property (weak, nonatomic) IBOutlet UILabel *numberLB;
@property (weak, nonatomic) IBOutlet UILabel *contactsLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;

@property (weak, nonatomic) IBOutlet UIButton *alipayBT;
@property (weak, nonatomic) IBOutlet UIButton *wechatBT;
@end

@implementation JTRescueOrderViewController

- (instancetype)initWithModel:(JTRescueOrderModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"在线支付"];
    
    if (self.model.rescueType==JTRescueTypeLiftElectricity) {
        self.topView.hidden = NO;
        self.topView_1.hidden = YES;
        self.centerView.top = self.topView.bottom + 10;
        self.bottomView.top = self.centerView.bottom + 10;
        
        NSString *string = [NSString stringWithFormat:@"￥%@ 已优惠0元", self.model.price];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3 range:[string rangeOfString:@"已优惠0元"]];
        [attributedString addAttribute:NSFontAttributeName value:Font(16) range:[string rangeOfString:self.model.price]];
        self.moneyLB.attributedText = attributedString;
        self.startAddressLB.text = self.model.startAddress;
        self.projectLB.text = @"搭电";
    }
    else
    {
        self.topView.hidden = YES;
        self.topView_1.hidden = NO;
        self.centerView.top = self.topView_1.bottom + 10;
        self.bottomView.top = self.centerView.bottom + 10;
        
        NSString *string = [NSString stringWithFormat:@"￥%@ 已优惠0元", self.model.price];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BlackLeverColor3 range:[string rangeOfString:@"已优惠0元"]];
        [attributedString addAttribute:NSFontAttributeName value:Font(16) range:[string rangeOfString:self.model.price]];
        self.moneyLB_1.attributedText = attributedString;
        self.startAddressLB_1.text = self.model.startAddress;
        self.endAddressLB_1.text = self.model.endAddress;
        self.projectLB.text = @"拖车";
    }
    
    [self.modelLB setText:self.model.carName];
    [self.numberLB setText:[NSString stringWithFormat:@"%@%@", self.model.carAlias, self.model.carNumber]];
    [self.contactsLB setText:self.model.contacts];
    [self.phoneLB setText:self.model.contactsNumber];
}

- (IBAction)paymentChoice:(UIButton *)sender {
}

- (IBAction)payClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
