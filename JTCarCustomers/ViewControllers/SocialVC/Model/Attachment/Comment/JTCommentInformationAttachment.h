//
//  JTCommentInformationAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTCustomAttachmentDefines.h"
#import <Foundation/Foundation.h>

@interface JTCommentInformationAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *informationUrl;
@property (nonatomic, assign) NSString *informationID;

@end
