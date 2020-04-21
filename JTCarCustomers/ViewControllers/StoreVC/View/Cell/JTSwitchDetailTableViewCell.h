//
//  JTSwitchDetailTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTSwitchDetailTableViewCellDelegate <NSObject>

- (void)switchDetailTableViewCell:(id)switchDetailTableViewCell didChangeRowAtIndexPath:(NSIndexPath *)indexPath atValue:(BOOL)value;

@end

static NSString *switchDetailIdentifier = @"JTSwitchDetailTableViewCell";

@interface JTSwitchDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) UISwitch *sw;
@property (strong, nonatomic) UILabel *detailLB;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) id<JTSwitchDetailTableViewCellDelegate> delegate;

@end
