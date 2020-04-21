//
//  JTSwitchTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTSwitchTableViewCellDelegate <NSObject>

- (void)switchTableViewCell:(id)switchTableViewCell didChangeRowAtIndexPath:(NSIndexPath *)indexPath atValue:(BOOL)value;

@end

static NSString *switchIdentifier = @"JTSwitchTableViewCell";

@interface JTSwitchTableViewCell : UITableViewCell

@property (strong, nonatomic) UISwitch *sw;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) id<JTSwitchTableViewCellDelegate>delegate;

@end
