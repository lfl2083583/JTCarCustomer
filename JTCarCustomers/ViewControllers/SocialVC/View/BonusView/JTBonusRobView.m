//
//  JTBonusRobView.m
//  JTSocial
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTBonusRobView.h"
#import "UIView+Spring.h"

@interface JTBonusRobView ()

@property (assign, nonatomic) NSInteger requestStatus; // 0.无状态 1.请求中，2.有结果
@property (weak, nonatomic) IBOutlet ZTCirlceImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet ZTAlignmentLabel *contentLB;
@property (weak, nonatomic) IBOutlet UIButton *detailBT;
@property (weak, nonatomic) IBOutlet UIButton *robBT;

@end

@implementation JTBonusRobView

- (instancetype)initWithAttachment:(JTBonusAttachment *)attachment message:(NIMMessage *)message completionHandler:(void (^)(JTBonusStatus bonusStatus, BOOL isDisplayDetails, id data))completionHandler
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"JTBonusRobView" owner:nil options:nil] lastObject];
    if (self) {
        self.attachment = attachment;
        self.message = message;
        self.completionHandler = completionHandler;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.contentLB.verticalAlignment = VerticalAlignmentTop;
    
    self.robBT.hidden = YES;
    self.detailBT.hidden = YES;
    
    NIMUserInfo *userinfo = [[[NIMSDK sharedSDK].userManager userInfo:self.attachment.from_yxAccId] userInfo];
    if (userinfo.avatarUrl) {
        [self.avatar setAvatarByUrlString:[userinfo.avatarUrl avatarHandleWithSquare:self.avatar.height] defaultImage:DefaultSmallAvatar];
    }
    [self.nameLB setText:[JTUserInfoHandle showNick:self.attachment.from_yxAccId inSession:self.message.session]];
    if (self.attachment.type == JTBonusTypeNormal) {
        self.detailLB.text = @"给你发了一个红包";
    }
    else if (self.attachment.type == JTBonusTypeTeamLuck) {
        self.detailLB.text = @"发了一个红包，金额随机";
    }
    else
    {
        self.detailLB.text = @"给你发了一个红包";
    }
    // 红包已抢 直接显示金额
    if (self.attachment.isGrabbed) {
        self.contentLB.text = [NSString stringWithFormat:@"%@唐人币", self.attachment.money];
        self.detailBT.hidden = NO;
    }
    else
    {
        // 红包超时 提示超时信息 并且不能看红包详情
        if (self.attachment.isOverTime) {
            self.contentLB.text = @"该红包已超过24小时。如已领取，可在“我的红包”中查看";
            if ([self.attachment.fromId isEqualToString:[JTUserInfo shareUserInfo].userID]) {
                self.detailBT.hidden = NO;
            }
        }
        else
        {
            // 红包抢完，提示抢完信息，可以看红包详情
            if (self.attachment.isOverGrab) {
                self.contentLB.text = @"手慢了，红包派完了";
                self.detailBT.hidden = NO;
            }
            else
            {
                // 红包未抢，显示抢红包按钮
                self.contentLB.text = self.attachment.content;
                self.robBT.hidden = NO;
                if ([self.attachment.fromId isEqualToString:[JTUserInfo shareUserInfo].userID]) {
                    self.detailBT.hidden = NO;
                    self.robBT.top -= 20;
                }
            }
        }
    }
    if (self.robBT.subviews.count > 0) {
        for (UIView *view in self.robBT.subviews) {
            if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
                [(UIActivityIndicatorView *)view stopAnimating];
                [(UIActivityIndicatorView *)view setHidden:YES];
                [(UIActivityIndicatorView *)view removeFromSuperview];
            }
        }
    }
    [self.robBT setTitle:@"开红包" forState:UIControlStateNormal];
}

- (IBAction)robClick:(UIButton *)sender
{
    [self.robBT setTitle:nil forState:UIControlStateNormal];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.robBT.bounds];
    [activityIndicatorView setUserInteractionEnabled:YES];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicatorView setColor:RedLeverColor1];
    [self.robBT addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    __weak typeof(self) weakself = self;
    [self requestLotteryResults:^(id responseObject, ResponseState state) {

        NSInteger status = [responseObject[@"rob_status"] integerValue];
        switch (status) {
            case JTBonusStatusGrabbed:
            {
                if (self.completionHandler) {
                    self.completionHandler(JTBonusStatusGrabbed, NO, nil);
                }
                [weakself.attachment setIsGrabbed:YES];
                [weakself setNeedsDisplay];
            }
                break;
            case JTBonusStatusOverTime:
            {
                if (self.completionHandler) {
                    self.completionHandler(JTBonusStatusOverTime, NO, nil);
                }
                [weakself.attachment setIsOverTime:YES];
                [weakself setNeedsDisplay];
            }
                break;
            case JTBonusStatusOverGrab:
            {
                if (self.completionHandler) {
                    self.completionHandler(JTBonusStatusOverGrab, NO, nil);
                }
                [weakself.attachment setIsOverGrab:YES];
                [weakself setNeedsDisplay];
            }
                break;
            case JTBonusStatusGrabFailure:
            {
                [[HUDTool shareHUDTool] showHint:@"抢红包失败，请重新抢"];
                [weakself setNeedsDisplay];
            }
                break;
            case JTBonusStatusGrabSuccess:
            {
                if ([responseObject objectForKey:@"packet"]) {
                    if (self.completionHandler) {
                        self.completionHandler(JTBonusStatusGrabSuccess, YES, [responseObject objectForKey:@"packet"]);
                    }
                    [JTUserInfo shareUserInfo].userBalance += [responseObject[@"rob_amount"] integerValue];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBalanceNotification object:nil];
                }
                else
                {
                    [[HUDTool shareHUDTool] showHint:@"抢红包成功，数据返回失败"];
                }
                [weakself.superview.superview dismissViewAnimated:YES completion:nil];
            }
                break;
            default:
                break;
        }

    } failure:^(NSError *error) {
        [weakself setNeedsDisplay];
    }];
}

- (IBAction)detailClick:(id)sender {
    self.completionHandler(JTBonusStatusLookDetail, YES, nil);
    [self.superview.superview dismissViewAnimated:YES completion:nil];
}

- (void)requestLotteryResults:(void (^)(id responseObject, ResponseState state))success failure:(void (^)(NSError *error))failure
{
    NSString *toID = (self.message.session.sessionType == NIMSessionTypeP2P) ? self.attachment.fromId : self.message.session.sessionId;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(RobPacketApi) parameters:@{@"packet_id": self.attachment.bonusId, @"type": @(self.attachment.type), @"toid": toID} success:^(id responseObject, ResponseState state) {
        success(responseObject, state);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
