//
//  JTStoreCommentClassTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTStoreCommentClassTableViewCell;

@protocol JTStoreCommentClassTableViewCellDelegate <NSObject>

- (void)storeCommentClassTableViewCell:(JTStoreCommentClassTableViewCell *)storeCommentClassTableViewCell didSelectIndex:(NSInteger)index;

@end

static NSString *storeCommentClassIndentifier = @"JTStoreCommentClassTableViewCell";

@interface JTStoreCommentClassTableViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *button_1;
@property (strong, nonatomic) UIButton *button_2;
@property (strong, nonatomic) UIButton *button_3;
@property (strong, nonatomic) UIButton *button_4;

@property (assign, nonatomic) NSInteger type;
@property (weak, nonatomic) id<JTStoreCommentClassTableViewCellDelegate> delegate;
@end
