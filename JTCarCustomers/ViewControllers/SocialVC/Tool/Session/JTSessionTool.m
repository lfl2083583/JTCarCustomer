//
//  JTSessionTool.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTool.h"
#import "JTSessionViewController.h"

#import "JTBaseNavigationController.h"
#import "JTPersonalBonusViewController.h"
#import "JTTeamBonusViewController.h"
#import "JTContracSelectViewController.h"
#import "JTMessageMaker.h"
#import "JTCollectionViewController.h"
#import "JTMapPositionViewController.h"
#import "CLAlertController.h"

#import "ImageDisplayTool.h"
#import "JTPlayVideoViewController.h"
#import "JTMapMarkViewController.h"
#import "JTCardViewController.h"
#import "JTBonusRobView.h"
#import "JTBaseSpringView.h"
#import "JTBonusDetailViewController.h"
#import "JTTeamInfoViewController.h"
#import "JTCarLifeDetailViewController.h"
#import "JTActivityDetailViewController.h"
#import "JTStoreDetailViewController.h"

#import "JTExpressionTool.h"
#import "NSObject+ZTExtension.h"


@interface JTSessionTool ()

@property (strong, nonatomic) NIMSession *session;

@end

@implementation JTSessionTool

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (NIMSession *)session
{
    if (!_session) {
        _session = [(JTSessionViewController *)self.viewController session];
    }
    return _session;
}

- (void)mediaBonusPressed:(id)sender
{
    if (self.session.sessionType == NIMSessionTypeP2P) {
        JTPersonalBonusViewController *personalBonusVC = [[JTPersonalBonusViewController alloc] initWithSession:self.session];
        [self.viewController presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:personalBonusVC] animated:YES completion:nil];
    }
    else
    {
        JTTeamBonusViewController *teamBonusVC = [[JTTeamBonusViewController alloc] initWithSession:self.session];
        [self.viewController presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:teamBonusVC] animated:YES completion:nil];
    }
}

- (void)mediaCardPressed:(id)sender
{
    __weak typeof(self) weakself = self;
    JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
    config.contactSelectType = JTContactSelectTypeSingle;
    config.needMutiSelected = NO;
    JTContracSelectViewController *contracSelectVC = [[JTContracSelectViewController alloc] initWithConfig:config];
    contracSelectVC.finshBlock = ^(NSArray *yunxinIDs, NSArray *userIDs) {
        NIMMessage *message = [JTMessageMaker messageWithCard:[yunxinIDs firstObject]];
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:weakself.session error:nil];
    };
    JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:contracSelectVC];
    [self.viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)mediaCollectionPressed:(id)sender
{
    __weak typeof(self) weakself = self;
    JTCollectionViewController *collectionVC = [[JTCollectionViewController alloc] initWithDoneBlock:^(NIMMessage *message) {
        [(JTSessionViewController *)weakself.viewController sendMessage:message];
        [(JTSessionViewController *)weakself.viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:collectionVC] animated:YES completion:nil];
}

- (void)mediaVideoChatPressed:(id)sender
{
    if ([JTSocialStautsUtil sharedCenter].liveStatus != JTLiveStatusNone) {
        [[HUDTool shareHUDTool] showHint:@"直播进行中，您暂时不能操作视频聊天"];
    }
    else
    {
        if ([JTUserInfoHandle showUserContactType:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]] != JTUserContactTypeFriends) {
            [[HUDTool shareHUDTool] showHint:@"啊哦~相互关注后，才能使用视频聊天"];
        }
        else
        {
            __weak typeof(self) weakself = self;
            CLAlertController *alert = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
            [alert addAction:[CLAlertModel actionWithTitle:@"视频聊天" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?callee=%@", kJTCarCustomersScheme, JTPlatformCallVideoIn, weakself.session.sessionId]]];
            }]];
            [alert addAction:[CLAlertModel actionWithTitle:@"语音聊天" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?callee=%@", kJTCarCustomersScheme, JTPlatformCallAudioIn, weakself.session.sessionId]]];
            }]];
            [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
            }]];
            [self.viewController presentToViewController:alert completion:nil];
        }
    }
}

