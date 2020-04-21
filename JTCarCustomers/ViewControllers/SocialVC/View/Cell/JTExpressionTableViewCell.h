//
//  JTExpressionTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

@protocol JTExpressionTableViewCellDelegate <NSObject>

- (void)expressionTableViewCell:(id)expressionTableViewCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

static NSString *expressionIdentifier = @"JTExpressionTableViewCell";

@interface JTExpressionTableViewCell : UITableViewCell

@property (strong, nonatomic) ZTCirlceImageView *icon;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UIButton *operationBT;

@property (assign, nonatomic) BOOL isManage;
@property (assign, nonatomic) BOOL isEdit;
@property (strong, nonatomic) NSDictionary *sourceDic;
@property (weak, nonatomic) id<JTExpressionTableViewCellDelegate> delegate;
@property (assign, nonatomic) NSIndexPath *indexPath;
@end
