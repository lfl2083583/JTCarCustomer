//
//  JTLocalContactsTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTServiceType)
{
    /** 未注册 **/
    JTServiceUnRegister = 0,
    /** 已关注 **/
    JTServiceFocus = 1,
    /** 未关注 **/
    JTServiceUnFocus = 2,
};

@protocol JTLocalContactsTableViewCellDelegate <NSObject>

- (void)tableCellRightButtonClickWithIndexpath:(NSIndexPath *)indexPath;

@end

static NSString *localContactsId = @"JTLocalContactsTableViewCell";
@interface JTLocalContactsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<JTLocalContactsTableViewCellDelegate>delegate;

- (void)configCellInfo:(NSDictionary *)info indexPath:(NSIndexPath *)indexPath;

@end
