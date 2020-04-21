//
//  JTSessionTipTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/7/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTSessionMessageModel.h"
#import "TTTAttributedLabel.h"

@class JTSessionTipTableViewCell;

@protocol JTSessionTipTableViewCellDelegate <NSObject>

@optional

- (void)sessionTableViewCell:(JTSessionTipTableViewCell *)sessionTableViewCell didSelectAtMessageModel:(JTSessionMessageModel *)messageModel didSelectAtValue:(id)value;
@end

static NSString *sessionTipIdentifier = @"JTSessionTipTableViewCell";

@interface JTSessionTipTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView *tipImg;
@property (strong, nonatomic) TTTAttributedLabel *tipLB;
@property (strong, nonatomic) JTSessionMessageModel *model;
@property (weak, nonatomic) id<JTSessionTipTableViewCellDelegate> delegate;

@end
