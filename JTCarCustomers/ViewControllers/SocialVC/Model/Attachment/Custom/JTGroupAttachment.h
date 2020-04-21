//
//  JTGroupAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTGroupAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithGroupId:(NSString *)groupId
                           name:(NSString *)name
                           icon:(NSString *)icon;
@end
