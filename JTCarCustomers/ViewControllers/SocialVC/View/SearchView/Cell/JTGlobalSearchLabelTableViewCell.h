//
//  JTGlobalSearchLabelTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *globalSearchLabelIdentifier = @"JTGlobalSearchLabelTableViewCell";

@protocol JTGlobalSearchLabelTableViewCellDelegate <NSObject>

- (void)globalSearchLabelTableViewCellLabelClick:(NSInteger)index;

@end

@interface JTGlobalSearchLabelTableViewCell : UITableViewCell

@property (copy, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) id<JTGlobalSearchLabelTableViewCellDelegate>delegate;

@end
