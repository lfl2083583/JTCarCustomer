//
//  JTActivityDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTShareTool.h"
#import "JTMessageMaker.h"

#import "ZTSimpleWebView.h"
#import "JTActivityCardView.h"

#import "JTTeamInfoViewController.h"
#import "JTSessionViewController.h"
#import "JTActivityDetailBottomView.h"
#import "JTActivityNavViewController.h"
#import "JTBaseNavigationController.h"
#import "JTActivityCommentViewController.h"
#import "JTActivityDetailViewController.h"
#import "JTActivityParticipateViewController.h"
#import "JTContracSelectViewController.h"
#import "JTTeamSelectViewController.h"

@interface JTActivityDetailViewController () <JTActivityDetailBottomViewDelegate>
{
    NSString *_activityID;
}

@property (nonatomic, strong) JTActivityDetailBottomView *activityBottomView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *moreImgeView;
@property (nonatomic, strong) ZTSimpleWebView *webView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *loctionBtn;

@property (nonatomic, strong) UITapGestureRecognizer *tapGuester;
@property (nonatomic, strong) UIPanGestureRecognizer *panGuester;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) JTActivityJoinStatus joinStatus;
@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) NSInteger forwardCount;


@end

@implementation JTActivityDetailViewController

- (void)dealloc {
    CCLOG(@"JTActivityDetailViewController释放了");
}

- (instancetype)initWithActivityID:(NSString *)activityID {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _activityID = activityID;
    }
    return self;
}

- (instancetype)initWithActivityID:(NSString *)activityID showComment:(BOOL)showComment {
    self = [self initWithActivityID:activityID];
    if (self) {
        _showComment = showComment;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.moreImgeView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.rightBtn];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:self.tapGuester];
    [self.view addGestureRecognizer:self.panGuester];

    if (self.showComment) {
        [self commentActivity];
    }
    [self requestActivityDetailData];
    
}

