//
//  JTSessionListTableViewCell.m
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "JTSessionListTableViewCell.h"
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
#import "JTCommentActivityAttachment.h"
#import "JTCommentInformationAttachment.h"
#import "JTTeamOwnerTipAttachment.h"

#import "JTSessionUtil.h"

@implementation JTSessionListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[ZTCirlceImageView alloc] initWithFrame:CGRectMake(10, 7.5, 50, 50)];
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 12.5, App_Frame_Width-160, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font            = Font(18);
        _nameLabel.textColor       = BlackLeverColor6;
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 32.5, App_Frame_Width-105, 20)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font            = Font(14);
        _messageLabel.textColor       = BlackLeverColor3;
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(App_Frame_Width-90, 12.5, 80, 15)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font            = Font(12);
        _timeLabel.textColor       = BlackLeverColor3;
        _timeLabel.textAlignment   = NSTextAlignmentRight;
        [self addSubview:_timeLabel];

        _badgeView = [JTBadgeView viewWithBadgeTip:@""];
        _badgeView.centerX       = _avatarImageView.right;
        _badgeView.centerY       = _avatarImageView.top;
        [self addSubview:_badgeView];

        _messageNoDisturbIcon             = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-24, _messageLabel.centerY-8, 14, 16)];
        _messageNoDisturbIcon.image       = [UIImage imageNamed:@"icon_disturb"];
        _messageNoDisturbIcon.contentMode = UIViewContentModeCenter;
        [self addSubview:_messageNoDisturbIcon];
    }
    return self;
}

- (void)configWithSessionListTableViewCell:(NIMRecentSession *)recent {
    
    [self refresh:recent];
    [self avatarForRecent:recent];
    [self nameForRecent:recent];
    [self contentForRecent:recent];
    [self timestampDescriptionForRecent:recent];
    [self backgroundColorForRecent:recent];
}

- (void)refresh:(NIMRecentSession *)recent {
    
    BOOL isHiddenBade = YES; // YES 为隐藏徽章
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        isHiddenBade = ![[NIMSDK sharedSDK].userManager notifyForNewMsg:recent.session.sessionId];
    }
    else if (recent.session.sessionType == NIMSessionTypeTeam) {
        isHiddenBade = ([[NIMSDK sharedSDK].teamManager notifyStateForNewMsg:recent.session.sessionId] != NIMTeamNotifyStateAll);
    }
    if (isHiddenBade) {
        self.messageNoDisturbIcon.hidden = NO;
        self.badgeView.badgeValue = @"";
        self.badgeView.hidden = !recent.unreadCount;
    }
    else
    {
        self.messageNoDisturbIcon.hidden = YES;
        if (recent.unreadCount > 0) {
            if ([recent.session.sessionId isEqualToString:kJTNomeyID] ||
                [recent.session.sessionId isEqualToString:kJTNormalID] ||
                [recent.session.sessionId isEqualToString:kJTTeamID]) {
                self.badgeView.badgeValue = (recent.unreadCount > 99)?@"99+":@(recent.unreadCount).stringValue;
            }
            else
            {
                self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
            }
            self.badgeView.hidden = NO;
        }
        else
        {
            self.badgeView.hidden = YES;
        }
        self.badgeView.hidden = !recent.unreadCount;
    }
    self.badgeView.centerX = self.avatarImageView.right;
}

- (void)avatarForRecent:(NIMRecentSession *)recent
{
    NSString *avatarUrlString;
    NIMSession *session = recent.session;
    if (session.sessionType == NIMSessionTypeTeam) {
        avatarUrlString = [[[NIMSDK sharedSDK].teamManager teamById:session.sessionId] avatarUrl];
    }
    else
    {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:session.sessionId];
        NIMUserInfo *info = user.userInfo;
        if (info.thumbAvatarUrl && info.thumbAvatarUrl.length > 0) {
            NSString *front = [[info.thumbAvatarUrl componentsSeparatedByString:@"?"] firstObject];
            if ([user.userId isEqualToString:kJTNomeyID] ||
                [user.userId isEqualToString:kJTNormalID] ||
                [user.userId isEqualToString:kJTTeamID]) {
                avatarUrlString = [front stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
            }
            else
            {
                avatarUrlString = [front avatarHandleWithSquare:100];
            }
        }
    }
    [self.avatarImageView setAvatarByUrlString:avatarUrlString defaultImage:DefaultBigAvatar];
}

- (void)nameForRecent:(NIMRecentSession *)recent
{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        self.nameLabel.text = [JTUserInfoHandle showNick:recent.session.sessionId];
    } else {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        self.nameLabel.text = team.teamName;
    }
}

