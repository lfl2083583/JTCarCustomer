//
//  TVDefaultsTableViewCell.h
//  StockMobile
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "TextViewDelegate.h"

static NSString *tvDefaultsIdentifier = @"TVDefaultsTableViewCell";

@interface TVDefaultsTableViewCell : UITableViewCell <UITextViewDelegate>

@property (retain, nonatomic) GCPlaceholderTextView *contentTV;
@property (weak, nonatomic) id<TextViewDelegate> delegate;
@property (retain, nonatomic) NSIndexPath *indexPath;

- (void)clear;
@end
