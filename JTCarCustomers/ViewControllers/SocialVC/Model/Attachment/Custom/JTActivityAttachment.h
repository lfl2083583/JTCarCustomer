//
//  JTActivityAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTActivityAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *address;

- (instancetype)initWithActivityId:(NSString *)activityId
                          coverUrl:(NSString *)coverUrl
                             theme:(NSString *)theme
                              time:(NSString *)time
                           address:(NSString *)address;
@end
