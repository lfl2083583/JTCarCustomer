//
//  JTTFTitleTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *tfTitleIdentifier = @"JTTFTitleTableViewCell";

@protocol JTTFTitleTableViewCellDelegate <NSObject>

- (void)titleTableViewCellTfChanged:(NSString *)content indexPath:(NSIndexPath *)indexPath;

@end

@interface JTTFTitleTableViewCell : UITableViewCell

@property (nonatomic, weak) id<JTTFTitleTableViewCellDelegate>delegate;

- (void)configCellTitle:(NSString *)title subtitle:(NSString *)subtitle placeHolder:(NSString *)placeHolder indexPath:(NSIndexPath *)indexPath textfieldEnable:(BOOL)flag;

@end
