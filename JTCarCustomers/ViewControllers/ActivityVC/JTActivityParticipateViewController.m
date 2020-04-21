//
//  JTActivityParticipateViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTCirlceImageView.h"
#import "JTGradientButton.h"
#import "JTActivityParticipateViewController.h"
#import "JTBaseNavigationController.h"
#import "JTActivityParticipateEditeViewController.h"

@interface JTActivityParticipateViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceConstraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceConstraint4;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *avatarViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *distanceLabels;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLB;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLB;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (copy, nonatomic) NSString *participateName;
@property (copy, nonatomic) NSString *participatePhone;
@property (assign, nonatomic) BOOL isRemind;
@property (assign, nonatomic) JTActivityJoinStatus joinStatus;

@end

@implementation JTActivityParticipateViewController

- (instancetype)initWithActivityInfo:(id)activityInfo {
    self = [super init];
    if (self) {
        _activityInfo = activityInfo;
        _participateName = [JTUserInfo shareUserInfo].userName;
        _participatePhone = [JTUserInfo shareUserInfo].userPhone;
        _joinStatus = [activityInfo[@"status"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat space = (App_Frame_Width-200)/5.0;
    self.leftSpaceConstraint1.constant = space;
    self.leftSpaceConstraint2.constant = space;
    self.leftSpaceConstraint3.constant = space;
    self.leftSpaceConstraint4.constant = space;
    
    NSArray *userList = self.activityInfo[@"user_list"];
    if (userList && [userList isKindOfClass:[NSArray class]]) {
        NSArray *list = userList.count > 4?[userList subarrayWithRange:NSMakeRange(0, 4)]:userList;
        for (int i = 0; i < list.count; i++) {
            NSDictionary *dictionary = list[i];
            UIImageView *avatarView = self.avatarViews[i];
            UILabel *distanceLB = self.distanceLabels[i];
            [avatarView sd_setImageWithURL:[NSURL URLWithString:[dictionary[@"avatar"] avatarHandleWithSquare:50]] placeholderImage:DefaultSmallAvatar];
            distanceLB.text = [NSString stringWithFormat:@"距离你%@",dictionary[@"distance"]];
        }
    }
    NSString *countStr = [NSString stringWithFormat:@"%@",self.activityInfo[@"count"]];
    self.totalCountLB.text = [NSString stringWithFormat:@"已有%@人参与活动",countStr];
    [Utility richTextLabel:self.totalCountLB fontNumber:Font(14) andRange:NSMakeRange(2, countStr.length) andColor:BlueLeverColor1];
    NSString *userInfoStr = [NSString stringWithFormat:@"%@  %@",[JTUserInfo shareUserInfo].userPhone, [JTUserInfo shareUserInfo].userName];
    NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:userInfoStr];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(15, -5, 20, 20);
    attach.image = [UIImage imageNamed:@"activity_edit_icon"];
    NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
    [atributeStr insertAttributedString:strAtt atIndex:userInfoStr.length];
    self.userInfoLB.attributedText = atributeStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tipBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isRemind = sender.isSelected;
}

- (IBAction)joinBtnClick:(JTGradientButton *)sender {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(JoinActivityApi) parameters:@{@"activity_id" : self.activityInfo[@"activity_id"], @"name" : self.participateName, @"phone" : self.participatePhone, @"remind" : @(self.isRemind)} success:^(id responseObject, ResponseState state) {
        if (responseObject[@"status"]) {
            weakSelf.joinStatus = [responseObject[@"status"] integerValue];
            [[HUDTool shareHUDTool] showHint:@"参与活动成功！" yOffset:0];
            [weakSelf dissmissViewController];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CGRect rect = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-383);
    if (CGRectContainsPoint(rect, point))
    {
        [self dissmissViewController];
    }
    else
    {
        CGPoint editePoint = [[touches anyObject] locationInView:self.contentView];
        if (CGRectContainsPoint(self.userInfoLB.frame, editePoint))
        {
            JTActivityParticipateEditeViewController *editeVC = [[JTActivityParticipateEditeViewController alloc] init];
            __weak typeof(self)weakSelf = self;
            editeVC.callBack = ^(NSString *userName, NSString *userPhone) {
                weakSelf.participateName = userName;
                weakSelf.participatePhone = userName;
                NSString *userInfoStr = [NSString stringWithFormat:@"%@  %@",userPhone, userName];
                NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:userInfoStr];
                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                attach.bounds = CGRectMake(15, -5, 20, 20);
                attach.image = [UIImage imageNamed:@"activity_edit_icon"];
                NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
                [atributeStr insertAttributedString:strAtt atIndex:userInfoStr.length];
                weakSelf.userInfoLB.attributedText = atributeStr;
            };
            [self presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:editeVC] animated:YES completion:nil];
        }
    }
    
}

- (void)dissmissViewController {
    if (self.callBack) {
        self.callBack(self.joinStatus);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
