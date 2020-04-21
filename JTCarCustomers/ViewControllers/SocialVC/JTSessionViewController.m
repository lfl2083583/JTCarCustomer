//
//  JTSessionViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionViewController.h"
#import "JTIMNotificationCenter.h"
#import "JTMessageMaker.h"
#import "JTBaseNavigationController.h"
#import "JTExpressionCollectionViewController.h"
#import "JTExpressionStoreViewController.h"
#import "JTExpressionManageViewController.h"
#import "JTCameraViewController.h"
#import "JTTeamDetailViewController.h"
#import "JTPersonalDetailViewController.h"

#import "ZTAdminister.h"

@interface JTSessionViewController () <NIMChatManagerDelegate, JTIMNotificationCenterDelegate, JTAttentionTipTopViewDelegate, JTInputActionDelegate, JTBanCoverViewDelegate>

@end

@implementation JTSessionViewController

- (void)dealloc
{
    NSLog(@"JTSessionViewController界面已经释放");
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[JTIMNotificationCenter sharedCenter] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}

- (instancetype)initWithSession:(NIMSession *)session locationMessage:(NIMMessage *)locationMessage
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
        _locationMessage = locationMessage;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.sessionInputView viewWillAppear];
    id content = [JTSessionUtil recentSessionDraftMark:[JTSessionUtil recentSession:self.session]];
    if (content && self.sessionInputView.contentText.length == 0) {
        [self.sessionInputView setContentText:content[JTDraftText]];
        if ([content[JTDraftItem] isKindOfClass:[NSArray class]] && [(NSArray *)[content objectForKey:JTDraftItem] count] > 0) {
            [self.sessionInputView.userCache addItems:[JTInputUserItem mj_objectArrayWithKeyValuesArray:content[JTDraftItem]]];
        }
        [JTSessionUtil removeRecentSessionDraftMark:self.session];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sessionInputView viewWillDisappear];
    if (self.sessionInputView.contentText && self.sessionInputView.contentText.length > 0) {
        NSMutableArray *items = [NSMutableArray array];
        if (self.sessionInputView.userCache.items.count > 0) {
            for (JTInputUserItem *item in self.sessionInputView.userCache.items) {
                [items addObject:[item mj_keyValuesWithIgnoredKeys:@[@"range"]]];
            }
        }
        [JTSessionUtil addRecentSessionDraftMark:self.session content:@{JTDraftText: self.sessionInputView.contentText, JTDraftItem: items}];
    }
    else
    {
        [JTSessionUtil removeRecentSessionDraftMark:self.session];
    }
}

- (void)sendMessage:(NIMMessage *)message;
{
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:self.session error:nil];
}

- (void)updateMessage:(NIMMessage *)message
           completion:(NIMUpdateMessageBlock)completion
{
    if ([message.session isEqual:self.session]) {
        [self.sessionConfigurator updateMessage:message];
    }
}

- (void)setIsEditStatus:(BOOL)isEditStatus
{
    _isEditStatus = isEditStatus;
    [self configOther];
    if (isEditStatus) {
        [self.sessionConfigurator startEdit];
    }
    else
    {
        [self.sessionConfigurator stopEdit];
    }
}

- (void)rightClick:(id)sender
{
    if (self.isEditStatus) {
        self.isEditStatus = NO;
    }
    else
    {
        if (self.session.sessionType == NIMSessionTypeP2P) {
            [self.navigationController pushViewController:[[JTPersonalDetailViewController alloc] initWithSession:self.session] animated:YES];
        } else {
            [self.navigationController pushViewController:[[JTTeamDetailViewController alloc] initWithSession:self.session] animated:YES];
        }
    }
}

