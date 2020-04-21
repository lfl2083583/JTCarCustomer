//
//  TFDefaultsTableViewCell.h
//  StockMobile
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewDelegate.h"

static NSString *tfDefaultsIdentifier = @"TFDefaultsTableViewCell";

@interface TFDefaultsTableViewCell : UITableViewCell 

@property (strong, nonatomic) UITextField *contentTF;
@property (weak, nonatomic) id<TextViewDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger inputMax;

- (void)clear;
- (void)initSubview;
@end
