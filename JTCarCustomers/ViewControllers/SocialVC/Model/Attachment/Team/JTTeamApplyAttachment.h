//
//  JTTeamApplyAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTTeamApplyAttachment : NSObject <NIMCustomAttachment>

@property (nonatomic, copy) NSString *inviteId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *yunxinID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *avatarUrlString;
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *joinType;
@property (nonatomic, copy) NSString *applyTime;
@property (nonatomic, assign) NSInteger operationType; // 操作类型，0：无操作，1：同意，2：拒绝

@property (nonatomic, strong) NSString *teamApplyText;

@end
