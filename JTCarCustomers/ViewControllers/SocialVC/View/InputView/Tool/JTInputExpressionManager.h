//
//  JTInputExpressionManager.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTExpressionItem.h"

@interface JTInputExpressionManager : NSObject

@property (copy, nonatomic) void (^loadSuccessBlock)(JTExpressionItem *emojiExpressionItem, JTExpressionItem *collectionExpressionItem, NSMutableArray<JTExpressionItem *> *otherExpressionItemArray);

+ (instancetype)sharedManager;

- (void)setup;

- (JTExpression *)emojiInName:(NSString *)name;

- (NSArray<JTExpression *> *)expressionInName:(NSString *)name;

@end