- (void)deleteClick:(id)sender
{
    [self.sessionConfigurator deleteChoose];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:WhiteColor];
    [self.navigationItem setTitleView:self.sessionTitleLB];
    [self.view addSubview:self.bottomImage];
    [self.view addSubview:self.tableView];
    if (!self.locationMessage) {
        [self.view addSubview:self.sessionInputView];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[JTIMNotificationCenter sharedCenter] addDelegate:self];
    }
    [self.sessionConfigurator setup:self locationMessage:self.locationMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChangeNotification:) name:kReachabilityStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanSessionMessageNotification:) name:kCleanSessionMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotifyForNewMsgNotification:) name:kJTUpdateNotifyForNewMsgNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSessionBottomNotification:) name:kUpdateSessionBottomNotification object:nil];
    if (self.session.sessionType == NIMSessionTypeTeam) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamInfoUpdateNotification:) name:kJTTeamInfoUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamInfoUpdateNotification:) name:kJTTeamMembersUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSessionShowNickNameNotification:) name:kJTUpdateSessionShowNickNameNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdateNotification:) name:kJTUserInfoUpdatedNotification object:nil];
    }
    
    [self configNavTitle];
    [self configBottom];
    [self configOther];
    
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
    [JTSessionUtil removeRecentSessionAtMark:self.session];
    [JTSessionUtil removeRecentSessionAnnounceMark:self.session];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message
{
    if ([message.session isEqual:self.session]) {
        if ([self.sessionConfigurator findMessage:message]) {
            [self.sessionConfigurator updateMessage:message];
        }
        else {
            [self.sessionConfigurator addMessages:@[message] autoBottom:YES];
        }
    }
}

- (void)sendMessage:(NIMMessage *)message
           progress:(float)progress
{
    if ([message.session isEqual:self.session]) {
        [self.sessionConfigurator updateMessage:message];
    }
}

- (void)sendMessage:(NIMMessage *)message
didCompleteWithError:(nullable NSError *)error
{
    if ([message.session isEqual:self.session]) {
        [self.sessionConfigurator updateMessage:message];
        [self.sessionConfigurator scrollTableViewBottom:YES];
    }
}

- (void)fetchMessageAttachment:(NIMMessage *)message
          didCompleteWithError:(nullable NSError *)error
{
    if ([message.session isEqual:self.session]) {
        [self.sessionConfigurator updateMessage:message];
        [self.sessionConfigurator scrollTableViewBottom:YES];
    }
}

#pragma mark JTIMNotificationCenterDelegate
- (void)onHandleRecvMessages:(NSArray *)messages
{
    [self.sessionConfigurator addMessages:messages autoBottom:YES];
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
}

#pragma mark JTAttentionTipTopViewDelegate
- (void)attentionTipTopViewToCancel:(id)attentionTipTopView
{
    [JTSessionUtil addRecentSessionDisableAttentionTipMark:self.session];
    [self configOther];
}

- (void)attentionTipTopViewToAttention:(id)attentionTipTopView
{
    __weak typeof(self) weakself = self;
    NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(FocusApi) parameters:@{@"fid": userID, @"type": @"1"} placeholder:@"" success:^(id responseObject, ResponseState state) {
        [[NIMSDK sharedSDK].conversationManager saveMessage:[JTMessageMaker messageWithFuns:@"null" yunxinId:weakself.session.sessionId type:1 time:@"null"]
                                                 forSession:weakself.session
                                                 completion:nil];
    } failure:^(NSError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.tableView.frame, touchPoint)) {
        [self.sessionInputView drop];
    }
}

#pragma mark JTInputActionDelegate
- (void)keyboardStatus:(BOOL)isShow
{
    self.tableView.userInteractionEnabled = !isShow;
    self.isShowSessionInputView = isShow;
}

- (void)callDidChangeHeight:(CGFloat)height
{
    self.tableView.height = self.tableView.superview.height - kStatusBarHeight - kTopBarHeight - height - ((_attentionTipTopView && !_attentionTipTopView.hidden)?_attentionTipTopView.height:0);
    if (_sessionConfigurator) {
        [self.sessionConfigurator scrollTableViewBottom:YES];
    }
}

- (void)reachabilityStatusChangeNotification:(NSNotification *)notification
{
    [self activeCancelBan];
}

- (void)cleanSessionMessageNotification:(NSNotification *)notification
{
    [self.sessionConfigurator.items removeAllObjects];
    [self.tableView reloadData];
}

- (void)updateNotifyForNewMsgNotification:(NSNotification *)notification
{
    [self configNavTitle];
}

- (void)updateSessionBottomNotification:(NSNotification *)notification
{
    [self configBottom];
}

- (void)teamInfoUpdateNotification:(NSNotification *)notification
{
    [self configNavTitle];
    [self configOther];
}

- (void)updateSessionShowNickNameNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)userInfoUpdateNotification:(NSNotification *)notification
{
    [self configNavTitle];
    [self configOther];
}

