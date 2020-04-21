//
//  JTSessionUtil.m
//  JTSocial
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionUtil.h"

NSString * const JTRecentSessionAtMark = @"JTRecentSessionAtMark";
NSString * const JTRecentSessionDraftMark = @"JTRecentSessionDraftMark";
NSString * const JTRecentSessionDisableAttentionTipMark = @"JTRecentSessionDisableAttentionTipMark";
NSString * const JTRecentSessionAnnounceMark = @"JTRecentSessionAnnounceMark";

NSString * const JTDraftText = @"JTDraftText";
NSString * const JTDraftItem = @"JTDraftItem";

@implementation JTSessionUtil

+ (NIMRecentSession *)recentSession:(NIMSession *)session
{
    NSArray *recents = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
    NIMRecentSession *recent;
    for (recent in recents) {
        if ([recent.session isEqual:session]) {
            break;
        }
    }
    return recent;
}

+ (void)addRecentSessionAtMark:(NIMSession *)session
{
    NIMRecentSession *recent = [self recentSession:session];
    if (recent) {
        NSDictionary *localExt = recent.localExt?:@{};
        NSMutableDictionary *dict = [localExt mutableCopy];
        [dict setObject:@(YES) forKey:JTRecentSessionAtMark];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:dict recentSession:recent];
    }
}

+ (void)removeRecentSessionAtMark:(NIMSession *)session
{
    NIMRecentSession *recent = [self recentSession:session];
    if (recent) {
        NSMutableDictionary *localExt = [recent.localExt mutableCopy];
        [localExt removeObjectForKey:JTRecentSessionAtMark];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recent];
    }
}

+ (BOOL)recentSessionIsAtMark:(NIMRecentSession *)recent
{
    NSDictionary *localExt = recent.localExt;
    return [localExt[JTRecentSessionAtMark] boolValue] == YES;
}

+ (void)addRecentSessionDraftMark:(NIMSession *)session content:(id)content
{
    NIMRecentSession *recent = [self recentSession:session];
    if (recent) {
        NSDictionary *localExt = recent.localExt?:@{};
        NSMutableDictionary *dict = [localExt mutableCopy];
        [dict setObject:[content mj_JSONString] forKey:JTRecentSessionDraftMark];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:dict recentSession:recent];
    }
}

+ (void)removeRecentSessionDraftMark:(NIMSession *)session
{
    NIMRecentSession *recent = [self recentSession:session];
    if (recent) {
        NSMutableDictionary *localExt = [recent.localExt mutableCopy];
        [localExt removeObjectForKey:JTRecentSessionDraftMark];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recent];
    }
}

+ (id)recentSessionDraftMark:(NIMRecentSession *)recent
{
    NSDictionary *localExt = recent.localExt;
    if ([localExt objectForKey:JTRecentSessionDraftMark]) {
        return [localExt[JTRecentSessionDraftMark] mj_JSONObject];
    }
    else
    {
        return nil;
    }
}

+ (void)addRecentSessionDisableAttentionTipMark:(NIMSession *)session
{
    NIMRecentSession *recent = [self recentSession:session];
    if (recent) {
        NSDictionary *localExt = recent.localExt?:@{};
        NSMutableDictionary *dict = [localExt mutableCopy];
        [dict setObject:@(YES) forKey:JTRecentSessionDisableAttentionTipMark];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:dict recentSession:recent];
    }
}

+ (BOOL)recentSessionIsDisableAttentionTipMark:(NIMRecentSession *)recent
{
    NSDictionary *localExt = recent.localExt;
    return [localExt[JTRecentSessionDisableAttentionTipMark] boolValue] == YES;
}

+ (void)addRecentSessionAnnounceMark:(NIMSession *)session
{
    NIMRecentSession *recent = [self recentSession:session];
    if (recent) {
        NSDictionary *localExt = recent.localExt?:@{};
        NSMutableDictionary *dict = [localExt mutableCopy];
        [dict setObject:@(YES) forKey:JTRecentSessionAnnounceMark];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:dict recentSession:recent];
    }
}

+ (void)removeRecentSessionAnnounceMark:(NIMSession *)session
{
    NIMRecentSession *recent = [self recentSession:session];
    if (recent) {
        NSMutableDictionary *localExt = [recent.localExt mutableCopy];
        [localExt removeObjectForKey:JTRecentSessionAnnounceMark];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recent];
    }
}

+ (BOOL)recentSessionIsAnnounceMark:(NIMRecentSession *)recent
{
    NSDictionary *localExt = recent.localExt;
    return [localExt[JTRecentSessionAnnounceMark] boolValue] == YES;
}

