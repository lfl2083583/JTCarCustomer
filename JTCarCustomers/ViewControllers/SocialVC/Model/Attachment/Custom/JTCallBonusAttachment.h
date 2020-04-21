//
//  JTCallBonusAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTCallBonusAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *fromId;
@property (nonatomic, copy) NSString *fromName;
@property (nonatomic, copy) NSString *bonusId;
@property (nonatomic, copy) NSString *toId;
@property (nonatomic, copy) NSString *toName;
@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, assign) NSInteger bonusType;
@property (nonatomic, copy) NSString *lastFlag;

@property (nonatomic, strong) NSString *bonusText;
@property (nonatomic, strong) NSMutableAttributedString *bonusAttributedString;
@property (nonatomic, strong) NSMutableArray *bonusLinks;

@property (nonatomic, strong) NSDictionary *packetOperationInfo;

@end
