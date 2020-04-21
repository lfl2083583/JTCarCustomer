//
//  JTConfigDelegate.m
//  JTSocial
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTConfigDelegate.h"

@implementation JTConfigDelegate

- (BOOL)shouldIgnoreNotification:(NIMNotificationObject *)notification
{
    BOOL ignore = NO;
    if (notification.notificationType == NIMNotificationTypeTeam) {
        
        NIMTeamNotificationContent *content = (NIMTeamNotificationContent *)notification.content;
        if (content.operationType == NIMTeamOperationTypeInvite) {
            ignore = YES;
        }
        else if (content.operationType == NIMTeamOperationTypeKick) {
            ignore = YES;
        }
        else if (content.operationType == NIMTeamOperationTypeLeave) {
            ignore = YES;
        }
        else if (content.operationType == NIMTeamOperationTypeUpdate) {
            
            id attachment = [content attachment];
            if ([attachment isKindOfClass:[NIMUpdateTeamInfoAttachment class]]) {
                
                NIMUpdateTeamInfoAttachment *teamAttachment = (NIMUpdateTeamInfoAttachment *)attachment;
                if ([teamAttachment.values count] == 1) {
                    NIMTeamUpdateTag tag = [[[teamAttachment.values allKeys] firstObject] integerValue];
                    if (tag == NIMTeamUpdateTagServerCustom || tag == NIMTeamUpdateTagAvatar) {
                        ignore = YES;
                    }
                }
            }
        }
        else if (content.operationType == NIMTeamOperationTypeTransferOwner) {
            ignore = YES;
        }
        else if (content.operationType == NIMTeamOperationTypeMute) {
            ignore = YES;
        }
    }
    return ignore;
}

@end