- (void)contentForRecent:(NIMRecentSession *)recent {
    
    if ([JTSessionUtil recentSessionDraftMark:recent]) {

        NSMutableAttributedString *atttributedString = [[NSMutableAttributedString alloc] initWithString:[[JTSessionUtil recentSessionDraftMark:recent] objectForKey:JTDraftText]];
        NSAttributedString *atDraft = [[NSAttributedString alloc] initWithString:@"[草稿]" attributes:@{NSForegroundColorAttributeName: BlueLeverColor1}];
        [atttributedString insertAttributedString:atDraft atIndex:0];
        self.messageLabel.attributedText = atttributedString;
    }
    else
    {
        NSString *text = @"";
        if (recent.lastMessage.messageType == NIMMessageTypeCustom)
        {
            NIMCustomObject *object = (NIMCustomObject *)recent.lastMessage.messageObject;
            if ([object.attachment isKindOfClass:[JTExpressionAttachment class]]) {
                
                text = [NSString stringWithFormat:@"[%@]", ([(JTExpressionAttachment *)object.attachment expressionName] && [[(JTExpressionAttachment *)object.attachment expressionName] length])?[(JTExpressionAttachment *)object.attachment expressionName]:@"图片"];
            }
            else if ([object.attachment isKindOfClass:[JTCardAttachment class]]) {
                text = @"[名片消息]";
            }
            else if ([object.attachment isKindOfClass:[JTBonusAttachment class]]) {
                text = @"[红包消息]";
            }
            else if ([object.attachment isKindOfClass:[JTCallBonusAttachment class]]) {
                text = [(JTCallBonusAttachment *)object.attachment bonusText];
            }
            else if ([object.attachment isKindOfClass:[JTTeamOperationAttachment class]]) {
                text = [(JTTeamOperationAttachment *)object.attachment teamOperationText];
            }
            else if ([object.attachment isKindOfClass:[JTTipAttachment class]]) {
            }
            else if ([object.attachment isKindOfClass:[JTEvaluationAttachment class]]) {
            }
            else if ([object.attachment isKindOfClass:[JTVideoAttachment class]]) {
                text = @"[视频]";
            }
            else if ([object.attachment isKindOfClass:[JTImageAttachment class]]) {
                text = @"[图片]";
            }
            else if ([object.attachment isKindOfClass:[JTGroupAttachment class]]) {
                text = @"[群名片消息]";
            }
            else if ([object.attachment isKindOfClass:[JTInformationAttachment class]]) {
                text = @"[资讯名片]";
            }
            else if ([object.attachment isKindOfClass:[JTActivityAttachment class]]) {
                text = @"[活动名片]";
            }
            else if ([object.attachment isKindOfClass:[JTShopAttachment class]]) {
                text = @"[店铺名片]";
            }
            else if ([object.attachment isKindOfClass:[JTTeamInviteAttachment class]]) {
                text = [(JTTeamInviteAttachment *)object.attachment teamInviteText];
            }
            else if ([object.attachment isKindOfClass:[JTTeamInviteRefuseAttachment class]]) {
                text = [(JTTeamInviteRefuseAttachment *)object.attachment teamInviteRefuseText];
            }
            else if ([object.attachment isKindOfClass:[JTTeamApplyAttachment class]]) {
                text = [(JTTeamApplyAttachment *)object.attachment teamApplyText];
            }
            else if ([object.attachment isKindOfClass:[JTTeamApplyRefuseAttachment class]]) {
                text = [(JTTeamApplyRefuseAttachment *)object.attachment teamApplyRefuseText];
            }
            else if ([object.attachment isKindOfClass:[JTTeamRemoveAttachment class]]) {
                text = [(JTTeamRemoveAttachment *)object.attachment teamRemoveText];
            }
            else if ([object.attachment isKindOfClass:[JTTeamDismissAttachment class]]) {
                text = [(JTTeamDismissAttachment *)object.attachment teamDismissText];
            }
            else if ([object.attachment isKindOfClass:[JTFunsAttachment class]]) {
                text = [(JTFunsAttachment *)object.attachment funsText];
            }
            else if ([object.attachment isKindOfClass:[JTMoneyBonusReturnAttachment class]]) {
                text = [(JTMoneyBonusReturnAttachment *)object.attachment title];
            }
            else if ([object.attachment isKindOfClass:[JTCommentActivityAttachment class]]) {
                text = [NSString stringWithFormat:@"%@回复了你", [(JTCommentActivityAttachment *)object.attachment name]];
            }
            else if ([object.attachment isKindOfClass:[JTCommentInformationAttachment class]]) {
                text = [NSString stringWithFormat:@"%@回复了你", [(JTCommentInformationAttachment *)object.attachment name]];
            }
            else if ([object.attachment isKindOfClass:[JTTeamOwnerTipAttachment class]]) {
                text = [(JTTeamOwnerTipAttachment *)object.attachment text];
            }
            
            if (recent.session.sessionType != NIMSessionTypeP2P &&
                ![object.attachment isKindOfClass:[JTCallBonusAttachment class]] &&
                ![object.attachment isKindOfClass:[JTTeamOperationAttachment class]] &&
                ![object.attachment isKindOfClass:[JTFunsAttachment class]] &&
                ![object.attachment isKindOfClass:[JTTeamOwnerTipAttachment class]])
            {
                NSString *nickName = [JTUserInfoHandle showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
                text = nickName.length ? [nickName stringByAppendingFormat:@" : %@", text] : @"";
            }
        }
        else
        {
            NIMMessage *lastMessage = recent.lastMessage;
            switch (recent.lastMessage.messageType) {
                case NIMMessageTypeText:
                {
                    text = [lastMessage.text stringByReplacingOccurrencesOfString:@"🐜ܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻܻ" withString:@"🐜"];
                    if ([lastMessage.text rangeOfString:@"ส็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็ส็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็ส็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็็"].location != NSNotFound)  {
                        text = @"我是傻逼";
                    }
                    if (lastMessage.text.length > 30) {
                        text = [text substringToIndex:30];
                    }
                }
                    break;
                case NIMMessageTypeAudio:
                {
                    text = @"[语音]";
                }
                    break;
                case NIMMessageTypeImage:
                {
                    text = @"[图片]";
                }
                    break;
                case NIMMessageTypeVideo:
                {
                    text = @"[视频]";
                }
                    break;
                case NIMMessageTypeLocation:
                {
                    text =  @"[位置]";
                }
                    break;
                case NIMMessageTypeNotification:
                {
                    text = [self notificationMessageContent:lastMessage];
                }
                    break;
                case NIMMessageTypeFile:
                {
                    text = @"[文件]";
                }
                    break;
                case NIMMessageTypeTip:
                {
                    text = lastMessage.text;
                }
                    break;
                default:
                    text = @"[未知消息]";
                    break;
            }
            if (recent.session.sessionType != NIMSessionTypeP2P && recent.lastMessage.messageType != NIMMessageTypeTip && recent.lastMessage.messageType != NIMMessageTypeNotification)
            {
                NSString *nickName = [JTUserInfoHandle showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
                text = nickName.length ? [nickName stringByAppendingFormat:@" : %@", text] : @"";
            }
        }
        NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithString:text?text:@"[未知消息]"];
        [self checkNeedAtTip:recent content:attContent];
        self.messageLabel.attributedText = attContent;
    }
}


- (NSString *)notificationMessageContent:(NIMMessage *)lastMessage
{
    NIMNotificationObject *object = (NIMNotificationObject *)lastMessage.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        if (content.callType == NIMNetCallTypeAudio) {
            return @"[语音聊天]";
        }
        return @"[视频聊天]";
    }
    else if (object.notificationType == NIMNotificationTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:lastMessage.session.sessionId];
        if (team.type == NIMTeamTypeNormal) {
            return @"[讨论组信息更新]";
        }
        else
        {
            NIMTeamNotificationContent *content = (NIMTeamNotificationContent *)object.content;
            if (content.operationType == NIMTeamOperationTypeUpdate) {
                id attachment = [content attachment];
                if ([attachment isKindOfClass:[NIMUpdateTeamInfoAttachment class]]) {
                    NIMUpdateTeamInfoAttachment *teamAttachment = (NIMUpdateTeamInfoAttachment *)attachment;
                    if ([teamAttachment.values count] == 1) {
                        NIMTeamUpdateTag tag = [[[teamAttachment.values allKeys] firstObject] integerValue];
                        if (tag == NIMTeamUpdateTagAnouncement) {
                            return [teamAttachment.values objectForKey:[NSNumber numberWithInteger:NIMTeamUpdateTagAnouncement]];
                        }
                    }
                }
            }
            return @"[群信息更新]";
        }
    }
    return @"[未知消息]";
}

- (void)checkNeedAtTip:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
{
    if ([JTSessionUtil recentSessionIsAtMark:recent]) {
        NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:@"[有人@你] " attributes:@{NSForegroundColorAttributeName: BlueLeverColor1}];
        [content insertAttributedString:atTip atIndex:0];
    }
    else if ([JTSessionUtil recentSessionIsAnnounceMark:recent]) {
        NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:@"[有新公告] " attributes:@{NSForegroundColorAttributeName: BlueLeverColor1}];
        [content insertAttributedString:atTip atIndex:0];
    }
}

- (void)timestampDescriptionForRecent:(NIMRecentSession *)recent
{
    self.timeLabel.text = [Utility showTime:recent.lastMessage.timestamp showDetail:NO];
}

- (void)backgroundColorForRecent:(NIMRecentSession *)recent
{
    if ([[JTUserInfo shareUserInfo].sessionTops containsObject:recent.session.sessionId]) {
        self.backgroundColor = BlueLeverColor3;
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
