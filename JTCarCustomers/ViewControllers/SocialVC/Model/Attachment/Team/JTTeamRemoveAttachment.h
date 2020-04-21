//
//  JTTeamRemoveAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTTeamRemoveAttachment : NSObject <NIMCustomAttachment>

@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *teamAvatar;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *yunxinID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *removeTime;
@property (nonatomic, assign) NSInteger operationType;

@property (nonatomic, strong) NSString *teamRemoveText;

@end
