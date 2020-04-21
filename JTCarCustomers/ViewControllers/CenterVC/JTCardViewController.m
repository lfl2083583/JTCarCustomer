//
//  JTCardViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTMessageMaker.h"
#import "ZTTableView.h"
#import "JTNormalUserInfo.h"
#import "JTBulletInputView.h"
#import "JTCardViewHeadView.h"
#import "JTCardUserInfoCell.h"
#import "JTCardBottomView.h"
#import "JTNavigationBar.h"
#import "JTUserInfoHandle.h"
#import "JTUserFeatureTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

#import "JTCardViewController.h"
#import "JTSessionViewController.h"
#import "JTUserInfoViewController.h"
#import "JTPersonInfoViewController.h"
#import "JTBaseNavigationController.h"
#import "JTTeamSelectViewController.h"
#import "JTContracSelectViewController.h"
#import "JTBulletCenterViewController.h"
#import "JTGarageDynamicContainerViewController.h"
#import "JTPersonalViewController.h"

static NSString *normalIdentifier = @"normalIdentifier";
static NSString *customIdentifier = @"customIdentifier";

@interface JTCardViewController () <UITableViewDelegate, UITableViewDataSource, JTNavigationBarDelegate, JTCardBottomViewDelegate, JTBulletMenuDelegate, UIScrollViewDelegate, JTGarageDynamicContainerViewControllerDelegate>
{
    BOOL isOwner;
    BOOL isFollowed;
    NSArray *tags;
    NSString *userName;
}

@property (nonatomic, strong) ZTTableView *tableview;
@property (nonatomic, strong) JTBulletInputView *bulletInputView;
@property (nonatomic, strong) JTCardViewHeadView *headView;
@property (nonatomic, strong) JTCardBottomView *bottomView;
@property (nonatomic, strong) JTCardNavigationBar *nagationBar;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JTNormalUserInfo *userInfo;
@property (nonatomic, assign) BOOL isBlack;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@end

@implementation JTCardViewController

- (void)dealloc {
    CCLOG(@"JTCardViewController销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLeaveTopNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserInfoUpdateNotificationName object:nil];
}

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        _userID = userID;
        isOwner = NO;
    }
    return self;
}

- (instancetype)initWithUserID:(NSString *)userID teamID:(NSString *)teamID {
    self = [super init];
    if (self) {
        _userID = userID;
        _teamID = teamID;
        isOwner = NO;
        _isBlack = NO;
        if (teamID) {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:teamID];
            if ([team.owner isEqualToString:[JTUserInfo shareUserInfo].userYXAccount]) {
                isOwner = YES;
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    self.tableview.tableHeaderView = self.headView;
    [self.tableview registerClass:[JTCardUserInfoCell class] forCellReuseIdentifier:cardUserInfoIdentifier];
    [self.tableview registerClass:[JTUserFeatureTableViewCell class] forCellReuseIdentifier:userfeatureCellIdentifier];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:customIdentifier];
    [self.view addSubview:self.nagationBar];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.bulletInputView];
    [self refreshUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptScrollerViewMsg:) name:kLeaveTopNotificationName object:nil];
    if ([[JTUserInfo shareUserInfo].userID isEqualToString:self.userID]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdateNotification:) name:kUserInfoUpdateNotificationName object:nil];
    }
}

