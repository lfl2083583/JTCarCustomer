//
//  JTSocialRouterUtil.m
//  JTSocial
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//


#import "JTSocialRouterUtil.h"
#import <JLRoutes.h>
#import <objc/runtime.h>

#import "JTBaseNavigationController.h"
#import "JTLoginViewController.h"
//#import "JTLivePreviewViewController.h"
//#import "JTLivePlayViewController.h"
#import "JTCallInViewController.h"
//#import "JTBaseNavigationController.h"
//#import "JTUserListViewController.h"
//#import "JTGroupListViewController.h"
//#import "JTGetPowerViewController.h"
#import "JTTradeWebViewController.h"
//#import "JTMessageMaker.h"
//#import "ShareViewTool.h"
#import "CLAlertController.h"
#import "JTContracSelectViewController.h"
#import "JTTeamSelectViewController.h"
#import "JTMessageMaker.h"
#import "NSObject+ZTExtension.h"

NSString * const JTPlatformLogin = @"JTPlatformLogin";
NSString * const JTPlatformLiveShow = @"JTPlatformLiveShow";
NSString * const JTPlatformWatchLive = @"JTPlatformWatchLive";
NSString * const JTPlatformCallVideoIn = @"JTPlatformCallVideoIn";
NSString * const JTPlatformCallAudioIn = @"JTPlatformCallAudioIn";
NSString * const JTPlatformShareToSocial = @"JTPlatformShareToSocial";
NSString * const JTPlatformNextPage = @"JTPlatformNextPage";
NSString * const JTPlatformClosePage = @"JTPlatformClosePage";
NSString * const JTPlatformPaymentResults = @"JTPlatformPaymentResults";
NSString * const JTPlatformSendNormalMessage = @"JTPlatformSendNormalMessage";
NSString * const JTPlatformRepeatNormalMessage = @"JTPlatformRepeatNormalMessage";

@implementation JTSocialRouterUtil

+ (instancetype)sharedCenter
{
    static JTSocialRouterUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTSocialRouterUtil alloc] init];
    });
    return instance;
}

- (void)openURL:(NSURL *)url
{
    [self openURL:url complete:nil];
}

