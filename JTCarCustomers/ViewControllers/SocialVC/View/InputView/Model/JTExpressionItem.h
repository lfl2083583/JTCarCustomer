//
//  JTExpressionItem.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTExpressionLayout.h"
#import "JTExpression.h"

@interface JTExpressionItem : NSObject

@property (nonatomic, strong) JTExpressionLayout     *layout;
@property (nonatomic, assign) JTExpressionType       type;
@property (nonatomic, copy) NSString                 *catalogID;
@property (nonatomic, copy) NSString                 *title;
@property (nonatomic, copy) NSArray<JTExpression *>  *expressions;
@property (nonatomic, copy) NSDictionary<NSString *, JTExpression *> *expressionIDDic;    // 用于查找
@property (nonatomic, copy) NSDictionary<NSString *, JTExpression *> *expressionNameDic;  // 用于查找
@property (nonatomic, copy) NSString                 *icon;             //图标
@property (nonatomic, copy) NSString                 *iconPressed;      //小图标按下效果

@end