- (void)mediaLocationPressed:(id)sender
{
    __weak typeof(self) weakself = self;
    [JTDeviceAccess checkLocationEnable:@"位置权限受限,无法使用位置" result:^(BOOL result) {
        if (result) {
            JTMapPositionViewController *mapPositionVC = [[JTMapPositionViewController alloc] init];
            [mapPositionVC setMapPositionViewControllerBlock:^(NIMMessage *message) {
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:weakself.session error:nil];
            }];
            [weakself.viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:mapPositionVC] animated:YES completion:nil];
        }
    }];
}



- (void)cellImagePressed:(NIMMessage *)message
{
    __block NSMutableArray *imageMessages = [NSMutableArray array];
    for (id model in [(JTSessionViewController *)self.viewController sessionConfigurator].items) {
        if ([model isKindOfClass:[JTSessionMessageModel class]])
        {
            if ([(JTSessionMessageModel *)model message].messageType == NIMMessageTypeImage) {
                [imageMessages addObject:[(JTSessionMessageModel *)model message]];
            }
            else if ([(JTSessionMessageModel *)model message].messageType == NIMMessageTypeCustom) {
                NIMCustomObject *object = (NIMCustomObject *)[(JTSessionMessageModel *)model message].messageObject;
                if ([object.attachment isKindOfClass:[JTImageAttachment class]]) {
                    [imageMessages addObject:[(JTSessionMessageModel *)model message]];
                }
            }
        }
    }
    
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc] init];
    option.limit = 0;
    option.messageTypes = @[[NSNumber numberWithInteger:NIMMessageTypeImage], [NSNumber numberWithInteger:NIMMessageTypeCustom]];
    option.order = NIMMessageSearchOrderDesc;

    __weak typeof(self) weakself = self;
    [[NIMSDK sharedSDK].conversationManager searchMessages:message.session option:option result:^(NSError *error, NSArray *messages) {
        
        for (NIMMessage *imageMessage in messages) {
            if (![imageMessages containsObject:imageMessage]) {
                if (imageMessage.messageType == NIMMessageTypeImage) {
                    [imageMessages addObject:imageMessage];
                }
                else if (imageMessage.messageType == NIMMessageTypeCustom) {
                    NIMCustomObject *object = (NIMCustomObject *)imageMessage.messageObject;
                    if ([object.attachment isKindOfClass:[JTImageAttachment class]]) {
                        [imageMessages addObject:imageMessage];
                    }
                }
            }
        }
        NSInteger index = ([imageMessages containsObject:message])?[imageMessages indexOfObject:message]:0;
        [[ImageDisplayTool shareImageDisplayTool] showInViewController:weakself.viewController dataArray:imageMessages currentPhotoIndex:index imageDisplayType:JTImageDisplayTypeSession];
    }];
}

- (void)cellAudioPressed:(NIMMessage *)message
{
}

