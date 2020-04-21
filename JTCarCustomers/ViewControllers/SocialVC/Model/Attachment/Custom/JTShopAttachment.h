//
//  JTShopAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTShopAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *address;

- (instancetype)initWithShopId:(NSString *)shopId
                      coverUrl:(NSString *)coverUrl
                          name:(NSString *)name
                         score:(NSString *)score
                          time:(NSString *)time
                       address:(NSString *)address;
@end
