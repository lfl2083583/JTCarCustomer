//
//  JTCustomAttachmentDecoder.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/10.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCustomAttachmentDecoder.h"
#import "JTCustomAttachmentDefines.h"
#import "NSDictionary+Json.h"
#import "JTExpressionAttachment.h"
#import "JTCardAttachment.h"
#import "JTBonusAttachment.h"
#import "JTCallBonusAttachment.h"
#import "JTTeamOperationAttachment.h"
#import "JTTipAttachment.h"
#import "JTEvaluationAttachment.h"
#import "JTVideoAttachment.h"
#import "JTImageAttachment.h"
#import "JTGroupAttachment.h"
#import "JTInformationAttachment.h"
#import "JTActivityAttachment.h"
#import "JTShopAttachment.h"

#import "JTTeamInviteAttachment.h"
#import "JTTeamInviteRefuseAttachment.h"
#import "JTTeamApplyAttachment.h"
#import "JTTeamApplyRefuseAttachment.h"
#import "JTTeamRemoveAttachment.h"
#import "JTTeamDismissAttachment.h"

#import "JTFunsAttachment.h"

#import "JTMoneyBonusReturnAttachment.h"

#import "JTActivityPromptAttachment.h"
#import "JTBusinessReplyAttachment.h"
#import "JTIdentityAuthAttachment.h"
#import "JTCarAuthAttachment.h"

#import "JTCommentActivityAttachment.h"
#import "JTCommentInformationAttachment.h"

#import "JTTeamOwnerTipAttachment.h"