- (void)refreshUserInfo {
    tags = [NSArray array];
    __weak typeof (self)weakSelf = self;
    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
    [progem setValue:self.userID forKey:@"uid"];
    if (self.teamID) {
        [progem setValue:self.teamID forKey:@"group_id"];
    }
    
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserInfoApi) parameters:progem cacheEnabled:YES success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            JTNormalUserInfo *info = [JTNormalUserInfo mj_objectWithKeyValues:responseObject];
            userName = info.userName;
            BOOL black = [[NIMSDK sharedSDK].userManager isUserInBlackList:info.userYXAccount];
            weakSelf.isBlack = (black && black == YES)?YES:NO;
            weakSelf.userInfo = info;
            weakSelf.yunXinID = info.userYXAccount;
            
            if (info.followType) {
                JTUserContactType contractType = info.followType;
                isFollowed = (contractType == JTUserContactTypeFriends || contractType == JTUserContactTypeFocus)?YES:NO;
            }
            if ([weakSelf.userID isEqualToString:[JTUserInfo shareUserInfo].userID] && info.characterTags)
            {
                tags = info.characterTags;
            }
            else if (![weakSelf.userID isEqualToString:[JTUserInfo shareUserInfo].userID] && info.userSameTags)
            {
                tags = info.userSameTags;
            }
            [weakSelf refreshCardView];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)refreshCardView {
    JTWordItem *item1 = [self creatItemWithIndentify:cardUserInfoIdentifier];
    JTWordItem *item2 = [self creatItemWithIndentify:normalIdentifier];
    JTWordItem *item3 = [self creatItemWithIndentify:userfeatureCellIdentifier];
    JTWordItem *item4 = [self creatItemWithIndentify:garageDynamicCellIdentifier];
    self.dataArray = [NSMutableArray arrayWithArray:@[item1]];
    if (tags.count) {
        [self.dataArray insertObject:item3 atIndex:1];
    }
    if (isOwner && ![self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]) {
        [self.dataArray insertObject:item2 atIndex:1];
    }
    [self.dataArray addObject:item4];
    NSString *btnTitle = isFollowed?@"取消关注":@"关注";
    UIImage *image = isFollowed?[UIImage imageNamed:@"focus_seleted_icon"]:[UIImage imageNamed:@"focus_icon"];
    UIColor *titleColor = isFollowed?BlueLeverColor1:BlackLeverColor5;
    [self.bottomView.rightBtn setEnabled:YES];
    [self.bottomView.rightBtn setImage:image forState:UIControlStateNormal];
    [self.bottomView.rightBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.bottomView.rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.bottomView.centerBtn setHidden:[self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]?NO:!_isBlack];
    [self.headView configHeadViewImgs:self.userInfo.userAblum.allValues avatarUrl:self.userInfo.userAvatar];
    [self.tableview reloadData];
}

