//
//  JTTeamOwnerTipAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

typedef NS_ENUM(NSInteger, TeamOwnerTipOperationActionType) {
    TeamOwnerTipOperationActionTypeInvite = 0,    // 邀请
    TeamOwnerTipOperationActionTypeShare,         // 分享
};

@interface JTTeamOwnerTipAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSString *teamOwnerTipText;
@property (nonatomic, strong) NSMutableAttributedString *teamOwnerTipAttributedString;
@property (nonatomic, strong) NSMutableArray *teamOwnerTipLinks;

@property (nonatomic, strong) NSDictionary *teamOwnerTipOperationInfo;

- (instancetype)initWithText:(NSString *)text;

@end
