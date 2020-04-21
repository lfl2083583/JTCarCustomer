//
//  JTEvaluationAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTEvaluationAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *text;

@end