- (JTWordItem *)creatItemWithIndentify:(NSString *)indentify {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.tagID = indentify;
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.section];
    if ([item.tagID isEqualToString:cardUserInfoIdentifier])
    {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customIdentifier];
            cell.backgroundColor = BlackLeverColor1;
            cell.preservesSuperviewLayoutMargins = NO;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            return cell;
        } else {
            JTCardUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cardUserInfoIdentifier];
            [cell configCellWithUserInfo:self.userInfo];
            return cell;
        }
    }
    else if ([item.tagID isEqualToString:normalIdentifier])
    {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customIdentifier];
            cell.backgroundColor = BlackLeverColor1;
            cell.preservesSuperviewLayoutMargins = NO;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor = BlackLeverColor6;
                cell.textLabel.font = Font(16);
            }
            if (self.userInfo.joinGroupType == JoinGroupTypeInvite) {
                NSString *nikeName = self.userInfo.inviteInfo[@"nick_name"]?self.userInfo.inviteInfo[@"nick_name"]:@"";
                NSString *str = [NSString stringWithFormat:@"进群方式  %@邀请进群",nikeName];
                cell.textLabel.text = str;
                [Utility richTextLabel:cell.textLabel fontNumber:Font(16) andRange:[str rangeOfString:nikeName] andColor:BlueLeverColor1];
            }
            else if (self.userInfo.joinGroupType == JoinGroupTypeQr)
            {
                cell.textLabel.text = @"进群方式  扫二维码进入群聊";
            }
            else if (self.userInfo.joinGroupType == JoinGroupTypeActivity)
            {
                cell.textLabel.text = @"进群方式  参加活动加入群聊";
            }
            else if (self.userInfo.joinGroupType == JoinGroupTypeApply)
            {
                cell.textLabel.text = @"进群方式  个人申请加入群聊";
            }
            return cell;
        }
    }
    else if ([item.tagID isEqualToString:userfeatureCellIdentifier])
    {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customIdentifier];
            cell.backgroundColor = BlackLeverColor1;
            cell.preservesSuperviewLayoutMargins = NO;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            return cell;
        } else {
            JTUserFeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userfeatureCellIdentifier];
            cell.tags = tags;
            NSString *content = [NSString stringWithFormat:@"我们有%ld个共同点",tags.count];
            NSString *num = [NSString stringWithFormat:@"%ld",tags.count];
            cell.topLabel.text = content;
            cell.topLabel.text = [self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]?@"我的标签":content;
            if (![self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]) {
                [Utility richTextLabel:cell.topLabel fontNumber:Font(16) andRange:NSMakeRange(3, num.length) andColor:BlueLeverColor1];
            }
            cell.isRandColor = YES;
            cell.rightLable.hidden = [self.userID isEqualToString:[JTUserInfo shareUserInfo].userID];
            cell.rightImgeView.hidden = [self.userID isEqualToString:[JTUserInfo shareUserInfo].userID];
            [cell reloadData];
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customIdentifier];
            cell.backgroundColor = BlackLeverColor1;
            cell.preservesSuperviewLayoutMargins = NO;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:garageDynamicCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:garageDynamicCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                JTGarageDynamicContainerViewController *subCell = [[JTGarageDynamicContainerViewController alloc] init];
                subCell.parentController = self;
                subCell.delegate = self;
                [cell.contentView addSubview:subCell.view];
                [subCell.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell.contentView);
                }];
            }
            return cell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JTWordItem *item = self.dataArray[indexPath.section];
    if (indexPath.row == 1)
    {
        return 10;
    }
    else
    {
        if ([item.tagID isEqualToString:cardUserInfoIdentifier])
        {
            __weak typeof(self)weakSelf = self;
            return [tableView fd_heightForCellWithIdentifier:cardUserInfoIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
                [cell configCellWithUserInfo:weakSelf.userInfo];
            }];
        }
        else if ([item.tagID isEqualToString:garageDynamicCellIdentifier])
        {
            return APP_Frame_Height-kStatusBarHeight-kTopBarHeight-50;
        }
        else if ([item.tagID isEqualToString:userfeatureCellIdentifier])
        {
            return [JTUserFeatureTableViewCell getCellHeightWithTags:tags width:tableView.frame.size.width];
        }
        else
        {
            return 60;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.section];
    if ([item.tagID isEqualToString:userfeatureCellIdentifier] && ![self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]) {
        [self.navigationController pushViewController:[[JTPersonInfoViewController alloc] initWithUserInfo:self.userInfo] animated:YES];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.bulletInputView.leftTF resignFirstResponder];
    self.nagationBar.bottomView.alpha = scrollView.contentOffset.y / App_Frame_Width;
    self.nagationBar.backgroundColor = RGBCOLOR(255, 255, 255, scrollView.contentOffset.y / App_Frame_Width);
    self.nagationBar.titleLB.text = (scrollView.contentOffset.y > App_Frame_Width)?userName:@"";
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < 0)
    {
        CGFloat totalOffset = App_Frame_Width + fabs(offsetY);
        CGFloat f = totalOffset / App_Frame_Width;
        self.headView.carouselView.frame = CGRectMake(-(width *f-width) / 2.0, offsetY, width * f, totalOffset);
    }
    
    if (self.dataArray.count >= 1)
    {
        CGFloat tabOffsetY = [self.tableview rectForSection:self.dataArray.count-1].origin.y - kStatusBarHeight - kTopBarHeight;
        _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
        
        if (offsetY >= tabOffsetY)
        {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            _isTopIsCanNotMoveTabView = YES;
        }
        else
        {
            _isTopIsCanNotMoveTabView = NO;
        }
        
        if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre)
        {
            if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView)//滑动到顶端
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
                _canScroll = NO;
            }
            if (_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView)//离开顶端
            {
                if (!_canScroll && scrollView == self.tableview)
                {
                    scrollView.contentOffset = CGPointMake(0, tabOffsetY);
                }
            }
        }
    }
}

#pragma mark NSNotification
- (void)acceptScrollerViewMsg:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)userInfoUpdateNotification:(NSNotification *)notification {
    [self refreshUserInfo];
}

