//
//  JTEvaluateTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

static NSString *const evaluateTableViewCellIdentifier = @"JTEvaluateTableViewCell";

@protocol JTEvaluateTableViewCellDelegate <NSObject>

- (void)evalutesChanged:(NSArray *)evaluates;
- (void)textInputChanged:(NSString *)content;

@end

@interface JTEvaluateTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *evaluates;
@property (nonatomic, strong) NSMutableArray *seletedArray;
@property (nonatomic, strong) GCPlaceholderTextView *textView;
@property (nonatomic, weak) id<JTEvaluateTableViewCellDelegate>delegate;

+ (CGFloat)getViewHeightWithEvalutes:(NSArray *)evaluates;

@end