- (void)cellVideoPressed:(NIMMessage *)message
{
    if ([JTSocialStautsUtil sharedCenter].liveStatus != JTLiveStatusNone) {
        [[HUDTool shareHUDTool] showHint:@"直播进行中，您暂时不能操作视频"];
    }
    else
    {
        NIMVideoObject *object = (NIMVideoObject *)message.messageObject;
        __weak typeof(self) weakself = self;
        JTPlayVideoViewController *playVideoVC = [[JTPlayVideoViewController alloc] initWithVideoUrl:object.url videoPath:object.path coverUrl:object.coverUrl coverPath:object.coverPath longPressBlock:^(UIViewController *viewController) {
            CLAlertController *alertMore = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"保存到相册" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(object.path)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(object.path, weakself, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给好友" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [alertMore dismissToViewControllerCompletion:^{
                    NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=1", kJTCarCustomersScheme, JTPlatformRepeatNormalMessage, [message zt_string]];
                    [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
                }];
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给群聊" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [alertMore dismissToViewControllerCompletion:^{
                    NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=2", kJTCarCustomersScheme, JTPlatformRepeatNormalMessage, [message zt_string]];
                    [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
                }];
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"收藏" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                NSString *content = [@{@"url": object.url, @"coverUrl": object.coverUrl, @"width": [NSString stringWithFormat:@"%.2f", object.coverSize.width], @"height": [NSString stringWithFormat:@"%.2f", object.coverSize.height]} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"6" forKey:@"type"];
                NSString *source = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.from]];
                [parameters setObject:source forKey:@"source"];
                if (message.session.sessionType == NIMSessionTypeP2P) {
                    NSString *joinID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.session.sessionId]];
                    [parameters setObject:joinID forKey:@"join_id"];
                    [parameters setObject:@"1" forKey:@"join_type"];
                }
                else
                {
                    [parameters setObject:message.session.sessionId forKey:@"join_id"];
                    [parameters setObject:@"2" forKey:@"join_type"];
                }
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(AddFavoriteApi) parameters:parameters success:^(id responseObject, ResponseState state) {
                    
                    [[HUDTool shareHUDTool] showHint:@"已收藏"];
                } failure:^(NSError *error) {
                }];
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
            }]];
            [viewController presentToViewController:alertMore completion:nil];
        }];
        playVideoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.viewController presentViewController:playVideoVC animated:YES completion:nil];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [[HUDTool shareHUDTool] showHint:error?@"保存相册失败":@"保存相册成功"];
}

- (void)cellLocationPressed:(NIMMessage *)message
{
    __weak typeof(self) weakself = self;
    [JTDeviceAccess checkLocationEnable:@"位置权限受限,无法使用地图" result:^(BOOL result) {
        if (result) {
            JTMapMarkViewController *mapMarkVC = [[JTMapMarkViewController alloc] initWithMessage:message];
            [weakself.viewController setHidesBottomBarWhenPushed:YES];
            [weakself.viewController.navigationController pushViewController:mapMarkVC animated:YES];
        }
    }];
}

- (void)cellNetCallPressed:(NIMMessage *)message
{
    if ([JTSocialStautsUtil sharedCenter].liveStatus != JTLiveStatusNone) {
        [[HUDTool shareHUDTool] showHint:@"直播进行中，您暂时不能操作视频聊天"];
    }
    else
    {
        if ([JTUserInfoHandle showUserContactType:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]] != JTUserContactTypeFriends) {
            [[HUDTool shareHUDTool] showHint:@"啊哦~相互关注后，才能使用视频聊天"];
        }
        else
        {
            NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
            NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
            if (content.callType == NIMNetCallMediaTypeVideo) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?callee=%@", kJTCarCustomersScheme, JTPlatformCallVideoIn, message.session.sessionId]]];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?callee=%@", kJTCarCustomersScheme, JTPlatformCallAudioIn, message.session.sessionId]]];
            }
        }
    }
}

- (void)cellExpressionPressed:(JTExpressionAttachment *)attachment
{
    
}

- (void)cellCardPressed:(JTCardAttachment *)attachment;
{
    JTCardViewController *cardVC = [[JTCardViewController alloc] initWithUserID:attachment.userId];
    [self.viewController setHidesBottomBarWhenPushed:YES];
    [self.viewController.navigationController pushViewController:cardVC animated:YES];
}

/**
 点击红包

 @param attachment 红包模型
 @param message 红包消息
 */
- (void)cellBonusPressed:(JTBonusAttachment *)attachment message:(NIMMessage *)message
{
    // 自己发送的红包，或者红包抢过，直接进入红包详情
    if (attachment.isGrabbed) {
        [self requestBonusDetail:attachment message:message];
    }
    else
    {
        // 红包超时
        if (attachment.isOverTime) {
            [self openRobBounsFrame:attachment message:message];
        }
        else
        {
            [self verifyBonus:attachment message:message];
        }
    }
}

/**
 点击抢红包提示消息

 @param attachment 抢红包模型
 */