#pragma mark JTNavigationBarDelegate
- (void)navigationBarToLeft:(id)navigationBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarToRight:(id)navigationBar {
    if ([self.userID isEqualToString:[JTUserInfo shareUserInfo].userID])
    {
        [self.navigationController pushViewController:[[JTBulletCenterViewController alloc] initWithUserID:self.userID] animated:YES];
    }
    else
    {
        __weak typeof(self) weakself = self;
        UIAlertController *alertMore = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertMore addAction:[UIAlertAction actionWithTitle:@"发送名片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alertOther = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertOther addAction:[UIAlertAction actionWithTitle:@"个人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself sendCardWithSessionType:NIMSessionTypeP2P];
            }]];
            [alertOther addAction:[UIAlertAction actionWithTitle:@"群聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself sendCardWithSessionType:NIMSessionTypeTeam];
            }]];
            [alertOther addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [weakself presentViewController:alertOther animated:YES completion:nil];
        }]];
        [alertMore addAction:[UIAlertAction actionWithTitle:_isBlack?@"取消拉黑":@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself setBlackPerson];
        }]];
        [alertMore addAction:[UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself complainPerson];
        }]];
        [alertMore addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertMore animated:YES completion:nil];
    }
}

#pragma mark 投诉
- (void)complainPerson {
    __weak typeof(self) weakself = self;
    NSArray *titles = @[@"政治谣言", @"内容违规", @"昵称、签名内容违规", @"广告", @"色情传播", @"非法传销"];
    UIAlertController *alertMore = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *title in titles) {
        [alertMore addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserComplaintsApi) parameters:@{@"object_type" : @"1", @"object" : weakself.userID, @"content" : action.title, @"type" : @"1"} success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"投诉成功，官方会在3个工作日核实处理" yOffset:0];
            } failure:^(NSError *error) {
                
            }];
        }]];
    }
    [alertMore addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertMore animated:YES completion:nil];
}

#pragma mark 发送名片
- (void)sendCardWithSessionType:(NIMSessionType)sessionType {
    NIMMessage *cardMessage = [JTMessageMaker messageWithCard:self.yunXinID];
    if (sessionType == NIMSessionTypeP2P) {
        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeRepeatMessage;
        config.needMutiSelected = NO;
        config.source = cardMessage;
        JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
        userListVC.callBack = ^(NSArray *yunxinIDs, NSArray *userIDs, NSString *content) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:cardMessage toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
            if (content && [content isKindOfClass:[NSString class]] && content.length) {
                NIMMessage *message = [JTMessageMaker messageWithText:content];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil];
            }
            
        };
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
        config.contactSelectType = JTContactSelectTypeRepeatMessage;
        config.needMutiSelected = NO;
        config.source = cardMessage;
        JTTeamSelectViewController *teamListVC = [[JTTeamSelectViewController alloc] initWithConfig:config];
        teamListVC.callBack = ^(NSArray *teamIDs, NSString *content) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:cardMessage toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
            if (content && [content isKindOfClass:[NSString class]] && content.length) {
                NIMMessage *message = [JTMessageMaker messageWithText:content];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil];
            }
        };
        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:teamListVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark 设置黑名单
- (void)setBlackPerson {
    __weak typeof(self) weakself = self;
    if (!_isBlack)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"拉黑此人后，TA无法给你发消息，确定要拉黑吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself requestForBlack];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
        [self requestForBlack];
    }
}

- (void)requestForBlack {
    NSString *tip = _isBlack?@"取消拉黑成功":@"拉黑成功";
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SetBlackApi) parameters:@{@"fid" : self.userID, @"type" : @(!_isBlack)} success:^(id responseObject, ResponseState state) {
        _isBlack = !_isBlack;
        [weakSelf.bottomView.centerBtn setHidden:!_isBlack];
        [[HUDTool shareHUDTool] showHint:tip yOffset:0];
    } failure:^(NSError *error) {
        
    }];
}
    
#pragma mark JTCardBottomViewDelegate
#pragma mark 进入聊天会话
- (void)bottomViewToLeft:(id)sender {
    if (self.yunXinID) {
        __weak typeof(self)weakSelf = self;
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:self.yunXinID];
        if (!user.userInfo.nickName) {
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[self.yunXinID] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (users) {
                    [weakSelf handleConversation];
                }
            }];
        } else {
           [weakSelf handleConversation];
        }
    }
}