- (void)requestActivityDetailData {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetActivityInfoApi) parameters:@{@"activity_id" : _activityID} success:^(id responseObject, ResponseState state) {
        weakSelf.activityInfo = responseObject;
        weakSelf.commentCount = [responseObject[@"comment"] integerValue];
        weakSelf.collectCount = [responseObject[@"favorite"] integerValue];
        weakSelf.forwardCount = [responseObject[@"share"] integerValue];
        weakSelf.isCollect = [responseObject[@"is_favorite"] boolValue];
        weakSelf.joinStatus = [responseObject[@"status"] integerValue];
        weakSelf.session = [NIMSession session:[NSString stringWithFormat:@"%@",responseObject[@"group_id"]] type:NIMSessionTypeTeam];
        [weakSelf refreshUI];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setY:APP_Frame_Height];
        weakSelf.rightBtn.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)refreshUI {
    [self configJoinBtnStatus];
    UIImage *collectImg = _isCollect?[UIImage imageNamed:@"focus_seleted_icon"]:[UIImage imageNamed:@"activity_follow_icon"];
    [self.activityBottomView.collectBtn setImage:collectImg forState:UIControlStateNormal];
    [self.activityBottomView.commentBtn setTitle:[self handleActivityCount:self.commentCount] forState:UIControlStateNormal];
    [self.activityBottomView.collectBtn setTitle:[self handleActivityCount:self.collectCount] forState:UIControlStateNormal];
    [self.activityBottomView.forwardBtn setTitle:[self handleActivityCount:self.forwardCount] forState:UIControlStateNormal];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.activityInfo[@"image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)configJoinBtnStatus {
    switch (self.joinStatus) {
        case JTActivityJoinStatusNormal:
            [self.activityBottomView.joinBtn setTitle:@"参与活动" forState:UIControlStateNormal];
            [self.activityBottomView.joinBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.activityBottomView.joinBtn.backgroundColor = BlueLeverColor1;
            break;
        case JTActivityJoinStatusAudit:
            [self.activityBottomView.joinBtn setTitle:@"加入活动群聊" forState:UIControlStateNormal];
            [self.activityBottomView.joinBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
            self.activityBottomView.joinBtn.backgroundColor = BlackLeverColor1;
            break;
        case JTActivityJoinStatusFinish:
            [self.activityBottomView.joinBtn setTitle:@"活动已结束" forState:UIControlStateNormal];
            [self.activityBottomView.joinBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
            self.activityBottomView.joinBtn.backgroundColor = BlackLeverColor1;
            break;
        case JTActivityJoinStatusJoined:
            [self.activityBottomView.joinBtn setTitle:@"进入活动群聊" forState:UIControlStateNormal];
            [self.activityBottomView.joinBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
            self.activityBottomView.joinBtn.backgroundColor = BlackLeverColor1;
            break;
        default:
            break;
    }
}

- (void)loctionBtnClick:(UIButton *)sender {
    if ([self determineUserLoginStatus]) {
        [self presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:[[JTActivityNavViewController alloc] initWithLocation:[self.activityInfo[@"lat"] doubleValue] longitude:[self.activityInfo[@"lng"] doubleValue] title:self.activityInfo[@"address"]]] animated:YES completion:nil];
    }
}

#pragma mark JTActivityDetailBottomViewDelegate
- (void)joinActivityTeam {
    if ([self determineUserLoginStatus]) {
        __weak typeof(self)weakSelf = self;
        switch (self.joinStatus) {
            case JTActivityJoinStatusNormal:
            {
                JTActivityParticipateViewController *activityParticipateVC = [[JTActivityParticipateViewController alloc] initWithActivityInfo:self.activityInfo];
                activityParticipateVC.callBack = ^(JTActivityJoinStatus joinStatus) {
                    weakSelf.joinStatus = joinStatus;
                    [weakSelf configJoinBtnStatus];
                };
                activityParticipateVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
                activityParticipateVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:activityParticipateVC animated:YES completion:nil];
            }
                break;
            case JTActivityJoinStatusAudit:
            {
                __weak typeof(self)weakSelf = self;
                [[NIMSDK sharedSDK].teamManager fetchTeamInfo:self.session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
                    [weakSelf.navigationController pushViewController:[[JTJoinTeamViewController alloc] initWithTeam:team teamSource:JTTeamSourceFromActivity inviteID:nil] animated:YES];
                }];
                
            }
                break;
            case JTActivityJoinStatusFinish:
            {
                [[HUDTool shareHUDTool] showHint:@"活动已结束" yOffset:0];
            }
                break;
            case JTActivityJoinStatusJoined:
            {
                JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:self.session];
                if (self.tabBarController.selectedIndex == 0) {
                    sessionVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sessionVC animated:YES];
                    UIViewController *root = self.navigationController.viewControllers[0];
                    self.navigationController.viewControllers = @[root, sessionVC];
                }
                else
                {
                    [self.tabBarController setSelectedIndex:0];
                    [[self.tabBarController.selectedViewController topViewController] setHidesBottomBarWhenPushed:YES];
                    [sessionVC setHidesBottomBarWhenPushed:YES];
                    [self.tabBarController.selectedViewController pushViewController:sessionVC animated:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)commentActivity {
    if ([self determineUserLoginStatus]) {
        __weak typeof(self)weakSelf = self;
        JTActivityCommentViewController *activityCommentVC = [[JTActivityCommentViewController alloc] initWithActivityID:_activityID];
        activityCommentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        activityCommentVC.callBack = ^(NSInteger totalCount) {
            weakSelf.commentCount = totalCount;
            [weakSelf refreshUI];
        };
        activityCommentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:activityCommentVC animated:YES completion:nil];
    }
}

- (void)collectActivity {
    if ([self determineUserLoginStatus]) {
        __weak typeof(self)weakSelf = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ActivityFavoriteApi) parameters:@{@"activity_id" : _activityID} success:^(id responseObject, ResponseState state) {
            weakSelf.isCollect = !weakSelf.isCollect;
            UIImage *collectImg = weakSelf.isCollect?[UIImage imageNamed:@"focus_seleted_icon"]:[UIImage imageNamed:@"activity_follow_icon"];
            [weakSelf.activityBottomView.collectBtn setImage:collectImg forState:UIControlStateNormal];
            weakSelf.isCollect?weakSelf.collectCount++:weakSelf.collectCount--;
            [weakSelf refreshUI];
            NSString *tip = weakSelf.isCollect?@"收藏成功":@"取消收藏成功";
            [[HUDTool shareHUDTool] showHint:tip yOffset:0];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)forwardActivity {
    if ([self determineUserLoginStatus]) {
        __weak typeof(self)weakSelf = self;
        NSString *describe = [NSString stringWithFormat:@"%@约你在%@参加%@活动", self.activityInfo[@"initiator"], self.activityInfo[@"time"], self.activityInfo[@"theme"]];
        [JTShareTool instance].shareContentType = JTShareContentTypeUrl;
        [[JTShareTool instance] shareInfo:@{ShareUrl : self.activityInfo[@"h5_share"], ShareTitle : @"邀请你参加活动", ShareDescribe : describe, ShareThumbURL : self.activityInfo[@"image"]} result:^(NSError *error, JTSharePlatformType platformType) {
            NIMMessage *activityMessage = [JTMessageMaker messageWithActivity:_activityID coverUrl:weakSelf.activityInfo[@"image"] theme:weakSelf.activityInfo[@"theme"] time:weakSelf.activityInfo[@"time"] address:weakSelf.activityInfo[@"address"]];
            if (platformType == JTSharePlatformTypeFriend) {
                JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
                config.contactSelectType = JTContactSelectTypeShareActivity;
                config.needMutiSelected = NO;
                config.source = weakSelf.activityInfo;
                JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
                userListVC.callBack = ^(NSArray *yunxinIDs, NSArray *userIDs, NSString *content) {
                    if ([[NIMSDK sharedSDK].chatManager sendMessage:activityMessage toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil]) {
                        [weakSelf handleShareSuccess:2];
                    }
                    if (content && [content isKindOfClass:[NSString class]] && content.length) {
                        NIMMessage *message = [JTMessageMaker messageWithText:content];
                        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil];
                    }
                    
                };
                JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
                [weakSelf presentViewController:navigationController animated:YES completion:nil];
            }
            else if (platformType == JTSharePlatformTypeTeam)
            {
                JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
                config.contactSelectType = JTContactSelectTypeShareActivity;
                config.needMutiSelected = NO;
                config.source = weakSelf.activityInfo;
                JTTeamSelectViewController *teamListVC = [[JTTeamSelectViewController alloc] initWithConfig:config];
                teamListVC.callBack = ^(NSArray *teamIDs, NSString *content) {
                    if ([[NIMSDK sharedSDK].chatManager sendMessage:activityMessage toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil]) {
                        [weakSelf handleShareSuccess:1];
                    }
                    if (content && [content isKindOfClass:[NSString class]] && content.length) {
                        NIMMessage *message = [JTMessageMaker messageWithText:content];
                        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil];
                    }
                    
                };
                JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:teamListVC];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
            else
            {
                if (!error) {
                    
                    [weakSelf handleShareSuccess:platformType+3];
                }
            }
            
        }];
    }
}

- (void)handleShareSuccess:(NSInteger)flag {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ShareStatisticsApi) parameters:@{@"type" : @(flag), @"receiver" : @(0), @"obj_type" : @(1), @"obj_id" : _activityID} success:^(id responseObject, ResponseState state) {
        weakSelf.forwardCount++;
        [weakSelf refreshUI];
        [[HUDTool shareHUDTool] showHint:@"分享成功！" yOffset:0];
        
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)determineUserLoginStatus
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        return YES;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
    return NO;
}

#pragma mark UITapGestureRecognizer | UIPanGestureRecognizer
- (void)tapGuesterAction:(UITapGestureRecognizer *)sender {
    if (!self.rightBtn.hidden) return;
    __weak typeof(self)weakSelf = self;
    CGPoint point = [sender locationInView:self.view];
    if (CGRectContainsPoint(self.moreImgeView.frame, point))
    {
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.contentView setY:114];
            weakSelf.rightBtn.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        if (self.callBack) {
            self.callBack();
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)panGuesterAction:(UIPanGestureRecognizer *)sender {
    CGPoint point= [sender locationInView:self.view];
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                CGPoint velocity = [sender velocityInView:self.view];
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    float dy = point.y-self.currentPoint.y;
                    int index = (int)dy;
                    if (-index <= APP_Frame_Height-114) {
                        [self.contentView setY:APP_Frame_Height+index];
                    }
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (direction == UIPanGestureRecognizerDirectionUp) {
                __weak typeof(self)weakSelf = self;
                [UIView animateWithDuration:0.2 animations:^{
                    [weakSelf.contentView setY:114];
                    [weakSelf.rightBtn setHidden:NO];
                }];
            }
            direction = UIPanGestureRecognizerDirectionUndefined;
            break;
        }
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.currentPoint = [[touches anyObject] locationInView:self.view];
}

- (NSString *)handleActivityCount:(NSInteger)activityCount {
    if (activityCount > 1000) {
        return [NSString stringWithFormat:@"%01fk",activityCount/1000.0];
    } else {
        return [NSString stringWithFormat:@"%ld",activityCount];
    }
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(App_Frame_Width-60, kStatusBarHeight, 40, 40)];
        [_rightBtn setImage:[UIImage imageNamed:@"activity_close_icon"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, App_Frame_Width, APP_Frame_Height-100)];
        _contentView.backgroundColor = WhiteColor;
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.masksToBounds = YES;
        [_contentView addSubview:self.webView];
        [_contentView addSubview:self.loctionBtn];
        [_contentView addSubview:self.activityBottomView];
    }
    return _contentView;
}