- (void)cellCallBonusPressed:(JTCallBonusAttachment *)attachment
{
    __weak typeof(self) weakself = self;
    [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetPacketApi) parameters:@{@"packet_id": attachment.bonusId} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] hideHUD];
        [weakself openBonusDetail:responseObject attachment:nil message:nil];
    } failure:^(NSError *error) {
    }];
}


/**
 验证并请求红包状态

 @param attachment 红包模型
 @param message 红包消息
 */
- (void)verifyBonus:(JTBonusAttachment *)attachment message:(NIMMessage *)message
{
    __weak typeof(self) weakself = self;
    [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ClickPacketApi) parameters:@{@"packet_id": attachment.bonusId} success:^(id responseObject, ResponseState state) {
        NSInteger status = [responseObject[@"rob_status"] integerValue];
        [weakself updateBonusStatus:status attachment:attachment message:message];
        if ([responseObject[@"rob_status"] integerValue] == JTBonusStatusGrabbed) {
            [weakself requestBonusDetail:attachment message:message];
        }
        else
        {
            [weakself openRobBounsFrame:attachment message:message];
        }
        [[HUDTool shareHUDTool] hideHUD];
    } failure:^(NSError *error) {
        
    }];
}

/**
 更新红包状态

 @param status 红包状态
 @param attachment 红包模型
 @param message 红包消息
 */
- (void)updateBonusStatus:(NSInteger)status attachment:(JTBonusAttachment *)attachment message:(NIMMessage *)message
{
    switch (status) {
        case JTBonusStatusGrabbed:      {
            attachment.isGrabbed = YES;
        }   break;
        case JTBonusStatusOverTime:     {
            attachment.isOverTime = YES;
        }  break;
        case JTBonusStatusOverGrab:     {
            attachment.isOverGrab = YES;
        }  break;
        case JTBonusStatusGrabSuccess:  {
            attachment.isGrabbed = YES;
        }   break;
        default:
            break;
    }
    [(NIMCustomObject *)message.messageObject setAttachment:attachment];
    __weak typeof(self) weakself = self;
    [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:self.session completion:^(NSError * _Nullable error) {
        if (!error) {
            [(JTSessionViewController *)weakself.viewController updateMessage:message completion:nil];
        }
    }];
}

/**
 打开抢红包界面

 @param attachment 红包模型
 @param message 红包消息
 */
- (void)openRobBounsFrame:(JTBonusAttachment *)attachment message:(NIMMessage *)message
{
    __weak typeof(self) weakself = self;
    JTBonusRobView *bonusNoMoneyView = [[JTBonusRobView alloc] initWithAttachment:attachment message:message completionHandler:^(JTBonusStatus bonusStatus, BOOL isDisplayDetails, id data) {
        if (bonusStatus == JTBonusStatusLookDetail) {
            [weakself requestBonusDetail:attachment message:message];
        }
        else
        {
            if (isDisplayDetails && data) {
                [weakself openBonusDetail:data attachment:attachment message:message];
            }
            [weakself updateBonusStatus:bonusStatus attachment:attachment message:message];
        }
    }];
    JTBaseSpringView *springView = [[JTBaseSpringView alloc] initWithContentView:bonusNoMoneyView];
    [[Utility mainWindow] presentView:springView animated:YES completion:nil];
}

/**
 请求红包详细数据

 @param attachment 红包模型
 @param message 红包消息
 */
- (void)requestBonusDetail:(JTBonusAttachment *)attachment message:(NIMMessage *)message
{
    __weak typeof(self) weakself = self;
    [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetPacketApi) parameters:@{@"packet_id": attachment.bonusId} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] hideHUD];
        [weakself openBonusDetail:responseObject attachment:attachment message:message];
    } failure:^(NSError *error) {
    }];
}

/**
 打开红包详情 如果状态改变则更新本地数据

 @param data 红包详细数据
 @param attachment 红包模型
 @param message 红包消息
 */
