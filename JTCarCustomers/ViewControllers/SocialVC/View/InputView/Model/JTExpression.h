//
//  JTExpression.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTExpressionType)
{
    JTExpressionTypeEmoji,
    JTExpressionTypeCollection,
    JTExpressionTypeOther
};

@interface JTExpression : NSObject

@property (nonatomic, assign) JTExpressionType type;

@property (nonatomic, strong) NSString *expressionID;
@property (nonatomic, strong) NSString *name;
//默认表情
@property (nonatomic, strong) NSString *localFileName;
//图片表情
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *originalUrl;
//发送的时候加上宽高
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;

@end
