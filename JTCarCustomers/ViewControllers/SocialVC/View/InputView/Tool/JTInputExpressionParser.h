//
//  JTInputExpressionParser.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTInputExpressionManager.h"

typedef enum : NSUInteger
{
    JTInputTokenTypeText,
    JTInputTokenTypeExpression,
    
} JTInputTokenType;

@interface JTInputToken : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) JTInputTokenType type;

@end

@interface JTInputExpressionParser : NSObject

+ (instancetype)currentParser;
- (NSArray *)getTokens:(NSString *)text;

@end