- (void)openBonusDetail:(NSDictionary *)data attachment:(JTBonusAttachment *)attachment message:(NIMMessage *)message
{
    if ([data objectForKey:@"info"]) {
        JTBonusDetailModel *bonusDetailModel = [JTBonusDetailModel mj_objectWithKeyValues:data[@"info"]];
        if (bonusDetailModel && attachment && message) {
            if (attachment.isGrabbed != bonusDetailModel.isGrabbed && bonusDetailModel.isGrabbed) {
                [self updateBonusStatus:JTBonusStatusGrabbed attachment:attachment message:message];
            }
            if (attachment.isOverTime != bonusDetailModel.isOverTime && bonusDetailModel.isOverTime) {
                [self updateBonusStatus:JTBonusStatusOverTime attachment:attachment message:message];
            }
            if (bonusDetailModel.bonusCount == bonusDetailModel.bonusRobCount && !attachment.isOverGrab) {
                [self updateBonusStatus:JTBonusStatusOverGrab attachment:attachment message:message];
            }
        }
        if ([data objectForKey:@"list"]) {
            NSArray *bonusList = [JTBonusListModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
            JTBonusDetailViewController *redPacketDetailViewController = [[JTBonusDetailViewController alloc] initWithBonusDetailModel:bonusDetailModel bonusList:bonusList];
            [self.viewController setHidesBottomBarWhenPushed:YES];
            [self.viewController.navigationController pushViewController:redPacketDetailViewController animated:YES];
        }
    }
}

- (void)cellNetworkVideoPressed:(JTVideoAttachment *)attachment message:(NIMMessage *)message
{
    if ([JTSocialStautsUtil sharedCenter].liveStatus != JTLiveStatusNone) {
        [[HUDTool shareHUDTool] showHint:@"直播进行中，您暂时不能操作视频"];
    }
    else
    {
        NSString *folder = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"smallVideo"];
        NSString *name = [NSString stringWithFormat:@"%@.mp4", [attachment.videoUrl MD5String]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:folder]) {
            [fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:nil];
        }
        NSString *videoPath = [folder stringByAppendingPathComponent:name];
        JTPlayVideoViewController *playVideoVC = [[JTPlayVideoViewController alloc] initWithVideoUrl:attachment.videoUrl videoPath:videoPath coverUrl:attachment.videoCoverUrl coverPath:@"" longPressBlock:^(UIViewController *viewController) {
            CLAlertController *alertMore = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"保存到相册" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给好友" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [alertMore dismissToViewControllerCompletion:^{
                    NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=1", kJTCarCustomersScheme, JTPlatformRepeatNormalMessage, [message zt_string]];
                    [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
                }];
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"发送给群聊" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [alertMore dismissToViewControllerCompletion:^{
                    NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@&modelStyle=2", kJTCarCustomersScheme, JTPlatformRepeatNormalMessage, [message zt_string]];
                    [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
                }];
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"收藏" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                NSString *content = [@{@"url": attachment.videoUrl, @"coverUrl": attachment.videoCoverUrl, @"width": attachment.videoWidth, @"height": attachment.videoHeight} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"6" forKey:@"type"];
                NSString *source = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.from]];
                [parameters setObject:source forKey:@"source"];
                if (message.session.sessionType == NIMSessionTypeP2P) {
                    NSString *joinID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.session.sessionId]];
                    [parameters setObject:joinID forKey:@"join_id"];
                    [parameters setObject:@"1" forKey:@"join_type"];
                }
                else
                {
                    [parameters setObject:message.session.sessionId forKey:@"join_id"];
                    [parameters setObject:@"2" forKey:@"join_type"];
                }
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(AddFavoriteApi) parameters:parameters success:^(id responseObject, ResponseState state) {
                    
                    [[HUDTool shareHUDTool] showHint:@"收藏成功"];
                } failure:^(NSError *error) {
                }];
            }]];
            [alertMore addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
            }]];
            [viewController presentToViewController:alertMore completion:nil];
        }];
        playVideoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.viewController presentViewController:playVideoVC animated:YES completion:nil];
    }
}

