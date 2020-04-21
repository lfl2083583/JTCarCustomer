//
//  JTExpressionAttachment.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTExpressionAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *expressionId;
@property (nonatomic, copy) NSString *expressionName;
@property (nonatomic, copy) NSString *expressionUrl;
@property (nonatomic, copy) NSString *expressionThumbnail;
@property (nonatomic, copy) NSString *expressionWidth;
@property (nonatomic, copy) NSString *expressionHeight;

- (instancetype)initWithExpressionID:(NSString *)expressionID expressionName:(NSString *)expressionName expressionUrl:(NSString *)expressionUrl expressionThumbnail:(NSString *)expressionThumbnail expressionWidth:(NSString *)expressionWidth expressionHeight:(NSString *)expressionHeight;

@end