+ (NSString *)messageTipContent:(NIMMessage *)message
{
    NSString *text = nil;
    
    if (text == nil)
    {
        switch (message.messageType) {
            case NIMMessageTypeNotification:
                text = [JTSessionUtil notificationMessage:message];
                break;
            case NIMMessageTypeTip:
                text = message.text;
                break;
            default:
                break;
        }
    }
    return text;
}

+ (NSString *)notificationMessage:(NIMMessage *)message
{
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    switch (object.notificationType) {
        case NIMNotificationTypeTeam:
        {
            return [JTSessionUtil teamNotificationFormatedMessage:message];
        }
        case NIMNotificationTypeNetCall:
        {
            return [JTSessionUtil netcallNotificationFormatedMessage:message];
        }
        case NIMNotificationTypeChatroom:
        {
            return [JTSessionUtil chatroomNotificationFormatedMessage:message];
        }
        default:
            return @"";
    }
}

+ (NSString *)teamNotificationFormatedMessage:(NIMMessage *)message
{
    NSString *formatedMessage = @"";
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    if (object.notificationType == NIMNotificationTypeTeam)
    {
        NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
        NSString *source = [JTSessionUtil teamNotificationSourceName:message];
        NSArray *targets = [JTSessionUtil teamNotificationTargetNames:message];
        NSString *targetText = [targets count] > 1 ? [targets componentsJoinedByString:@","] : [targets firstObject];
        NSString *teamName = [JTSessionUtil teamNotificationTeamShowName:message];
        
        switch (content.operationType) {
            case NIMTeamOperationTypeInvite:
            {
                NSString *str = [NSString stringWithFormat:@"%@邀请%@", source, targets.firstObject];
                if (targets.count > 1) {
                    str = [str stringByAppendingFormat:@"等%zd人", targets.count];
                }
                str = [str stringByAppendingFormat:@"进入了%@", teamName];
                formatedMessage = str;
            }
                break;
            case NIMTeamOperationTypeDismiss:
                formatedMessage = [NSString stringWithFormat:@"%@解散了%@", source, teamName];
                break;
            case NIMTeamOperationTypeKick:
            {
                NSString *str = [NSString stringWithFormat:@"%@将%@", source, targets.firstObject];
                if (targets.count > 1) {
                    str = [str stringByAppendingFormat:@"等%zd人", targets.count];
                }
                str = [str stringByAppendingFormat:@"移出了%@", teamName];
                formatedMessage = str;
            }
                break;
            case NIMTeamOperationTypeUpdate:
            {
                id attachment = [content attachment];
                if ([attachment isKindOfClass:[NIMUpdateTeamInfoAttachment class]]) {
                    NIMUpdateTeamInfoAttachment *teamAttachment = (NIMUpdateTeamInfoAttachment *)attachment;
                    formatedMessage = [NSString stringWithFormat:@"%@更新了%@信息", source, teamName];
                    //如果只是单个项目项被修改则显示具体的修改项
                    if ([teamAttachment.values count] == 1) {
                        NIMTeamUpdateTag tag = [[[teamAttachment.values allKeys] firstObject] integerValue];
                        switch (tag)
                        {
                            case NIMTeamUpdateTagName:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@名称", source, teamName];
                                break;
                            case NIMTeamUpdateTagIntro:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@介绍", source, teamName];
                                break;
                            case NIMTeamUpdateTagAnouncement:
                                formatedMessage = [NSString stringWithFormat:@"%@公告: %@", teamName, [teamAttachment.values objectForKey:[NSNumber numberWithInteger:NIMTeamUpdateTagAnouncement]]];
                                break;
                            case NIMTeamUpdateTagJoinMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@验证方式", source, teamName];
                                break;
                            case NIMTeamUpdateTagAvatar:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@头像", source, teamName];
                                break;
                            case NIMTeamUpdateTagInviteMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了邀请他人权限", source];
                                break;
                            case NIMTeamUpdateTagBeInviteMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了被邀请人身份验证权限", source];
                                break;
                            case NIMTeamUpdateTagUpdateInfoMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了群资料修改权限", source];
                                break;
                            case NIMTeamUpdateTagMuteMode:{
                                NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId];
                                BOOL inAllMuteMode = [team inAllMuteMode];
                                formatedMessage = inAllMuteMode ? [NSString stringWithFormat:@"%@设置了群全体禁言", source] : [NSString stringWithFormat:@"%@取消了全体禁言", source];
                                break;
                            }
                            default:
                                break;
                        }
                    }
                }
                if (formatedMessage == nil) {
                    formatedMessage = [NSString stringWithFormat:@"%@更新了%@信息", source, teamName];
                }
            }
                break;
            case NIMTeamOperationTypeLeave:
                formatedMessage = [NSString stringWithFormat:@"%@离开了%@", source, teamName];
                break;
            case NIMTeamOperationTypeApplyPass:{
                if ([source isEqualToString:targetText]) {
                    //说明是以不需要验证的方式进入
                    formatedMessage = [NSString stringWithFormat:@"%@进入了%@", source, teamName];
                } else {
                    formatedMessage = [NSString stringWithFormat:@"%@通过了%@的申请", source, targetText];
                }
            }
                break;
            case NIMTeamOperationTypeTransferOwner:
                formatedMessage = [NSString stringWithFormat:@"%@转移了群主身份给%@", source, targetText];
                break;
            case NIMTeamOperationTypeAddManager:
                formatedMessage = [NSString stringWithFormat:@"%@被添加为群管理员", targetText];
                break;
            case NIMTeamOperationTypeRemoveManager:
                formatedMessage = [NSString stringWithFormat:@"%@被撤销了群管理员身份", targetText];
                break;
            case NIMTeamOperationTypeAcceptInvitation:
                formatedMessage = [NSString stringWithFormat:@"%@接受%@的邀请进群", source, targetText];
                break;
            case NIMTeamOperationTypeMute:{
                id attachment = [content attachment];
                if ([attachment isKindOfClass:[NIMMuteTeamMemberAttachment class]])
                {
                    BOOL mute = [(NIMMuteTeamMemberAttachment *)attachment flag];
                    NSString *muteStr = mute? @"禁言" : @"解除禁言";
                    NSString *str = [targets componentsJoinedByString:@","];
                    formatedMessage = [NSString stringWithFormat:@"%@被%@%@", str, source, muteStr];
                }
            }
                break;
            default:
                break;
        }
    }
    if (!formatedMessage.length) {
        formatedMessage = [NSString stringWithFormat:@"未知系统消息"];
    }
    return formatedMessage;
}