- (void)cellGroupPressed:(JTGroupAttachment *)attachment
{
    [self.viewController.navigationController pushViewController:[[JTTeamInfoViewController alloc] initWithTeam:[[NIMSDK sharedSDK].teamManager teamById:attachment.groupId]] animated:YES];
}

- (void)cellInformationPressed:(JTInformationAttachment *)attachment
{
    [self.viewController.navigationController pushViewController:[[JTCarLifeDetailViewController alloc] initWeburl:attachment.h5Url navtitle:attachment.title] animated:YES];
}

- (void)cellActivityPressed:(JTActivityAttachment *)attachment
{
    JTActivityDetailViewController *activityDetailVC = [[JTActivityDetailViewController alloc] initWithActivityID:attachment.activityId];
    activityDetailVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self.viewController.navigationController pushViewController:activityDetailVC animated:YES];
}

- (void)cellShopPressed:(JTShopAttachment *)attachment
{
    [self.viewController.navigationController pushViewController:[[JTStoreDetailViewController alloc] initWithStoreID:attachment.shopId] animated:YES];
}



- (void)enumItemRemovePressed:(NIMMessage *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"移除该成员后，TA将接收不到群消息，确认要移除吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }]];
    __weak typeof(self) weakself = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.from]];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(RemoveGroupUserApi) parameters:@{@"group_id": weakself.session.sessionId, @"uids": userID} success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"移除成功"];
        } failure:^(NSError *error) {
        }];
    }]];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)enumItemBanPressed:(NIMMessage *)message
{
    __weak typeof(self) weakself = self;
    NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.from]];
    CLAlertController *alert = [CLAlertController alertControllerWithTitle:@"选中禁言时长" message:nil preferredStyle:CLAlertControllerStyleSheet];
    [alert addAction:[CLAlertModel actionWithTitle:@"10分钟" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        [weakself requestBanUserID:userID banMinute:@"10"];
    }]];
    [alert addAction:[CLAlertModel actionWithTitle:@"30分钟" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        [weakself requestBanUserID:userID banMinute:@"30"];
    }]];
    [alert addAction:[CLAlertModel actionWithTitle:@"1小时" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        [weakself requestBanUserID:userID banMinute:@"60"];
    }]];
    [alert addAction:[CLAlertModel actionWithTitle:@"一天" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
        [weakself requestBanUserID:userID banMinute:@"1440"];
    }]];
    [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
    }]];
    [self.viewController presentToViewController:alert completion:nil];
}

- (void)requestBanUserID:(NSString *)userID banMinute:(NSString *)banMinute
{
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GroupBatChatApi) parameters:@{@"group_id": self.session.sessionId, @"ban_time": banMinute, @"ban_uid": userID, @"type": @"1"} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"禁言设置成功" yOffset:0];
    } failure:^(NSError *error) {
    }];
}

- (void)enumItemCancelBanPressed:(NIMMessage *)message
{
    NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.from]];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GroupBatChatApi) parameters:@{@"group_id": self.session.sessionId, @"ban_time": @"0", @"ban_uid": userID, @"type": @"0"} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"取消禁言成功"];
    } failure:^(NSError *error) {
    }];
}

- (void)enumItemSelectedPressed:(NIMMessage *)message
{
    [[(JTSessionViewController *)self.viewController sessionInputView] showKeyboard];
    [[(JTSessionViewController *)self.viewController sessionInputView] insertInputUserItem:@[message.from] isChar:YES];
}

- (void)enumItemCopyPressed:(NIMMessage *)message
{
    switch (message.messageType) {
        case NIMMessageTypeText:
        {
            [[UIPasteboard generalPasteboard] setString:message.text];
            [[HUDTool shareHUDTool] showHint:@"已复制"];
        }
            break;
        case NIMMessageTypeCustom:
        {
            NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
            if ([object.attachment isKindOfClass:[JTFunsAttachment class]])
            {
                JTFunsAttachment *attachment = (JTFunsAttachment *)object.attachment;
                [[UIPasteboard generalPasteboard] setString:attachment.funsText];
                [[HUDTool shareHUDTool] showHint:@"已复制"];
            }
        }
            break;
        default:
            break;
    }
}