- (void)openURL:(NSURL *)url complete:(void (^)(BOOL status))complete
{
    _complete = complete;
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    if ([[JLRoutes routesForScheme:kJTCarCustomersScheme] routeURL:url]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)registerRouterWithScheme
{
    __weak typeof(self) weakself = self;
    [[JLRoutes routesForScheme:kJTCarCustomersScheme] addRoutes:@[JTPlatformLogin, JTPlatformLiveShow, JTPlatformWatchLive, JTPlatformCallVideoIn, JTPlatformCallAudioIn, JTPlatformShareToSocial, JTPlatformNextPage, JTPlatformClosePage, JTPlatformPaymentResults, JTPlatformSendNormalMessage, JTPlatformRepeatNormalMessage] handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        if (parameters && parameters.count > 0 && [parameters objectForKey:JLRoutePatternKey])
        {
            if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformLogin]) {
                [weakself loginPressed];
            }
            BOOL isValid = [JTUserInfo shareUserInfo].isLogin;
            if (isValid) {
                if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformLiveShow])
                {
//                    [weakself liveShowPressed];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformWatchLive])
                {
//                    [weakself watchLivePressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformCallVideoIn])
                {
                    [weakself callVideoInPressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformCallAudioIn])
                {
                    [weakself callAudioInPressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformShareToSocial])
                {
//                    [weakself shareToSocialPressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformNextPage])
                {
//                    [weakself nextPagePressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformClosePage])
                {
//                    [weakself closePagePressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformPaymentResults])
                {
                    [weakself paymentResultsPressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformSendNormalMessage])
                {
                    [weakself sendNormalMessagePressed:parameters];
                }
                else if ([parameters[JLRoutePatternKey] isEqualToString:JTPlatformRepeatNormalMessage])
                {
                    [weakself repeatNormalMessagePressed:parameters];
                }
            }
            return isValid;
        }
        return NO;
    }];
}

//- (void)paramToViewController:(UIViewController *)viewController parameters:(NSDictionary<NSString *, NSString *> *)parameters {
//
//    if (viewController.class) {
//        unsigned int outCount, i;
//        // 获取对象里的属性列表 默认返回第一个
//        objc_property_t *properties = class_copyPropertyList([viewController class], &outCount);
//
//        for (i = 0; i < outCount; i++) {
//            objc_property_t property = properties[i];
//            //  属性名转成字符串
//            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//            NSString *param = parameters[propertyName];
//            if (param != nil) {
//                [viewController setValue:param forKey:propertyName];
//            }
//        }
//        free(properties);
//    }
//}

- (void)loginPressed
{
    [[Utility currentViewController] presentViewController:[[JTBaseNavigationController alloc] initWithRootViewController:[[JTLoginViewController alloc] init]] animated:YES completion:nil];
}
//
///**
// 开启直播
// */
//- (void)liveShowPressed
//{
//    [JTDeviceAccess checkNetworkEnable:@"在移动网络环境下开启直播会消耗您的流量，是否继续开启" result:^(BOOL result) {
//        if (result) {
//            [JTDeviceAccess checkMicrophoneEnable:@"麦克风权限受限,无法直播" result:^(BOOL result) {
//                if (result) {
//                    [JTDeviceAccess checkCameraEnable:@"相机权限受限,无法直播" result:^(BOOL result) {
//                        if (result) {
//                            JTLivePreviewViewController *livePreviewVC = [[JTLivePreviewViewController alloc] initWithLivePushStreamConfig:[[JTLivePushStreamConfig alloc] init]];
//                            JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:livePreviewVC];
//                            [[Utility currentViewController] presentViewController:nav animated:YES completion:nil];
//                        }
//                    }];
//                }
//            }];
//        }
//    }];
//}
//
///**
// 观看直播
// */
//- (void)watchLivePressed:(NSDictionary *)parameters
//{
//    if ([parameters objectForKey:@"roomID"]) {
//        if ([JTSocialStautsUtil sharedCenter].liveStatus == JTLiveStatusLiving) {
//            [[HUDTool shareHUDTool] showHint:QTLocalizedString(@"您正在直播中，暂时不能观看对方的直播")];
//        }
//        else if ([JTSocialStautsUtil sharedCenter].liveStatus == JTLiveStatusWatching) {
////            [[JTSocialStautsUtil sharedCenter].livePlayerViewCtl changeToNewLiveWithRoomID:parameters[@"roomID"]];
//        }
//        else {
////            [JTLivePlayerViewController joinLiveWithViewCtl:[Utility currentViewController] roomID:parameters[@"roomID"]];
//        }
//    }
//    else {
//        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//    }
//}
//
///**
// 拨打视频聊天
//
// @param parameters parameters description
// */
- (void)callVideoInPressed:(NSDictionary *)parameters
{
    if ([parameters objectForKey:@"callee"]) {
        if ([[NIMSDK sharedSDK].userManager isMyFriend:parameters[@"callee"]]) {
            [JTDeviceAccess checkNetworkEnable:@"在移动网络环境下开启音视频会消耗您的流量，是否继续开启" result:^(BOOL result) {
                if (result) {
                    [JTDeviceAccess checkMicrophoneEnable:@"麦克风权限受限,无法视频聊天" result:^(BOOL result) {
                        if (result) {
                            [JTDeviceAccess checkCameraEnable:@"相机权限受限,无法视频聊天" result:^(BOOL result) {
                                if (result) {
                                    JTCallInViewController *callInVC = [[JTCallInViewController alloc] initWithNibName:@"JTCallInViewController" bundle:nil];
                                    callInVC.callee = [parameters objectForKey:@"callee"];
                                    callInVC.callType = NIMNetCallMediaTypeVideo;
                                    [[Utility currentViewController] presentViewController:callInVC animated:YES completion:nil];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
        else
        {
            [[HUDTool shareHUDTool] showHint:@"啊哦~相互关注后，才能使用语音通话"];
        }
    }
    else
    {
        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
    }
}

/**
 拨打语音聊天

 @param parameters parameters description
 */
- (void)callAudioInPressed:(NSDictionary *)parameters
{
    if ([parameters objectForKey:@"callee"]) {
        if ([[NIMSDK sharedSDK].userManager isMyFriend:parameters[@"callee"]]) {
            [JTDeviceAccess checkNetworkEnable:@"在移动网络环境下开启音视频会消耗您的流量，是否继续开启" result:^(BOOL result) {
                if (result) {
                    [JTDeviceAccess checkMicrophoneEnable:@"麦克风权限受限,无法语音聊天" result:^(BOOL result) {
                        if (result) {
                            JTCallInViewController *callInVC = [[JTCallInViewController alloc] initWithNibName:@"JTCallInViewController" bundle:nil];
                            callInVC.callee = [parameters objectForKey:@"callee"];
                            callInVC.callType = NIMNetCallMediaTypeAudio;
                            [[Utility currentViewController] presentViewController:callInVC animated:YES completion:nil];
                        }
                    }];
                }
            }];
        }
        else
        {
            [[HUDTool shareHUDTool] showHint:@"啊哦~相互关注后，才能使用语音通话"];
        }
    }
    else
    {
        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
    }
}

///**
// 分享导航
//
// @param parameters parameters description
// */
//- (void)shareToSocialPressed:(NSDictionary *)parameters
//{
//    if ([parameters objectForKey:@"appKey"] && [parameters objectForKey:@"shareType"] && [parameters objectForKey:@"message"]) {
//
//        [self handlePlatformShareParameters:parameters complete:^(id message) {
//            if (message) {
//                JTSocialShareType shareType = [[parameters objectForKey:@"shareType"] integerValue];
//                JTSocialShareContentType shareContentType = [[parameters objectForKey:@"shareContentType"] integerValue];
//                switch (shareType) {
//                    case JTSocialShareType_Friend:
//                    {
//                        JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
//                        config.contactSelectType = JTContactSelectTypeThirdShare;
//                        config.needMutiSelected = NO;
//                        JTUserListViewController *userListVC = [[JTUserListViewController alloc] initWithConfig:config message:message];
//                        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
//                        [[Utility currentViewController] presentViewController:navigationController animated:YES completion:nil];
//                    }
//                        break;
//                    case JTSocialShareType_Team:
//                    {
//                        JTGroupListViewController *groupListVC = [[JTGroupListViewController alloc] initWithMessage:message];
//                        JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:groupListVC];
//                        [[Utility currentViewController] presentViewController:navigationController animated:YES completion:nil];
//                    }
//                        break;
//                    case JTSocialShareType_WechatSession:
//                    {
//                        [[ShareViewTool loadGuide] shareInfoFromUMWithPlatform:0 shareContentType:(ShareContentType)shareContentType withMessageObject:message withResult:^(NSError *error) {
//                        }];
//                    }
//                        break;
//                    case JTSocialShareType_WechatTimeLine:
//                    {
//                        [[ShareViewTool loadGuide] shareInfoFromUMWithPlatform:2 shareContentType:(ShareContentType)shareContentType withMessageObject:message withResult:^(NSError *error) {
//                        }];
//                    }
//                        break;
//                    default:
//                        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//                        break;
//                }
//            }
//            else
//            {
//                [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//            }
//        }];
//    }
//    else
//    {
//        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//    }
//}
//
///**
// 打开下一个页面
//
// @param parameters parameters description
// */
//- (void)nextPagePressed:(NSDictionary *)parameters
//{
//    if ([parameters objectForKey:@"className"]) {
//        UIViewController *viewController = [self validateClassName:parameters[@"className"]];
//        if (viewController) {
//            [[Utility currentViewController] presentViewController:viewController animated:YES completion:nil];
//        }
//        else
//        {
//            [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//        }
//    }
//    else
//    {
//        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//    }
//}
//
///**
// 关闭页面
//
// @param parameters parameters description
// */
//- (void)closePagePressed:(NSDictionary *)parameters
//{
//    if ([parameters objectForKey:@"className"]) {
//        UIViewController *viewController = [self validateClassName:parameters[@"className"]];
//        if (viewController) {
//            [viewController dismissViewControllerAnimated:YES completion:nil];
//        }
//        else
//        {
//            [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//        }
//    }
//    else
//    {
//        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
//    }
//}
//

/**
 支付结果处理（只停留在充值列表页面才处理）

 @param parameters parameters description
 */
- (void)paymentResultsPressed:(NSDictionary *)parameters
{
    if ([parameters objectForKey:@"url"]) {
        if ([[Utility currentViewController] isKindOfClass:[JTTradeWebViewController class]]) {
            [(JTTradeWebViewController *)[Utility currentViewController] changeURLAddress:parameters[@"url"]];
        }
    }
    else
    {
        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
    }
}

/**
 发送消息
 
 @param parameters parameters description
 */
- (void)sendNormalMessagePressed:(NSDictionary *)parameters
{
    if ([parameters objectForKey:@"message"]) {
        NIMMessage *message = [[parameters objectForKey:@"message"] zt_object];
        if ([parameters objectForKey:@"modelStyle"]) {
            NSInteger modelStyle = [[parameters objectForKey:@"modelStyle"] integerValue];
            if (modelStyle == 1) {
                [self friendsNormalMessage:message messageType:1];
            }
            else if (modelStyle == 2) {
                [self teamNormalMessage:message messageType:1];
            }
        }
        else
        {
            CLAlertController *alert = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
            __weak typeof(self) weakself = self;
            [alert addAction:[CLAlertModel actionWithTitle:@"发送给好友" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [weakself friendsNormalMessage:message messageType:1];
            }]];
            [alert addAction:[CLAlertModel actionWithTitle:@"发送给群聊" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [weakself teamNormalMessage:message messageType:1];
            }]];
            [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
            }]];
            [[Utility currentViewController] presentToViewController:alert completion:nil];
        }
    }
    else
    {
        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
    }
}

/**
 转发消息
 
 @param parameters parameters description
 */
- (void)repeatNormalMessagePressed:(NSDictionary *)parameters
{
    if ([parameters objectForKey:@"message"]) {
        NIMMessage *message = [[parameters objectForKey:@"message"] zt_object];
//        NSString *urlString = [NSString stringWithFormat:@"%@://%@?session=%@&messageID=%@&modelStyle=1", kJTCarCustomersScheme, JTPlatformRepeatNormalMessage, [[message.session mj_JSONString] base64EncodedString], message.messageId];
//        NIMSession *session = [NIMSession mj_objectWithKeyValues:[[[parameters objectForKey:@"session"] base64DecodedString] mj_JSONObject]];
//        NIMMessage *message = [[NIMSDK sharedSDK].conversationManager messagesInSession:session messageIds:[parameters objectForKey:@"messageID"]].firstObject;
        if ([parameters objectForKey:@"modelStyle"]) {
            NSInteger modelStyle = [[parameters objectForKey:@"modelStyle"] integerValue];
            if (modelStyle == 1) {
                [self friendsNormalMessage:message messageType:2];
            }
            else if (modelStyle == 2) {
                [self teamNormalMessage:message messageType:2];
            }
        }
        else
        {
            CLAlertController *alert = [CLAlertController alertControllerWithTitle:nil message:nil preferredStyle:CLAlertControllerStyleSheet];
            __weak typeof(self) weakself = self;
            [alert addAction:[CLAlertModel actionWithTitle:@"发送给好友" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [weakself friendsNormalMessage:message messageType:2];
            }]];
            [alert addAction:[CLAlertModel actionWithTitle:@"发送给群聊" style:CLAlertActionStyleDefault handler:^(CLAlertModel *action) {
                [weakself teamNormalMessage:message messageType:2];
            }]];
            [alert addAction:[CLAlertModel actionWithTitle:@"取消" style:CLAlertActionStyleCancel handler:^(CLAlertModel *action) {
            }]];
            [[Utility currentViewController] presentToViewController:alert completion:nil];
        }
    }
    else
    {
        [[HUDTool shareHUDTool] showHint:@"传入参数非法"];
    }
}

/**
 发送给好友

 @param message 消息体
 @param messageType 消息类型，1：发送 2:转发
 */
- (void)friendsNormalMessage:(NIMMessage *)message messageType:(NSInteger)messageType
{
    JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
    config.contactSelectType = JTContactSelectTypeRepeatMessage;
    config.needMutiSelected = NO;
    config.source = message;
    JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
    userListVC.callBack = ^(NSArray *yunxinIDs, NSArray *userIDs, NSString *content) {
        if (messageType == 1) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
        }
        else
        {
            if ([[NIMSDK sharedSDK].chatManager forwardMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
        }
        if (content && [content isKindOfClass:[NSString class]] && content.length) {
            NIMMessage *message = [JTMessageMaker messageWithText:content];
            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil];
        }
    };
    JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
    [[Utility currentViewController] presentViewController:navigationController animated:YES completion:nil];
}

/**
 发送给群聊
 
 @param message 消息体
 @param messageType 消息类型，1：发送 2:转发
 */
- (void)teamNormalMessage:(NIMMessage *)message messageType:(NSInteger)messageType
{
    JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
    config.contactSelectType = JTContactSelectTypeRepeatMessage;
    config.needMutiSelected = NO;
    config.source = message;
    JTTeamSelectViewController *teamListVC = [[JTTeamSelectViewController alloc] initWithConfig:config];
    teamListVC.callBack = ^(NSArray *teamIDs, NSString *content) {
        if (messageType == 1) {
            if ([[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
        }
        else
        {
            if ([[NIMSDK sharedSDK].chatManager forwardMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil]) {
                [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
            }
        }
        if (content && [content isKindOfClass:[NSString class]] && content.length) {
            NIMMessage *message = [JTMessageMaker messageWithText:content];
            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil];
        }
    };
    JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:teamListVC];
    [[Utility currentViewController] presentViewController:navigationController animated:YES completion:nil];
}

//
//- (void)handlePlatformShareParameters:(NSDictionary *)parameters complete:(void (^)(id message))complete
//{
//    JTSocialShareType shareType = [[parameters objectForKey:@"shareType"] integerValue];
//    JTSocialShareContentType shareContentType = [[parameters objectForKey:@"shareContentType"] integerValue];
//    if (shareType == JTSocialShareType_Friend || shareType == JTSocialShareType_Team) {
//        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"v1/open/game/detail") parameters:@{@"app_key": parameters[@"appKey"]} success:^(id responseObject) {
//
//            NSDictionary *sourceDic = [responseObject objectForKey:@"data"];
//            if (shareContentType == JTSocialShareContentTypeUrl) {
//                JTSocialThirdUrlObject *object = [JTSocialThirdUrlObject mj_objectWithKeyValues:[parameters[@"message"] base64DecodedString]];
//                object.appKey = parameters[@"appKey"];
//                NIMMessage *message = [JTMessageMaker messageWithGameCard:object.gameID gameName:sourceDic[@"gname"] gameIcon:sourceDic[@"icon"] shareIcon:object.shareIcon shareTitle:object.shareTitle shareContent:object.shareContent appKey:object.appKey ext:object.ext];
//                complete(message);
//            }
//            else
//            {
//                JTSocialThirdImageObject *object = [JTSocialThirdImageObject mj_objectWithKeyValues:[parameters[@"message"] base64DecodedString]];
//                object.appKey = parameters[@"appKey"];
//                UIImage *image = [self dataURLImage:object.imageData];
//                [[HttpRequestTool sharedInstance] uploadWithFileName:@"" uploadFileArr:@[image] success:^(id responseObject) {
//                    NIMMessage *message = [JTMessageMaker messageWithGamePhoto:object.gameID gameName:sourceDic[@"gname"] gameIcon:sourceDic[@"icon"] gameImage:[responseObject firstObject] imageWidth:object.imageWidth imageHeight:object.imageHeight appKey:object.appKey];
//                    complete(message);
//                } failure:^(NSError *error) {
//                    complete(nil);
//                }];
//            }
//
//        } failure:^(NSError *error) {
//            complete(nil);
//        }];
//    }
//    else
//    {
//        if (shareContentType == JTSocialShareContentTypeUrl) {
//            JTSocialThirdUrlObject *object = [JTSocialThirdUrlObject mj_objectWithKeyValues:[parameters[@"message"] base64DecodedString]];
//            NSDictionary *shareInfo = @{ShareUrl: kShareUrl, ShareTitle: object.shareTitle, ShareDescribe: object.shareContent, ShareThumbURL: object.shareIcon};
//            complete(shareInfo);
//        }
//        else
//        {
//            JTSocialThirdImageObject *object = [JTSocialThirdImageObject mj_objectWithKeyValues:[parameters[@"message"] base64DecodedString]];
//            UIImage *image = [self dataURLImage:object.imageData];
//            complete(image);
//        }
//    }
//}
//
//- (UIImage *)dataURLImage:(NSString *)string
//{
//    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
//}
//
//- (UIViewController *)validateClassName:(NSString *)className
//{
//    Class newClass = NSClassFromString(className);
//    if (newClass) {
//        id instance = [[newClass alloc] init];
//        if ([instance isKindOfClass:[UIViewController class]]) {
//            return instance;
//        }
//    }
//    return nil;
//}

@end
