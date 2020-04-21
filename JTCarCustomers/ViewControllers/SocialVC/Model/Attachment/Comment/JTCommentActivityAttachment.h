//
//  JTCommentActivityAttachment.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTCustomAttachmentDefines.h"
#import <Foundation/Foundation.h>

@interface JTCommentActivityAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *activityUrl;
@property (nonatomic, copy) NSString *activityID;

@end
