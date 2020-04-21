//
//  JTCarAuthAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTCarAuthAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *carID;

@end