#pragma mark 关注/取消关注
- (void)bottomViewToRight:(id)sender {
    NSString *msg = isFollowed?@"取消关注成功":@"关注成功";
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(FocusApi) parameters:@{@"fid" : self.userID, @"type" : @(!isFollowed)} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:msg yOffset:0];
        isFollowed = !isFollowed;
        [weakSelf refreshCardView];
        NIMSession *session = [NIMSession session:self.yunXinID type:NIMSessionTypeP2P];
        [[NIMSDK sharedSDK].conversationManager saveMessage:[JTMessageMaker messageWithFuns:userName yunxinId:weakSelf.yunXinID type:1 time:@"null"]
                                                 forSession:session
                                                 completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTUserInfoUpdatedNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark JTBulletMenuDelegate
#pragma mark 发送弹幕
- (void)bulletMenuResponse:(JTBulletFuctionType)fucType {
    if (fucType == JTBulletSendMsg) {
        [self.bulletInputView.leftTF becomeFirstResponder];
    }
}

#pragma mark 编辑资料
- (void)bottomViewToCenter:(id)sender {
    if ([[(UIButton *)sender titleLabel].text isEqualToString:@"编辑资料"]) {
        
        [self.navigationController pushViewController:[[JTUserInfoViewController alloc] init] animated:YES];
    } else {
         [self requestForBlack];
    }
}

- (void)handleConversation {
    NIMSession *session = [NIMSession session:self.yunXinID type:NIMSessionTypeP2P];
    JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
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

- (void)callBack {
JTPersonalViewController *vc = [[JTPersonalViewController alloc] init];
[self.navigationController pushViewController:vc animated:YES];
}

- (JTCardViewHeadView *)headView {
    if (!_headView) {
        _headView = [[JTCardViewHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, App_Frame_Width) fuid:self.userID];
        _headView.delegate = self;
    }
    return _headView;
}

- (JTCardBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[JTCardBottomView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-50, App_Frame_Width, 50)];
        _bottomView.topView.hidden = [self.userID isEqualToString:[JTUserInfo shareUserInfo].userID];
        _bottomView.delegate = self;
        [_bottomView.rightBtn setEnabled:NO];
        [_bottomView.centerBtn setHidden:![self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]];
        NSString *title = [self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]?@"编辑资料":@"取消拉黑";
        [_bottomView.centerBtn setTitle:title forState:UIControlStateNormal];
        [_bottomView.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_bottomView.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_bottomView.leftBtn setImage:[UIImage imageNamed:@"dialog_icon"] forState:UIControlStateNormal];
        [_bottomView.rightBtn setImage:[UIImage imageNamed:@"focus_icon"] forState:UIControlStateNormal];
        [_bottomView.leftBtn setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_bottomView.rightBtn setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [_bottomView.leftBtn setTitle:@"对话" forState:UIControlStateNormal];
        [_bottomView.rightBtn setTitle:@"关注" forState:UIControlStateNormal];
        
    }
    return _bottomView;
}

- (JTCardNavigationBar *)nagationBar {
    if (!_nagationBar) {
        _nagationBar = [[JTCardNavigationBar alloc] init];
        _nagationBar.frame = CGRectMake(0, 0, App_Frame_Width, kTopBarHeight+kStatusBarHeight);
        _nagationBar.bottomView.alpha = 0;
        _nagationBar.delegate = self;
        _nagationBar.leftBT.hidden = NO;
        if (![self.userID isEqualToString:[JTUserInfo shareUserInfo].userID]) {
             [_nagationBar.rightBT setImage:[UIImage imageNamed:@"nav_more_bottom"] forState:UIControlStateNormal];
        } else {
            [_nagationBar.rightBT setTitle:@"弹幕中心" forState:UIControlStateNormal];
        }
    }
    return _nagationBar;
}

- (JTBulletInputView *)bulletInputView {
    if (!_bulletInputView) {
        _bulletInputView = [[JTBulletInputView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, 50) fuid:self.userID];
    }
    return _bulletInputView;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[ZTTableView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height - 50) style:UITableViewStylePlain];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorColor = BlackLeverColor2;
        _tableview.tableFooterView = [UIView new];
    }
    return _tableview;
}
@end