- (void)enumItemRepeatPressed:(NIMMessage *)message
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@?message=%@", kJTCarCustomersScheme, JTPlatformRepeatNormalMessage, [message zt_string]];
    [[JTSocialRouterUtil sharedCenter] openURL:[NSURL URLWithString:urlString]];
}

- (void)enumItemCollectionPressed:(NIMMessage *)message
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    switch (message.messageType) {
        case NIMMessageTypeText:
        {
            NSString *content = [@{@"text": message.text} mj_JSONString];
            [parameters setObject:content forKey:@"content"];
            [parameters setObject:@"1" forKey:@"type"];
        }
            break;
        case NIMMessageTypeImage:
        {
            NIMImageObject *object = (NIMImageObject *)[message messageObject];
            NSString *content = [@{@"image": object.url, @"thumbnail": object.thumbUrl, @"width": [NSString stringWithFormat:@"%.2f", object.size.width], @"height": [NSString stringWithFormat:@"%.2f", object.size.height]} mj_JSONString];
            [parameters setObject:content forKey:@"content"];
            [parameters setObject:@"5" forKey:@"type"];
        }
            break;
        case NIMMessageTypeAudio:
        {
            NIMAudioObject *object = (NIMAudioObject *)[message messageObject];
            NSInteger duration = object.duration/1000;
            NSString *content = [@{@"url": object.url, @"duration": @(duration)} mj_JSONString];
            [parameters setObject:content forKey:@"content"];
            [parameters setObject:@"2" forKey:@"type"];
        }
            break;
        case NIMMessageTypeVideo:
        {
            NIMVideoObject *object = (NIMVideoObject *)[message messageObject];
            NSString *content = [@{@"url": object.url, @"coverUrl": object.coverUrl, @"width": [NSString stringWithFormat:@"%.2f", object.coverSize.width], @"height": [NSString stringWithFormat:@"%.2f", object.coverSize.height]} mj_JSONString];
            [parameters setObject:content forKey:@"content"];
            [parameters setObject:@"6" forKey:@"type"];
        }
            break;
        case NIMMessageTypeLocation:
        {
            NIMLocationObject *object = (NIMLocationObject *)[message messageObject];
            NSString *content = [@{@"address": object.title, @"lat": @(object.latitude), @"lng": @(object.longitude)} mj_JSONString];
            [parameters setObject:content forKey:@"content"];
            [parameters setObject:@"4" forKey:@"type"];
        }
            break;
        case NIMMessageTypeCustom:
        {
            NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
            if ([object.attachment isKindOfClass:[JTExpressionAttachment class]])
            {
                JTExpressionAttachment *attachment = (JTExpressionAttachment *)object.attachment;
                NSString *content = [@{@"name": attachment.expressionName, @"image": attachment.expressionUrl, @"thumbnail": attachment.expressionThumbnail, @"width": attachment.expressionWidth, @"height": attachment.expressionHeight} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"3" forKey:@"type"];
            }
            else if ([object.attachment isKindOfClass:[JTFunsAttachment class]])
            {
                JTFunsAttachment *attachment = (JTFunsAttachment *)object.attachment;
                NSString *content = [@{@"text": attachment.funsText} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"1" forKey:@"type"];
            }
            else if ([object.attachment isKindOfClass:[JTVideoAttachment class]])
            {
                JTVideoAttachment *attachment = (JTVideoAttachment *)object.attachment;
                NSString *content = [@{@"url": attachment.videoUrl, @"coverUrl": attachment.videoCoverUrl, @"width": attachment.videoWidth, @"height": attachment.videoHeight} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"6" forKey:@"type"];
            }
            else if ([object.attachment isKindOfClass:[JTImageAttachment class]])
            {
                JTImageAttachment *attachment = (JTImageAttachment *)object.attachment;
                NSString *content = [@{@"image": attachment.imageUrl, @"thumbnail": attachment.imageThumbnail, @"width": attachment.imageWidth, @"height": attachment.imageHeight} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"5" forKey:@"type"];
            }
            else if ([object.attachment isKindOfClass:[JTInformationAttachment class]])
            {
                JTInformationAttachment *attachment = (JTInformationAttachment *)object.attachment;
                NSString *content = [@{@"id": attachment.informationId} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"8" forKey:@"type"];
            }
            else if ([object.attachment isKindOfClass:[JTActivityAttachment class]])
            {
                JTActivityAttachment *attachment = (JTActivityAttachment *)object.attachment;
                NSString *content = [@{@"id": attachment.activityId} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"7" forKey:@"type"];
            }
            else if ([object.attachment isKindOfClass:[JTShopAttachment class]])
            {
                JTShopAttachment *attachment = (JTShopAttachment *)object.attachment;
                NSString *content = [@{@"id": attachment.shopId} mj_JSONString];
                [parameters setObject:content forKey:@"content"];
                [parameters setObject:@"9" forKey:@"type"];
            }
        }
            break;
        default:
            break;
    }

    if (parameters.count > 0 && message.from.length > 0) {
        
        NSString *source = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.from]];
        [parameters setObject:source forKey:@"source"];
        if (message.session.sessionType == NIMSessionTypeP2P) {
            NSString *joinID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:message.session.sessionId]];
            [parameters setObject:joinID forKey:@"join_id"];
            [parameters setObject:@"1" forKey:@"join_type"];
        }
        else
        {
            [parameters setObject:message.session.sessionId forKey:@"join_id"];
            [parameters setObject:@"2" forKey:@"join_type"];
        }
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(AddFavoriteApi) parameters:parameters success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"收藏成功"];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)enumItemRevokePressed:(NIMMessage *)message
{
    __weak typeof(self) weakself = self;
    [[NIMSDK sharedSDK].chatManager revokeMessage:message completion:^(NSError * _Nullable error) {
        if (error) {
            if (error.code == NIMRemoteErrorCodeDomainExpireOld) {
                [Utility showAlertMessage:@"发送时间超过2分钟的消息，不能被撤回"];
            } else {
                [[HUDTool shareHUDTool] showHint:@"消息撤回失败，请重试"];
            }
        }
        else
        {
            [[(JTSessionViewController *)weakself.viewController sessionConfigurator] deleteMessage:message];
            NIMMessage *tipMessage = [JTMessageMaker messageWithTip:[JTSessionUtil tipOnMessageRevoked:message]];
            tipMessage.timestamp = message.timestamp;
            [[NIMSDK sharedSDK].conversationManager saveMessage:tipMessage forSession:message.session completion:nil];
        }
    }];
}