@implementation JTCustomAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment = nil;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        NSLog(@"IM MSG:%@  thread:%@", dict, [NSThread currentThread]);
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:CMType];
            NSDictionary *data = [dict jsonDict:CMData];
            switch (type) {
                case CustomMessageTypeExpression:
                {
                    attachment = [[JTExpressionAttachment alloc] init];
                    ((JTExpressionAttachment *)attachment).expressionId              = [data jsonString:CMExpressionId];
                    ((JTExpressionAttachment *)attachment).expressionName            = [data jsonString:CMExpressionName];
                    ((JTExpressionAttachment *)attachment).expressionUrl             = [data jsonString:CMExpressionUrl];
                    ((JTExpressionAttachment *)attachment).expressionThumbnail       = [data jsonString:CMExpressionThumbnail];
                    ((JTExpressionAttachment *)attachment).expressionWidth           = [data jsonString:CMExpressionWidht];
                    ((JTExpressionAttachment *)attachment).expressionHeight          = [data jsonString:CMExpressionHeight];
                }
                    break;
                case CustomMessageTypeCard:
                {
                    attachment = [[JTCardAttachment alloc] init];
                    ((JTCardAttachment *)attachment).userId                  = [data jsonString:CMCardUserId];
                    ((JTCardAttachment *)attachment).userName                = [data jsonString:CMCardUserName];
                    ((JTCardAttachment *)attachment).userNumber              = [data jsonString:CMCardUserNumber];
                    ((JTCardAttachment *)attachment).avatarUrlString         = [data jsonString:CMCardAvatar];
                }
                    break;
                case CustomMessageTypeBonus:
                {
                    attachment = [[JTBonusAttachment alloc] init];
                    ((JTBonusAttachment *)attachment).fromId           = [data jsonString:CMBonusFromID];
                    ((JTBonusAttachment *)attachment).from_yxAccId     = [data jsonString:CMBonusFromYXAccID];
                    ((JTBonusAttachment *)attachment).bonusId          = [data jsonString:CMBonusID];
                    ((JTBonusAttachment *)attachment).content          = [data jsonString:CMBonusContent];
                    ((JTBonusAttachment *)attachment).money            = [data jsonString:CMBonusMoney];
                    ((JTBonusAttachment *)attachment).count            = [data jsonString:CMBonusCount];
                    ((JTBonusAttachment *)attachment).type             = [data jsonInteger:CMBonusType];
                    ((JTBonusAttachment *)attachment).createDate       = [data jsonString:CMBonusCreateDate];
                    ((JTBonusAttachment *)attachment).isGrabbed        = [data jsonBool:CMBonusGrabbed];
                    ((JTBonusAttachment *)attachment).isOverTime       = [data jsonBool:CMBonusOverTime];
                    ((JTBonusAttachment *)attachment).isOverGrab       = [data jsonBool:CMBonusOverGrab];
                }
                    break;
                case CustomMessageTypeCallBonus:
                {
                    attachment = [[JTCallBonusAttachment alloc] init];
                    ((JTCallBonusAttachment *)attachment).fromId          = [data jsonString:CMCallBonusFromId];
                    ((JTCallBonusAttachment *)attachment).fromName        = [data jsonString:CMCallBonusFromName];
                    ((JTCallBonusAttachment *)attachment).bonusId         = [data jsonString:CMCallBonusId];
                    ((JTCallBonusAttachment *)attachment).toId            = [data jsonString:CMCallBonusToId];
                    ((JTCallBonusAttachment *)attachment).toName          = [data jsonString:CMCallBonusToName];
                    ((JTCallBonusAttachment *)attachment).sessionID       = [data jsonString:CMCallBonusSessionID];
                    ((JTCallBonusAttachment *)attachment).bonusType       = [data jsonInteger:CMCallBonusType];
                    ((JTCallBonusAttachment *)attachment).lastFlag        = [data jsonString:CMCallBonusLastFlag];
                }
                    break;
                case CustomMessageTypeTeamOperation:
                {
                    attachment = [[JTTeamOperationAttachment alloc] init];
                    ((JTTeamOperationAttachment *)attachment).actionType      = [data jsonString:CMTeamOperationActionType];
                    ((JTTeamOperationAttachment *)attachment).sessionId       = [data jsonString:CMTeamOperationSessionId];
                    ((JTTeamOperationAttachment *)attachment).userInfo        = [data jsonDict:CMTeamOperationUserInfo];
                    ((JTTeamOperationAttachment *)attachment).userList        = [data jsonArray:CMTeamOperationUserList];
                    ((JTTeamOperationAttachment *)attachment).message         = [data jsonString:CMTeamOperationMessage];
                }
                    break;
                case CustomMessageTypeTip:
                {
                    attachment = [[JTTipAttachment alloc] init];
                    ((JTTipAttachment *)attachment).text      = [data jsonString:CMTipText];
                }
                    break;
                case CustomMessageTypeEvaluation:
                {
                    attachment = [[JTEvaluationAttachment alloc] init];
                    ((JTEvaluationAttachment *)attachment).text      = [data jsonString:CMEvaluationText];
                }
                    break;
                case CustomMessageTypeVideo:
                {
                    attachment = [[JTVideoAttachment alloc] init];
                    ((JTVideoAttachment *)attachment).videoUrl           = [data jsonString:CMCustomVideoUrl];
                    ((JTVideoAttachment *)attachment).videoCoverUrl      = [data jsonString:CMCustomVideoCoverUrl];
                    ((JTVideoAttachment *)attachment).videoWidth         = [data jsonString:CMCustomVideoWidth];
                    ((JTVideoAttachment *)attachment).videoHeight        = [data jsonString:CMCustomVideoHeight];
                }
                    break;
                case CustomMessageTypeImage:
                {
                    attachment = [[JTImageAttachment alloc] init];
                    ((JTImageAttachment *)attachment).imageUrl           = [data jsonString:CMCustomImageUrl];
                    ((JTImageAttachment *)attachment).imageThumbnail     = [data jsonString:CMCustomImageThumbnail];
                    ((JTImageAttachment *)attachment).imageWidth         = [data jsonString:CMCustomImageWidth];
                    ((JTImageAttachment *)attachment).imageHeight        = [data jsonString:CMCustomImageHeight];
                }
                    break;
                case CustomMessageTypeGroup:
                {
                    attachment = [[JTGroupAttachment alloc] init];
                    ((JTGroupAttachment *)attachment).groupId      = [data jsonString:CMCustomGroupID];
                    ((JTGroupAttachment *)attachment).name         = [data jsonString:CMCustomGroupName];
                    ((JTGroupAttachment *)attachment).icon         = [data jsonString:CMCustomGroupIcon];
                }
                    break;
                case CustomMessageTypeInformation:
                {
                    attachment = [[JTInformationAttachment alloc] init];
                    ((JTInformationAttachment *)attachment).informationId    = [data jsonString:CMCustomInformationID];
                    ((JTInformationAttachment *)attachment).h5Url            = [data jsonString:CMCustomInformationH5Url];
                    ((JTInformationAttachment *)attachment).coverUrl         = [data jsonString:CMCustomInformationCoverUrl];
                    ((JTInformationAttachment *)attachment).title            = [data jsonString:CMCustomInformationTitle];
                    ((JTInformationAttachment *)attachment).content          = [data jsonString:CMCustomInformationContent];
                }
                    break;
                case CustomMessageTypeActivity:
                {
                    attachment = [[JTActivityAttachment alloc] init];
                    ((JTActivityAttachment *)attachment).activityId           = [data jsonString:CMCustomActivityID];
                    ((JTActivityAttachment *)attachment).coverUrl             = [data jsonString:CMCustomActivityCoverUrl];
                    ((JTActivityAttachment *)attachment).theme                = [data jsonString:CMCustomActivityTheme];
                    ((JTActivityAttachment *)attachment).time                 = [data jsonString:CMCustomActivityTime];
                    ((JTActivityAttachment *)attachment).address              = [data jsonString:CMCustomActivityAddress];
                }
                    break;
                case CustomMessageTypeShop:
                {
                    attachment = [[JTShopAttachment alloc] init];
                    ((JTShopAttachment *)attachment).shopId           = [data jsonString:CMCustomShopID];
                    ((JTShopAttachment *)attachment).coverUrl         = [data jsonString:CMCustomShopCoverUrl];
                    ((JTShopAttachment *)attachment).name             = [data jsonString:CMCustomShopName];
                    ((JTShopAttachment *)attachment).score            = [data jsonString:CMCustomShopScore];
                    ((JTShopAttachment *)attachment).time             = [data jsonString:CMCustomShopTime];
                    ((JTShopAttachment *)attachment).address          = [data jsonString:CMCustomShopAddress];
                }
                    break;
                    
                    
                    
                case CustomMessageTypeTeamInvite:
                {
                    attachment = [[JTTeamInviteAttachment alloc] init];
                    ((JTTeamInviteAttachment *)attachment).inviteId          = [data jsonString:CMTeamInviteId];
                    ((JTTeamInviteAttachment *)attachment).userId            = [data jsonString:CMTeamInviteUserId];
                    ((JTTeamInviteAttachment *)attachment).yunxinID          = [data jsonString:CMTeamInviteYunXinId];
                    ((JTTeamInviteAttachment *)attachment).userName          = [data jsonString:CMTeamInviteUserName];
                    ((JTTeamInviteAttachment *)attachment).avatarUrlString   = [data jsonString:CMTeamInviteUserAvatar];
                    ((JTTeamInviteAttachment *)attachment).teamId            = [data jsonString:CMTeamInviteTeamId];
                    ((JTTeamInviteAttachment *)attachment).teamName          = [data jsonString:CMTeamInviteTeamName];
                    ((JTTeamInviteAttachment *)attachment).joinType          = [data jsonString:CMTeamInviteJoinType];
                    ((JTTeamInviteAttachment *)attachment).inviteTime        = [data jsonString:CMTeamInviteTime];
                    ((JTTeamInviteAttachment *)attachment).operationType     = [data jsonInteger:CMTeamInviteOperationType];
                }
                    break;
                case CustomMessageTypeTeamInviteRefuse:
                {
                    attachment = [[JTTeamInviteRefuseAttachment alloc] init];
                    ((JTTeamInviteRefuseAttachment *)attachment).inviteId          = [data jsonString:CMTeamInviteRefuseInviteId];
                    ((JTTeamInviteRefuseAttachment *)attachment).userId            = [data jsonString:CMTeamInviteRefuseUserId];
                    ((JTTeamInviteRefuseAttachment *)attachment).yunxinID          = [data jsonString:CMTeamInviteRefuseYunXinId];
                    ((JTTeamInviteRefuseAttachment *)attachment).userName          = [data jsonString:CMTeamInviteRefuseUserName];
                    ((JTTeamInviteRefuseAttachment *)attachment).avatarUrlString   = [data jsonString:CMTeamInviteRefuseUserAvatar];
                    ((JTTeamInviteRefuseAttachment *)attachment).teamId            = [data jsonString:CMTeamInviteRefuseTeamId];
                    ((JTTeamInviteRefuseAttachment *)attachment).teamName          = [data jsonString:CMTeamInviteRefuseTeamName];
                    ((JTTeamInviteRefuseAttachment *)attachment).inviteRefuseTime  = [data jsonString:CMTeamInviteRefuseTime];
                    ((JTTeamInviteRefuseAttachment *)attachment).operationType     = [data jsonInteger:CMTeamInviteOperationType];
                }
                    break;
                case CustomMessageTypeTeamApply:
                {
                    attachment = [[JTTeamApplyAttachment alloc] init];
                    ((JTTeamApplyAttachment *)attachment).inviteId          = [data jsonString:CMTeamApplyInviteId];
                    ((JTTeamApplyAttachment *)attachment).userId            = [data jsonString:CMTeamApplyUserId];
                    ((JTTeamApplyAttachment *)attachment).yunxinID          = [data jsonString:CMTeamApplyYunXinId];
                    ((JTTeamApplyAttachment *)attachment).userName          = [data jsonString:CMTeamApplyUserName];
                    ((JTTeamApplyAttachment *)attachment).avatarUrlString   = [data jsonString:CMTeamApplyUserAvatar];
                    ((JTTeamApplyAttachment *)attachment).teamId            = [data jsonString:CMTeamApplyTeamId];
                    ((JTTeamApplyAttachment *)attachment).teamName          = [data jsonString:CMTeamApplyTeamName];
                    ((JTTeamApplyAttachment *)attachment).remarks           = [data jsonString:CMTeamApplyRemarks];
                    ((JTTeamApplyAttachment *)attachment).joinType          = [data jsonString:CMTeamApplyJoinType];
                    ((JTTeamApplyAttachment *)attachment).applyTime         = [data jsonString:CMTeamApplyTime];
                    ((JTTeamApplyAttachment *)attachment).operationType     = [data jsonInteger:CMTeamApplyOperationType];
                }
                    break;
                case CustomMessageTypeTeamApplyRefuse:
                {
                    attachment = [[JTTeamApplyRefuseAttachment alloc] init];
                    ((JTTeamApplyRefuseAttachment *)attachment).teamId            = [data jsonString:CMTeamApplyRefuseTeamId];
                    ((JTTeamApplyRefuseAttachment *)attachment).teamName          = [data jsonString:CMTeamApplyRefuseTeamName];
                    ((JTTeamApplyRefuseAttachment *)attachment).teamAvatar        = [data jsonString:CMTeamApplyRefuseTeamAvatar];
                    ((JTTeamApplyRefuseAttachment *)attachment).userId            = [data jsonString:CMTeamApplyRefuseUserId];
                    ((JTTeamApplyRefuseAttachment *)attachment).yunxinID          = [data jsonString:CMTeamApplyRefuseYunXinId];
                    ((JTTeamApplyRefuseAttachment *)attachment).userName          = [data jsonString:CMTeamApplyRefuseUserName];
                    ((JTTeamApplyRefuseAttachment *)attachment).applyRefuseTime   = [data jsonString:CMTeamApplyRefuseTime];
                    ((JTTeamApplyRefuseAttachment *)attachment).inviteId          = [data jsonString:CMTeamApplyRefuseInviteId];
                    ((JTTeamApplyRefuseAttachment *)attachment).joinType          = [data jsonString:CMTeamApplyRefuseJoinType];
                    ((JTTeamApplyRefuseAttachment *)attachment).operationType     = [data jsonInteger:CMTeamApplyRefuseOperationType];
                }
                    break;
                case CustomMessageTypeTeamRemove:
                {
                    attachment = [[JTTeamRemoveAttachment alloc] init];
                    ((JTTeamRemoveAttachment *)attachment).teamId            = [data jsonString:CMTeamRemoveTeamId];
                    ((JTTeamRemoveAttachment *)attachment).teamName          = [data jsonString:CMTeamRemoveTeamName];
                    ((JTTeamRemoveAttachment *)attachment).teamAvatar        = [data jsonString:CMTeamRemoveTeamAvatar];
                    ((JTTeamRemoveAttachment *)attachment).userId            = [data jsonString:CMTeamRemoveUserId];
                    ((JTTeamRemoveAttachment *)attachment).yunxinID          = [data jsonString:CMTeamRemoveYunXinId];
                    ((JTTeamRemoveAttachment *)attachment).userName          = [data jsonString:CMTeamRemoveUserName];
                    ((JTTeamRemoveAttachment *)attachment).removeTime        = [data jsonString:CMTeamRemoveTime];
                    ((JTTeamRemoveAttachment *)attachment).operationType     = [data jsonInteger:CMTeamRemoveOperationType];
                }
                    break;
                case CustomMessageTypeTeamDismiss:
                {
                    attachment = [[JTTeamDismissAttachment alloc] init];
                    ((JTTeamDismissAttachment *)attachment).teamId            = [data jsonString:CMTeamDismissTeamId];
                    ((JTTeamDismissAttachment *)attachment).teamName          = [data jsonString:CMTeamDismissTeamName];
                    ((JTTeamDismissAttachment *)attachment).teamAvatar        = [data jsonString:CMTeamDismissTeamAvatar];
                    ((JTTeamDismissAttachment *)attachment).userId            = [data jsonString:CMTeamDismissUserId];
                    ((JTTeamDismissAttachment *)attachment).yunxinID          = [data jsonString:CMTeamDismissYunXinId];
                    ((JTTeamDismissAttachment *)attachment).userName          = [data jsonString:CMTeamDismissUserName];
                    ((JTTeamDismissAttachment *)attachment).dismissTime       = [data jsonString:CMTeamDismissTime];
                }
                    break;
                    
                    
                    
                case CustomMessageFuns:
                {
                    attachment = [[JTFunsAttachment alloc] init];
                    ((JTFunsAttachment *)attachment).userId       = [data jsonString:CMFunsUserId];
                    ((JTFunsAttachment *)attachment).yunxinId     = [data jsonString:CMFunsYunXinId];
                    ((JTFunsAttachment *)attachment).type         = [data jsonInteger:CMFunsType];
                    ((JTFunsAttachment *)attachment).time         = [data jsonString:CMFunsTime];
                }
                    break;
                    
                    
                    
                case CustomMessageTypeMoneyBonusReturn:
                {
                    attachment = [[JTMoneyBonusReturnAttachment alloc] init];
                    ((JTMoneyBonusReturnAttachment *)attachment).bonusId       = [data jsonString:CMMoneyBonusReturnBonusId];
                    ((JTMoneyBonusReturnAttachment *)attachment).title         = [data jsonString:CMMoneyBonusReturnTitle];
                    ((JTMoneyBonusReturnAttachment *)attachment).money         = [data jsonString:CMMoneyBonusReturnMoney];
                    ((JTMoneyBonusReturnAttachment *)attachment).reason        = [data jsonString:CMMoneyBonusReturnReason];
                    ((JTMoneyBonusReturnAttachment *)attachment).time          = [data jsonString:CMMoneyBonusReturnTime];
                    ((JTMoneyBonusReturnAttachment *)attachment).remarks       = [data jsonString:CMMoneyBonusReturnRemarks];
                }
                    break;
                    
                    
                    
                case CustomMessageTypeActivityPrompt:
                {
                    attachment = [[JTActivityPromptAttachment alloc] init];
                    ((JTActivityPromptAttachment *)attachment).activityID       = [data jsonString:CMActivityID];
                    ((JTActivityPromptAttachment *)attachment).content          = [data jsonString:CMActivityContent];
                }
                    break;
                case CustomMessageTypeBusinessReply:
                {
                    attachment = [[JTBusinessReplyAttachment alloc] init];
                    ((JTBusinessReplyAttachment *)attachment).content       = [data jsonString:CMBusinessReplyContent];
                }
                    break;
                case CustomMessageTypeIdentityAuth:
                {
                    attachment = [[JTIdentityAuthAttachment alloc] init];
                    ((JTIdentityAuthAttachment *)attachment).status      = [data jsonInteger:CMIdentityAuthStatus];
                    ((JTIdentityAuthAttachment *)attachment).content     = [data jsonString:CMIdentityAuthContent];
                }
                    break;
                case CustomMessageTypeCarAuth:
                {
                    attachment = [[JTCarAuthAttachment alloc] init];
                    ((JTCarAuthAttachment *)attachment).status       = [data jsonInteger:CMCarAuthStatus];
                    ((JTCarAuthAttachment *)attachment).content      = [data jsonString:CMCarAuthContent];
                    ((JTCarAuthAttachment *)attachment).carID        = [data jsonString:CMCarAuthID];
                }
                    break;
                    
                    
                    
                case CustomMessageTypeCommentActivity:
                {
                    attachment = [[JTCommentActivityAttachment alloc] init];
                    ((JTCommentActivityAttachment *)attachment).avatarUrl      = [data jsonString:CMCommentActivityAvatarUrl];
                    ((JTCommentActivityAttachment *)attachment).name           = [data jsonString:CMCommentActivityName];
                    ((JTCommentActivityAttachment *)attachment).userID         = [data jsonString:CMCommentActivityUserID];
                    ((JTCommentActivityAttachment *)attachment).content        = [data jsonString:CMCommentActivityContent];
                    ((JTCommentActivityAttachment *)attachment).time           = [data jsonInteger:CMCommentActivityTime];
                    ((JTCommentActivityAttachment *)attachment).coverUrl       = [data jsonString:CMCommentActivityCoverUrl];
                    ((JTCommentActivityAttachment *)attachment).activityUrl    = [data jsonString:CMCommentActivityUrl];
                    ((JTCommentActivityAttachment *)attachment).activityID     = [data jsonString:CMCommentActivityID];
                }
                    break;
                case CustomMessageTypeCommentInformation:
                {
                    attachment = [[JTCommentInformationAttachment alloc] init];
                    ((JTCommentInformationAttachment *)attachment).avatarUrl         = [data jsonString:CMCommentInformationAvatarUrl];
                    ((JTCommentInformationAttachment *)attachment).name              = [data jsonString:CMCommentInformationName];
                    ((JTCommentInformationAttachment *)attachment).userID            = [data jsonString:CMCommentInformationUserID];
                    ((JTCommentInformationAttachment *)attachment).content           = [data jsonString:CMCommentInformationContent];
                    ((JTCommentInformationAttachment *)attachment).time              = [data jsonInteger:CMCommentInformationTime];
                    ((JTCommentInformationAttachment *)attachment).coverUrl          = [data jsonString:CMCommentInformationCoverUrl];
                    ((JTCommentInformationAttachment *)attachment).informationUrl    = [data jsonString:CMCommentInformationUrl];
                    ((JTCommentInformationAttachment *)attachment).informationID     = [data jsonString:CMCommentInformationID];
                }
                    break;
                    
                    
                    
                case CustomMessageTypeTeamOwnerTip:
                {
                    attachment = [[JTTeamOwnerTipAttachment alloc] init];
                    ((JTTeamOwnerTipAttachment *)attachment).text      = [data jsonString:CMTeamOwnerTipText];
                }
                    break;
                    
                default:
                    break;
            }
            attachment = [self checkAttachment:attachment] ? attachment : nil;
        }
    }
    return attachment;
}

