//
//  JTMoneyBonusReturnAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTMoneyBonusReturnAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *bonusId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *remarks;


@end