+ (NSString *)teamNotificationSourceName:(NIMMessage *)message
{
    NSString *source;
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if ([content.sourceID isEqualToString:currentAccount]) {
        source = @"你";
    } else {
        source = [JTUserInfoHandle showNick:content.sourceID inSession:message.session];
    }
    return source;
}

+ (NSArray *)teamNotificationTargetNames:(NIMMessage *)message
{
    NSMutableArray *targets = [[NSMutableArray alloc] init];
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    for (NSString *item in content.targetIDs) {
        if ([item isEqualToString:currentAccount]) {
            [targets addObject:@"你"];
        } else {
            [targets addObject:[JTUserInfoHandle showNick:item inSession:message.session]];
        }
    }
    return targets;
}

+ (NSString *)teamNotificationTeamShowName:(NIMMessage *)message
{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId];
    NSString *teamName = (team.type == NIMTeamTypeNormal) ? @"讨论组" : @"群";
    return teamName;
}


+ (NSString *)netcallNotificationFormatedMessage:(NIMMessage *)message
{
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
    NSString *text = @"";
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    switch (content.eventType) {
        case NIMNetCallEventTypeMiss:
        {
            text = @"对方已取消 ";
        }
            break;
        case NIMNetCallEventTypeBill:
        {
            text = [NSString stringWithFormat:@"聊天时长 %02d:%02d ", (int)content.duration/60,(int)content.duration%60];
        }
            break;
        case NIMNetCallEventTypeReject:
        {
            text = ([object.message.from isEqualToString:currentAccount]) ? @"对方已拒绝 " : @"已取消 ";
        }
            break;
        case NIMNetCallEventTypeNoResponse:
        {
            text = @"已取消 ";
        }
            break;
        default:
            break;
    }
    return text;
}

