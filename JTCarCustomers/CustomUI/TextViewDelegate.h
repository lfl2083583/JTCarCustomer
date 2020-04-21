//
//  TextViewDelegate.h
//  StockMobile
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TextViewDelegate <NSObject>

@optional
- (void)textUI:(id)textUI startEditingAtIndexPath:(NSIndexPath *)indexPath;
- (void)text:(id)text changeEditingAtIndexPath:(NSIndexPath *)indexPath;
- (void)textUI:(id)textUI stopEditingAtIndexPath:(NSIndexPath *)indexPath;
- (void)textUI:(id)textUI shouldReturnAtIndexPath:(NSIndexPath *)indexPath;
@end