- (void)onSendText:(NSString *)text atUsers:(NSArray *)users
{
    NIMMessage *message = [JTMessageMaker messageWithText:text];
    if (users.count) {
        NIMMessageApnsMemberOption *apnsOption = [[NIMMessageApnsMemberOption alloc] init];
        apnsOption.userIds = users;
        apnsOption.forcePush = NO;
        apnsOption.apnsContent = [NSString stringWithFormat:@"%@在群里@了你", [JTUserInfoHandle showNick:[NIMSDK sharedSDK].loginManager.currentAccount inSession:self.session]];
        message.apnsMemberOption = apnsOption;
    };
    [self sendMessage:message];
}

- (void)onTapMediaItem:(JTMediaItem *)item
{
    SEL sel = item.selctor;
    if (sel && [self respondsToSelector:sel]) {
        JTKit_SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
    }
}

- (void)onTapMediaItemBonus:(JTMediaItem *)item
{
    [self.sessionTool mediaBonusPressed:item];
}

- (void)onTapMediaItemCard:(JTMediaItem *)item
{
    [self.sessionTool mediaCardPressed:item];
}

- (void)onTapMediaItemCollection:(JTMediaItem *)item
{
    [self.sessionTool mediaCollectionPressed:item];
}

- (void)onTapMediaItemVideoChat:(JTMediaItem *)item
{
    [self.sessionTool mediaVideoChatPressed:item];
}

- (void)onTapMediaItemLocation:(JTMediaItem *)item
{
    [self.sessionTool mediaLocationPressed:item];
}

- (void)onTapExpressionAddCollection
{
    [self presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:[[JTExpressionCollectionViewController alloc] init]] animated:YES completion:nil];
}

- (void)onTapExpressionStore
{
    [self presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:[[JTExpressionStoreViewController alloc] init]] animated:YES completion:nil];
}

- (void)onTapExpressionManage
{
    [self presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:[[JTExpressionManageViewController alloc] init]] animated:YES completion:nil];
}

- (void)onTapExpression:(JTExpression *)expression
{
    [self sendMessage:[JTMessageMaker messageWithExpression:expression.expressionID expressionName:expression.name expressionUrl:expression.originalUrl expressionThumbnail:expression.thumbnailUrl expressionWidth:expression.width expressionHeight:expression.height]];
}

- (void)onTapBonus
{
    [self.sessionTool mediaBonusPressed:self.sessionInputView];
}

- (void)onTapCamera
{
    __weak typeof(self) weakself = self;
    [self presentViewController:[[JTCameraViewController alloc] initWithCompletionImageHandler:^(UIImage *image) {
        [weakself sendMessage:[JTMessageMaker messageWithImage:image]];
    } completionVideoHandler:^(NSString *videoPath) {
        [weakself sendMessage:[JTMessageMaker messageWithVideo:videoPath]];
    }] animated:YES completion:nil];
}

- (void)onSendPhotos:(NSArray<UIImage *> *)photos
{
    for (UIImage *photo in photos) {
        [self sendMessage:[JTMessageMaker messageWithImage:photo]];
    }
}

- (void)onSendVideoPath:(NSString *)path
{
    [self sendMessage:[JTMessageMaker messageWithVideo:path]];
}

- (void)onSendAudioPath:(NSString *)path
{
    [self sendMessage:[JTMessageMaker messageWithAudio:path]];
}

#pragma mark JTBanCoverViewDelegate
- (void)banCoverViewToCancel:(id)banCoverView
{
    [self activeCancelBan];
}

- (void)activeCancelBan
{
    // 主动取消禁言
    if (self.powerModel.isMuted && self.powerModel.bannedTimeInterval <= 0) {
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(CancelBanApi) parameters:@{@"group_id": self.session.sessionId} success:nil failure:nil];
    }
}

