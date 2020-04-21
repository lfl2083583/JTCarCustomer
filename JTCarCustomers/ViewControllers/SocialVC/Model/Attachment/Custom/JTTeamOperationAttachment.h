//
//  JTTeamOperationAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

typedef NS_ENUM(NSInteger, TeamOperationActionType) {
    TeamOperationActionTypeNormal = 0,    // 0 群主创建群
    TeamOperationActionTypeInvite,        // 1 xxx邀请YYY加入了群聊
    TeamOperationActionTypeCodeEnter,     // 2 xxx通过YYY分享的二维码加入了群聊
    TeamOperationActionTypeActivityEnter, // 3 xxx通过YYY活动加入了群聊
    TeamOperationActionTypeNormalEnter,   // 4 xxx加入群
    TeamOperationActionTypeAgainEnter,    // 5 xxx再次加入群
    
    TeamOperationActionTypeKick = 7,      // 7 xxx将XXX移出了群聊
    TeamOperationActionTypeMute,          // 8 xxx将XXX禁言
    TeamOperationActionTypeCancelMute,    // 9 xxx取消XXX的禁言
    TeamOperationActionTypeQuit,          // 10 xxx退出群
    TeamOperationActionTypeModifyPower,   // 11 xxx为XXX设置了群权限
    TeamOperationActionTypeTeamModel,     // 12 入群方式设置为xxx
    TeamOperationActionTypeTransfer,      // 13 xxx将群转让给xxx
    
};

@interface JTTeamOperationAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *actionType;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, copy) NSArray *userList;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSString *teamOperationText;
@property (nonatomic, strong) NSMutableAttributedString *teamOperationAttributedString;
@property (nonatomic, strong) NSMutableArray *teamOperationLinks;

@property (nonatomic, strong) NSDictionary *teamOperationOperationInfo;
@end