- (void)enumItemDeletePressed:(NIMMessage *)message
{
    [[(JTSessionViewController *)self.viewController sessionConfigurator] deleteMessage:message];
    [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
}


- (void)enumItemAddPressed:(NIMMessage *)message
{
    JTExpressionAttachment *attachment = (JTExpressionAttachment *)[(NIMCustomObject *)message.messageObject attachment];
    [Utility downloadImageWithURLString:attachment.expressionUrl success:^(UIImage *image) {
        NSMutableArray *resources = [NSMutableArray array];
        [resources addObject:@{@"name": @"", @"image": attachment.expressionUrl, @"thumb": attachment.expressionThumbnail, @"md5": [image MD5String], @"width": attachment.expressionWidth, @"height": attachment.expressionHeight}];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonAddFavoriteApi) parameters:@{@"pic_list": [resources mj_JSONString]} success:^(id responseObject, ResponseState state) {
            if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                [[HUDTool shareHUDTool] showHint:@"添加成功"];
                [[JTExpressionTool sharedManager].collectionExpressions addObjectsFromArray:responseObject[@"list"]];
                [[JTExpressionTool sharedManager] writeDocuments:[JTExpressionTool sharedManager].collectionExpressions fileName:kCollectionExpressionFileName];
                [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }];
}

- (void)enumItemMultiselectPressed:(NIMMessage *)message
{
    [(JTSessionViewController *)self.viewController setIsEditStatus:YES];
}
@end
