//
//  JTTeamInviteRefuseAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTTeamInviteRefuseAttachment : NSObject <NIMCustomAttachment>

@property (nonatomic, copy) NSString *inviteId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *yunxinID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *avatarUrlString;
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *inviteRefuseTime;
@property (nonatomic, assign) NSInteger operationType;

@property (nonatomic, strong) NSString *teamInviteRefuseText;

@end