- (JTActivityDetailBottomView *)activityBottomView {
    if (!_activityBottomView) {
        _activityBottomView = [[[NSBundle mainBundle] loadNibNamed:@"JTActivityDetailBottomView" owner:nil options:nil] firstObject];
        [_activityBottomView setY:CGRectGetHeight(_contentView.frame)-55];
        [_activityBottomView setX:0];
        _activityBottomView.layer.shadowColor = BlackLeverColor6.CGColor;
        _activityBottomView.layer.shadowOpacity = 0.8;
        _activityBottomView.layer.shadowOffset = CGSizeMake(2, 2);
        _activityBottomView.delegate = self;
    }
    return _activityBottomView;
}

- (ZTSimpleWebView *)webView {
    if (!_webView) {
        _webView = [[ZTSimpleWebView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, CGRectGetHeight(_contentView.frame)-55) urlString:self.activityInfo[@"h5_url"]];
        _webView.normalColor = WhiteColor;
    }
    return _webView;
}

- (UIButton *)loctionBtn {
    if (!_loctionBtn) {
        _loctionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)-85, 15, 70, 70)];
        _loctionBtn.titleLabel.font = Font(12);
        [_loctionBtn setImage:[UIImage imageNamed:@"activity_loction_icon"] forState:UIControlStateNormal];
        [_loctionBtn setTitle:@"查看导航" forState:UIControlStateNormal];
        [_loctionBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        _loctionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_loctionBtn setTitleEdgeInsets:UIEdgeInsetsMake(_loctionBtn.imageView.frame.size.height+10 , -_loctionBtn.imageView.frame.size.width, 0.0,0.0)];
        [_loctionBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0, 5.0, 0.0, -_loctionBtn.titleLabel.bounds.size.width)];
        [_loctionBtn addTarget:self action:@selector(loctionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loctionBtn;
}

- (UIImageView *)moreImgeView {
    if (!_moreImgeView) {
        _moreImgeView = [[UIImageView alloc] initWithFrame:CGRectMake((App_Frame_Width-60)/2.0, APP_Frame_Height-45, 60, 30)];
        _moreImgeView.image = [UIImage imageNamed:@"activity_more_icon"];
    }
    return _moreImgeView;;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.view.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UITapGestureRecognizer *)tapGuester {
    if (!_tapGuester) {
        _tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuesterAction:)];
        _tapGuester.numberOfTapsRequired = 1;
    }
    return _tapGuester;
}

- (UIPanGestureRecognizer *)panGuester {
    if (!_panGuester) {
        _panGuester = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGuesterAction:)];
    }
    return _panGuester;
}

@end
