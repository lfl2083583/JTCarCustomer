//
//  JTCreatTeamTipViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "JTCreatTeamTipViewController.h"
#import "JTCreatTeamLocationViewController.h"

@interface JTCreatTeamTipViewController ()

@property (weak, nonatomic) IBOutlet JTGradientButton *bottomBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *topLB;

@end

@implementation JTCreatTeamTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kIsIphonex?82:62;
    UITapGestureRecognizer *tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuestureEvent:)];
    tapGuester.numberOfTapsRequired = 1;
    self.topLB.userInteractionEnabled = YES;
    [self.topLB addGestureRecognizer:tapGuester];
    
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetTeamNumApi) parameters:nil success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger teamNum = [responseObject[@"can_create"] integerValue];
            weakSelf.bottomBtn.enabled = teamNum>0?YES:NO;
            [weakSelf.bottomBtn setTitle:[NSString stringWithFormat:@"当前可创建%ld个群组",teamNum] forState:UIControlStateNormal];
            NSString *tip = responseObject[@"tip"];
            NSString *str = [tip stringByReplacingOccurrencesOfString: @"\\n" withString:@"\n"];
            weakSelf.topLB.text = str;
            [Utility richTextLabel:weakSelf.topLB fontNumber:Font(12) andRange:[str rangeOfString:@"升级会员"] andColor:BlueLeverColor1];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (IBAction)createBtnClick:(JTGradientButton *)sender {
    [self.navigationController pushViewController:[[JTCreatTeamLocationViewController alloc] init] animated:YES];
}

- (void)tapGuestureEvent:(UITapGestureRecognizer *)sender {
    
}


@end
