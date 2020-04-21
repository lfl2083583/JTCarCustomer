//
//  JTBonusAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTBonusAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *fromId;
@property (nonatomic, copy) NSString *from_yxAccId;
@property (nonatomic, copy) NSString *bonusId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) BOOL isSender;    // 是否自己发送
@property (nonatomic, assign) BOOL isGrabbed;   // 已抢
@property (nonatomic, assign) BOOL isOverTime;  // 超时
@property (nonatomic, assign) BOOL isOverGrab;  // 抢完

@end