- (BOOL)checkAttachment:(id<NIMCustomAttachment>)attachment
{
    BOOL check = NO;
    if ([attachment isKindOfClass:[JTExpressionAttachment class]]) {
        NSString *expressionUrl = ((JTExpressionAttachment *)attachment).expressionUrl;
        NSString *expressionThumbnail = ((JTExpressionAttachment *)attachment).expressionThumbnail;
        check = expressionUrl.length&&expressionThumbnail.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTCardAttachment class]]) {
        NSString *userName   = ((JTCardAttachment *)attachment).userName;
        NSString *userId     = ((JTCardAttachment *)attachment).userId;
        check = userName.length&&userId.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTBonusAttachment class]]) {
        NSString *fromId   = ((JTBonusAttachment *)attachment).fromId;
        NSString *bonusId  = ((JTBonusAttachment *)attachment).bonusId;
        check = fromId.length&&bonusId.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTCallBonusAttachment class]]) {
        NSString *fromId             = ((JTCallBonusAttachment *)attachment).fromId;
        NSString *bonusId            = ((JTCallBonusAttachment *)attachment).bonusId;
        NSString *toId               = ((JTCallBonusAttachment *)attachment).toId;
        NSString *lastFlag           = ((JTCallBonusAttachment *)attachment).lastFlag;
        check = fromId.length&&bonusId.length&&toId.length&&lastFlag.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTTeamOperationAttachment class]]) {
        NSString *actionType      = ((JTTeamOperationAttachment *)attachment).actionType;
        NSString *sessionId       = ((JTTeamOperationAttachment *)attachment).sessionId;
        NSDictionary *userInfo    = ((JTTeamOperationAttachment *)attachment).userInfo;
        NSArray *userList         = ((JTTeamOperationAttachment *)attachment).userList;
        check = actionType.length&&sessionId.length&&userInfo&&userList ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTTipAttachment class]]) {
        NSString *text      = ((JTTipAttachment *)attachment).text;
        check = text.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTEvaluationAttachment class]]) {
        NSString *text      = ((JTEvaluationAttachment *)attachment).text;
        check = text.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTVideoAttachment class]]) {
        NSString *videoUrl          = ((JTVideoAttachment *)attachment).videoUrl;
        NSString *videoCoverUrl     = ((JTVideoAttachment *)attachment).videoCoverUrl;
        NSString *videoWidth        = ((JTVideoAttachment *)attachment).videoWidth;
        NSString *videoHeight       = ((JTVideoAttachment *)attachment).videoHeight;
        check = videoUrl.length&&videoCoverUrl.length&&videoWidth.length&&videoHeight.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTImageAttachment class]]) {
        NSString *imageUrl          = ((JTImageAttachment *)attachment).imageUrl;
        NSString *imageThumbnail    = ((JTImageAttachment *)attachment).imageThumbnail;
        NSString *imageWidth        = ((JTImageAttachment *)attachment).imageWidth;
        NSString *imageHeight       = ((JTImageAttachment *)attachment).imageHeight;
        check = imageUrl.length&&imageThumbnail.length&&imageWidth.length&&imageHeight.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTGroupAttachment class]]) {
        NSString *groupId          = ((JTGroupAttachment *)attachment).groupId;
        NSString *name             = ((JTGroupAttachment *)attachment).name;
        NSString *icon             = ((JTGroupAttachment *)attachment).icon;
        check = groupId.length&&name.length&&icon.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTInformationAttachment class]]) {
        NSString *informationId     = ((JTInformationAttachment *)attachment).informationId;
        NSString *h5Url             = ((JTInformationAttachment *)attachment).h5Url;
        NSString *title             = ((JTInformationAttachment *)attachment).title;
        NSString *content           = ((JTInformationAttachment *)attachment).content;
        check = informationId.length&&h5Url.length&&title.length&&content.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTActivityAttachment class]]) {
        NSString *activityId  = ((JTActivityAttachment *)attachment).activityId;
        NSString *coverUrl    = ((JTActivityAttachment *)attachment).coverUrl;
        NSString *theme       = ((JTActivityAttachment *)attachment).theme;
        NSString *time        = ((JTActivityAttachment *)attachment).time;
        NSString *address     = ((JTActivityAttachment *)attachment).address;
        check = activityId.length&&coverUrl.length&&theme.length&&time.length&&address.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTShopAttachment class]]) {
        NSString *shopId      = ((JTShopAttachment *)attachment).shopId;
        NSString *coverUrl    = ((JTShopAttachment *)attachment).coverUrl;
        NSString *name        = ((JTShopAttachment *)attachment).name;
        NSString *score       = ((JTShopAttachment *)attachment).score;
        NSString *time        = ((JTShopAttachment *)attachment).time;
        NSString *address     = ((JTShopAttachment *)attachment).address;
        check = shopId.length&&coverUrl.length&&name.length&&score.length&&time.length&&address.length ? YES : NO;
    }
    
    else if ([attachment isKindOfClass:[JTTeamInviteAttachment class]]) {
        NSString *inviteId               = ((JTTeamInviteAttachment *)attachment).inviteId;
        NSString *userId                 = ((JTTeamInviteAttachment *)attachment).userId;
        NSString *yunxinID               = ((JTTeamInviteAttachment *)attachment).yunxinID;
        NSString *userName               = ((JTTeamInviteAttachment *)attachment).userName;
        NSString *avatarUrlString        = ((JTTeamInviteAttachment *)attachment).avatarUrlString;
        NSString *teamId                 = ((JTTeamInviteAttachment *)attachment).teamId;
        NSString *teamName               = ((JTTeamInviteAttachment *)attachment).teamName;
        NSString *joinType               = ((JTTeamInviteAttachment *)attachment).joinType;
        NSString *inviteTime             = ((JTTeamInviteAttachment *)attachment).inviteTime;
        check = inviteId.length&&userId.length&&yunxinID.length&&userName.length&&avatarUrlString.length&&teamId.length&&teamName.length&&joinType.length&&inviteTime.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTTeamInviteRefuseAttachment class]]) {
        NSString *inviteId               = ((JTTeamInviteRefuseAttachment *)attachment).inviteId;
        NSString *userId                 = ((JTTeamInviteRefuseAttachment *)attachment).userId;
        NSString *yunxinID               = ((JTTeamInviteRefuseAttachment *)attachment).yunxinID;
        NSString *userName               = ((JTTeamInviteRefuseAttachment *)attachment).userName;
        NSString *avatarUrlString        = ((JTTeamInviteRefuseAttachment *)attachment).avatarUrlString;
        NSString *teamId                 = ((JTTeamInviteRefuseAttachment *)attachment).teamId;
        NSString *teamName               = ((JTTeamInviteRefuseAttachment *)attachment).teamName;
        NSString *inviteRefuseTime       = ((JTTeamInviteRefuseAttachment *)attachment).inviteRefuseTime;
        check = inviteId.length&&userId.length&&yunxinID.length&&userName.length&&avatarUrlString.length&&teamId.length&&teamName.length&&inviteRefuseTime.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTTeamApplyAttachment class]]) {
        NSString *userId                 = ((JTTeamApplyAttachment *)attachment).userId;
        NSString *yunxinID               = ((JTTeamApplyAttachment *)attachment).yunxinID;
        NSString *userName               = ((JTTeamApplyAttachment *)attachment).userName;
        NSString *avatarUrlString        = ((JTTeamApplyAttachment *)attachment).avatarUrlString;
        NSString *teamId                 = ((JTTeamApplyAttachment *)attachment).teamId;
        NSString *teamName               = ((JTTeamApplyAttachment *)attachment).teamName;
        NSString *applyTime              = ((JTTeamApplyAttachment *)attachment).applyTime;
        check = userId.length&&yunxinID.length&&userName.length&&avatarUrlString.length&&teamId.length&&teamName.length&&applyTime.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTTeamApplyRefuseAttachment class]]) {
        NSString *teamId                 = ((JTTeamApplyRefuseAttachment *)attachment).teamId;
        NSString *teamName               = ((JTTeamApplyRefuseAttachment *)attachment).teamName;
        NSString *teamAvatar             = ((JTTeamApplyRefuseAttachment *)attachment).teamAvatar;
        NSString *userId                 = ((JTTeamApplyRefuseAttachment *)attachment).userId;
        NSString *yunxinID               = ((JTTeamApplyRefuseAttachment *)attachment).yunxinID;
        NSString *userName               = ((JTTeamApplyRefuseAttachment *)attachment).userName;
        NSString *applyRefuseTime        = ((JTTeamApplyRefuseAttachment *)attachment).applyRefuseTime;
        check = teamId.length&&teamName.length&&teamAvatar.length&&userId.length&&yunxinID.length&&userName.length&&applyRefuseTime.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTTeamRemoveAttachment class]]) {
        NSString *teamId                 = ((JTTeamRemoveAttachment *)attachment).teamId;
        NSString *teamName               = ((JTTeamRemoveAttachment *)attachment).teamName;
        NSString *teamAvatar             = ((JTTeamRemoveAttachment *)attachment).teamAvatar;
        NSString *userId                 = ((JTTeamRemoveAttachment *)attachment).userId;
        NSString *yunxinID               = ((JTTeamRemoveAttachment *)attachment).yunxinID;
        NSString *userName               = ((JTTeamRemoveAttachment *)attachment).userName;
        NSString *removeTime             = ((JTTeamRemoveAttachment *)attachment).removeTime;
        check = teamId.length&&teamName.length&&teamAvatar.length&&userId.length&&yunxinID.length&&userName.length&&removeTime.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTTeamDismissAttachment class]]) {
        NSString *teamId                 = ((JTTeamDismissAttachment *)attachment).teamId;
        NSString *teamName               = ((JTTeamDismissAttachment *)attachment).teamName;
        NSString *teamAvatar             = ((JTTeamDismissAttachment *)attachment).teamAvatar;
        NSString *userId                 = ((JTTeamDismissAttachment *)attachment).userId;
        NSString *yunxinID               = ((JTTeamDismissAttachment *)attachment).yunxinID;
        NSString *userName               = ((JTTeamDismissAttachment *)attachment).userName;
        NSString *dismissTime            = ((JTTeamDismissAttachment *)attachment).dismissTime;
        check = teamId.length&&teamName.length&&teamAvatar.length&&userId.length&&yunxinID.length&&userName.length&&dismissTime.length ? YES : NO;
    }
    
    else if ([attachment isKindOfClass:[JTFunsAttachment class]]) {
        NSString *yunxinId    = ((JTFunsAttachment *)attachment).yunxinId;
        check = yunxinId.length ? YES : NO;
    }
    
    else if ([attachment isKindOfClass:[JTMoneyBonusReturnAttachment class]]) {
        NSString *bonusId      = ((JTMoneyBonusReturnAttachment *)attachment).bonusId;
        NSString *title        = ((JTMoneyBonusReturnAttachment *)attachment).title;
        NSString *money        = ((JTMoneyBonusReturnAttachment *)attachment).money;
        NSString *reason       = ((JTMoneyBonusReturnAttachment *)attachment).reason;
        NSString *time         = ((JTMoneyBonusReturnAttachment *)attachment).time;
        NSString *remarks      = ((JTMoneyBonusReturnAttachment *)attachment).remarks;
        check = bonusId.length&&title.length&&money.length&&reason.length&&time.length&&remarks.length ? YES : NO;
    }
    
    else if ([attachment isKindOfClass:[JTActivityPromptAttachment class]]) {
        NSString *activityID = ((JTActivityPromptAttachment *)attachment).activityID;
        NSString *content = ((JTActivityPromptAttachment *)attachment).content;
        check = activityID.length&&content.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTBusinessReplyAttachment class]]) {
        NSString *content = ((JTBusinessReplyAttachment *)attachment).content;
        check = content.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTIdentityAuthAttachment class]]) {
        NSString *content = ((JTIdentityAuthAttachment *)attachment).content;
        check = content.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTCarAuthAttachment class]]) {
        NSString *content = ((JTCarAuthAttachment *)attachment).content;
        NSString *carID = ((JTCarAuthAttachment *)attachment).carID;
        check = content.length&&carID.length ? YES : NO;
    }
    
    else if ([attachment isKindOfClass:[JTCommentActivityAttachment class]]) {
        NSString *content = ((JTCommentActivityAttachment *)attachment).content;
        check = content.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JTCommentInformationAttachment class]]) {
        NSString *content = ((JTCommentInformationAttachment *)attachment).content;
        check = content.length ? YES : NO;
    }
    
    else if ([attachment isKindOfClass:[JTTeamOwnerTipAttachment class]]) {
        NSString *text      = ((JTTeamOwnerTipAttachment *)attachment).text;
        check = text.length ? YES : NO;
    }
    
    return check;
}

@end
