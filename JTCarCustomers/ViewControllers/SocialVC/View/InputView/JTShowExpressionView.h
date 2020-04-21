//
//  JTShowExpressionView.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTExpressionLayout.h"
#import "JTExpression.h"

@interface JTShowExpressionView : UIView

@property (nonatomic, copy) NSArray<JTExpression *> *expressions;
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *didShowExpressionMethod;

@end
