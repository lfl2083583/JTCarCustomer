//
//  JTFunsAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTFunsAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *yunxinId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSString *funsText;
@property (nonatomic, strong) NSMutableAttributedString *funsAttributedString;

- (instancetype)initWithUserId:(NSString *)userId
                      yunxinId:(NSString *)yunxinId
                          type:(NSInteger)type
                          time:(NSString *)time;

@end