+ (NSString *)chatroomNotificationFormatedMessage:(NIMMessage *)message
{
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
    NSMutableArray *targetNicks = [[NSMutableArray alloc] init];
    for (NIMChatroomNotificationMember *memebr in content.targets) {
        if ([memebr.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            [targetNicks addObject:@"你"];
        } else {
            [targetNicks addObject:memebr.nick];
        }
    }
    NSString *targetText =[targetNicks componentsJoinedByString:@","];
    switch (content.eventType) {
        case NIMChatroomEventTypeEnter:
        {
            return [NSString stringWithFormat:@"欢迎%@进入直播间", targetText];
        }
        case NIMChatroomEventTypeAddBlack:
        {
            return [NSString stringWithFormat:@"%@被管理员拉入黑名单", targetText];
        }
        case NIMChatroomEventTypeRemoveBlack:
        {
            return [NSString stringWithFormat:@"%@被管理员解除拉黑", targetText];
        }
        case NIMChatroomEventTypeAddMute:
        {
            if (content.targets.count == 1 && [[content.targets.firstObject userId] isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
            {
                return @"你已被禁言";
            }
            else
            {
                return [NSString stringWithFormat:@"%@被管理员禁言", targetText];
            }
        }
        case NIMChatroomEventTypeRemoveMute:
        {
            return [NSString stringWithFormat:@"%@被管理员解除禁言", targetText];
        }
        case NIMChatroomEventTypeAddManager:
        {
            return [NSString stringWithFormat:@"%@被任命管理员身份", targetText];
        }
        case NIMChatroomEventTypeRemoveManager:
        {
            return [NSString stringWithFormat:@"%@被解除管理员身份", targetText];
        }
        case NIMChatroomEventTypeRemoveCommon:
        {
            return [NSString stringWithFormat:@"%@被解除直播室成员身份", targetText];
        }
        case NIMChatroomEventTypeAddCommon:
        {
            return [NSString stringWithFormat:@"%@被添加为直播室成员身份", targetText];
        }
        case NIMChatroomEventTypeInfoUpdated:
        {
            return [NSString stringWithFormat:@"直播间公告已更新"];
        }
        case NIMChatroomEventTypeKicked:
        {
            return [NSString stringWithFormat:@"%@被管理员移出直播间", targetText];
        }
        case NIMChatroomEventTypeExit:
        {
            return [NSString stringWithFormat:@"%@离开了直播间", targetText];
        }
        case NIMChatroomEventTypeClosed:
        {
            return [NSString stringWithFormat:@"直播间已关闭"];
        }
        case NIMChatroomEventTypeAddMuteTemporarily:
        {
            if (content.targets.count == 1 && [[content.targets.firstObject userId] isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
            {
                return @"你已被临时禁言";
            }
            else
            {
                return [NSString stringWithFormat:@"%@被管理员禁言", targetText];
            }
        }
        case NIMChatroomEventTypeRemoveMuteTemporarily:
        {
            return [NSString stringWithFormat:@"%@被管理员解除临时禁言", targetText];
        }
        case NIMChatroomEventTypeMemberUpdateInfo:
        {
            return [NSString stringWithFormat:@"%@更新了自己的个人信息", targetText];
        }
        case NIMChatroomEventTypeRoomMuted:
        {
            return @"全体禁言，管理员可发言";
        }
        case NIMChatroomEventTypeRoomUnMuted:
        {
            return @"解除全体禁言";
        }
        default:
            break;
    }
    return @"";
}

+ (BOOL)canMessageBeRevoked:(NIMMessage *)message
{
    BOOL isFromMe = [message.from isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    BOOL isToMe   = [message.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    BOOL isDeliverFailed = !message.isReceivedMsg && message.deliveryState == NIMMessageDeliveryStateFailed;
    if (!isFromMe || isToMe || isDeliverFailed) {
        return NO;
    }
    id<NIMMessageObject> messageobject = message.messageObject;
    if ([messageobject isKindOfClass:[NIMTipObject class]]
        || [messageobject isKindOfClass:[NIMNotificationObject class]]) {
        return NO;
    }
    return YES;
}

+ (NSString *)tipOnMessageRevoked:(id)message
{
    NSString *fromUid = nil;
    NIMSession *session = nil;
    
    if ([message isKindOfClass:[NIMMessage class]])
    {
        fromUid = [(NIMMessage *)message from];
        session = [(NIMMessage *)message session];
    }
    else if([message isKindOfClass:[NIMRevokeMessageNotification class]])
    {
        fromUid = [(NIMRevokeMessageNotification *)message fromUserId];
        session = [(NIMRevokeMessageNotification *)message session];
    }
    else
    {
        assert(0);
    }
    
    BOOL isFromMe = [fromUid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    NSString *tip = @"你";
    if (!isFromMe) {
        switch (session.sessionType) {
            case NIMSessionTypeP2P:
                tip = @"对方";
                break;
            case NIMSessionTypeTeam:{
                tip = [JTUserInfoHandle showNick:fromUid inSession:session];
            }
                break;
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"%@撤回了一条消息", tip];
}
@end
