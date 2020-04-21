//
//  JTCardAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTCardAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userNumber;
@property (nonatomic, copy) NSString *avatarUrlString;

- (instancetype)initWithUserId:(NSString *)userId
                      userName:(NSString *)userName
                    userNumber:(NSString *)userNumber
               avatarUrlString:(NSString *)avatarUrlString;

@end