- (UILabel *)sessionTitleLB {
    if (!_sessionTitleLB)
    {
        _sessionTitleLB = [[UILabel alloc] init];
        _sessionTitleLB.textColor = BlackLeverColor6;
        _sessionTitleLB.font = Font(18);
        _sessionTitleLB.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _sessionTitleLB;
}

- (UIImageView *)bottomImage {
    if (!_bottomImage)
    {
        _bottomImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bottomImage.backgroundColor = BlackLeverColor1;
        _bottomImage.contentMode = UIViewContentModeScaleAspectFill;
        _bottomImage.clipsToBounds = YES;
    }
    return _bottomImage;
}

- (JTAttentionTipTopView *)attentionTipTopView
{
    if (!_attentionTipTopView) {
        _attentionTipTopView = [[JTAttentionTipTopView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 52) delegate:self];
    }
    return _attentionTipTopView;
}

- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (JTInputView *)sessionInputView {
    if (_sessionInputView == nil)
    {
        _sessionInputView = [[JTInputView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 0) config:self.sessionConfig delegate:self];
        _sessionInputView.session = self.session;
    }
    return _sessionInputView;
}

- (JTBanCoverView *)inputCoverLB {
    if (!_inputCoverLB)
    {
        _inputCoverLB = [[JTBanCoverView alloc] init];
        _inputCoverLB.font = Font(16);
        _inputCoverLB.textColor = BlackLeverColor5;
        _inputCoverLB.textAlignment = NSTextAlignmentCenter;
        _inputCoverLB.userInteractionEnabled = YES;
        _inputCoverLB.backgroundColor = WhiteColor;
        _inputCoverLB.hidden = YES;
    }
    return _inputCoverLB;
}

- (JTGradientButton *)deleteBT
{
    if (!_deleteBT) {
        _deleteBT = [[JTGradientButton alloc] initWithFrame:CGRectMake(37.5, self.view.height-75, self.view.width-75, 45)];
        _deleteBT.titleLabel.font = Font(16);
        [_deleteBT setTitle:@"删除所选" forState:UIControlStateNormal];
        [_deleteBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_deleteBT addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBT;
}

- (JTSessionConfigurator *)sessionConfigurator {
    if (_sessionConfigurator == nil)
    {
        _sessionConfigurator = [[JTSessionConfigurator alloc] init];
    }
    return _sessionConfigurator;
}

- (JTSessionTool *)sessionTool {
    if (!_sessionTool)
    {
        _sessionTool = [[JTSessionTool alloc] initWithViewController:self];
    }
    return _sessionTool;
}

- (id<JTSessionProtocol>)sessionConfig {
    if (_sessionConfig == nil)
    {
        _sessionConfig = [[JTSessionConfig alloc] initWithSession:self.session];
    }
    return _sessionConfig;
}

- (JTTeamPowerModel *)powerModel
{
    if (!_powerModel) {
        _powerModel = [[JTTeamPowerModel alloc] init];
    }
    return _powerModel;
}

- (void)configNavTitle
{
    NSString *text = @"";
    BOOL isMessageNoDisturb = YES;
    
    switch (self.session.sessionType) {
        case NIMSessionTypeTeam: {
            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
            text = [NSString stringWithFormat:@"%@(%zd)", [team teamName], [team memberNumber]];
            isMessageNoDisturb = ([[NIMSDK sharedSDK].teamManager notifyStateForNewMsg:self.session.sessionId] == NIMTeamNotifyStateAll);
        }
            break;
        case NIMSessionTypeP2P: {
            text = [JTUserInfoHandle showNick:self.session.sessionId];
            isMessageNoDisturb = [[NIMSDK sharedSDK].userManager notifyForNewMsg:self.session.sessionId];
        }
            break;
        default:
            break;
    }
    if (text.length > 0) {
        if (!isMessageNoDisturb)  {
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.bounds = CGRectMake(2, -3, 16, 17);
            attach.image = [UIImage imageNamed:@"icon_disturb"];
            NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
            [attributeString insertAttributedString:strAtt atIndex:[text length]];
            self.sessionTitleLB.attributedText = attributeString;
        }
        else  {
            self.sessionTitleLB.text = text;
        }
    }
    else {
        self.sessionTitleLB.text = @"";
    }
    [self.sessionTitleLB sizeToFit];
}

- (void)configBottom
{
    NSArray *array = [ZTAdminister sqlite_search:[[JTSessionBackgroundModel alloc] initWithSessionID:self.session.sessionId]];
    if (array.count > 0) {
        NSString *urlName = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SessionBackground"] stringByAppendingPathComponent:[(JTSessionBackgroundModel *)[array firstObject] background]];
        self.bottomImage.image = [UIImage imageWithContentsOfFile:urlName];
    }
    else
    {
        self.bottomImage.image = nil;
    }
}

- (void)configOther
{
    if (self.isEditStatus) { // 编辑状态 隐藏输入工具条并放下 显示取消和删除按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick:)];
        if (!_deleteBT) {
            [self.view insertSubview:self.deleteBT aboveSubview:self.sessionInputView];
        }
        _deleteBT.hidden = NO;
        [self.sessionInputView drop];
        [self.sessionInputView setHidden:YES];
        if (_inputCoverLB) {
            _inputCoverLB.hidden = YES;
        }
    }
    else
    {
        // 普通状态 隐藏删除按钮 显示输入工具条
        if (_deleteBT) {
            _deleteBT.hidden = YES;
        }
        [self.sessionInputView setHidden:NO];
        if (self.session.sessionType == NIMSessionTypeTeam) {
            self.powerModel.team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
            if (self.powerModel.isMyTeam) {
                self.navigationItem.rightBarButtonItem = self.locationMessage ? nil : [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_group"] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick:)];
                if (self.powerModel.bannedTimeInterval > 0) {
                    [self.sessionInputView drop];
                    if (!_inputCoverLB) {
                        [self.view insertSubview:self.inputCoverLB aboveSubview:self.sessionInputView];
                    }
                    self.inputCoverLB.timeInterval = self.powerModel.bannedTimeInterval;
                    self.inputCoverLB.frame = self.sessionInputView.frame;
                    self.inputCoverLB.height = 36;
                    self.sessionInputView.userInteractionEnabled = NO;
                }
                else
                {
                    [self activeCancelBan];
                    if (_inputCoverLB) {
                        _inputCoverLB.timeInterval = 0;
                    }
                    self.sessionInputView.userInteractionEnabled = YES;
                }
                if (self.powerModel.announceID && ![self.powerModel.announceID isBlankString] && self.powerModel.announceTime && ![self.powerModel.announceTime isBlankString]) {
                    if (!self.powerModel.displayedAnnounceTime || ![self.powerModel.displayedAnnounceTime isEqualToString:self.powerModel.announceTime]) {
                        NSMutableDictionary *info = [NSMutableDictionary dictionary];
                        if (self.powerModel.myTeamMember.customInfo) {
                            [info addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:[self.powerModel.myTeamMember.customInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL]];
                        }
                        [info setObject:self.powerModel.announceTime forKey:@"announceTime"];
                        [[NIMSDK sharedSDK].teamManager updateMyCustomInfo:[info mj_JSONString] inTeam:self.session.sessionId completion:^(NSError * _Nullable error) {
                        }];
                        __weak typeof(self) weakself = self;
                        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GroupNoticeInfoApi) parameters:@{@"group_id": self.session.sessionId, @"id": self.powerModel.announceID} success:^(id responseObject, ResponseState state) {
                            [weakself.view presentView:[[JTTeamAnnounceTipView alloc] initWithAnnounce:responseObject] animated:YES completion:nil];
                        } failure:^(NSError *error) {
                        }];
                    }
                }
            }
            else
            {
                self.navigationItem.rightBarButtonItem = nil;
                if (_inputCoverLB) {
                    _inputCoverLB.timeInterval = 0;
                }
                self.sessionInputView.userInteractionEnabled = YES;
            }
        }
        else
        {
            self.navigationItem.rightBarButtonItem = self.locationMessage ? nil : [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_personal"] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick:)];
            JTUserContactType userContactType = [JTUserInfoHandle showUserContactType:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]];
            if (![JTSessionUtil recentSessionIsDisableAttentionTipMark:[JTSessionUtil recentSession:self.session]]) {
                //关系类型
                if (userContactType == JTUserContactTypeStranger || userContactType == JTUserContactTypeFans) {
                    if (!_attentionTipTopView) {
                        [self.view insertSubview:self.attentionTipTopView aboveSubview:self.sessionInputView];
                        _tableView.top = _attentionTipTopView.bottom;
                        _tableView.height -= _attentionTipTopView.height;
                    }
                    _attentionTipTopView.hidden = NO;
                    _attentionTipTopView.prompt = (userContactType == JTUserContactTypeStranger) ? @"是否关注对方" : @"对方关注了你，是否关注对方";
                }
                else
                {
                    if (_attentionTipTopView) {
                        _attentionTipTopView.hidden = YES;
                        _tableView.top = _attentionTipTopView.top;
                        _tableView.height += _attentionTipTopView.height;
                    }
                }
            }
            else
            {
                if (_attentionTipTopView) {
                    _attentionTipTopView.hidden = YES;
                    _tableView.top = _attentionTipTopView.top;
                    _tableView.height += _attentionTipTopView.height;
                }
            }
        }
    }
}

@end
