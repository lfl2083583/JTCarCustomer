//
//  JTExpressionPageView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTExpressionItem.h"

@interface JTExpressionPageView : UICollectionView

@property (strong, nonatomic) JTExpressionItem *item;
@property (copy, nonatomic) void (^didAddCollectionExpressionBlock)(void);
@property (copy, nonatomic) void (^didSelectExpressionBlock)(JTExpression *expression);

@end
