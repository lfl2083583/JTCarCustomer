//
//  JTActivityJoinTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *activityJoinIdentifier = @"JTActivityJoinTableViewCell";

@protocol JTActivityJoinTableViewCellDelegate <NSObject>

@optional
- (void)activityJoinTableViewCellTapped:(NSIndexPath *)indexPath;
- (void)joinActivityTeamSource:(id)source;

@end

@interface JTCircleButton : UIButton

@end

@interface JTActivityJoinTableViewCell : UITableViewCell

@property (nonatomic, strong) JTCircleButton *rightBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *leftImgeView;
@property (nonatomic, strong) UILabel *themeLB;
@property (nonatomic, strong) UILabel *groupCountLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *siteLB;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<JTActivityJoinTableViewCellDelegate>delegate;

- (void)configActivityJoinTableViewCellWithSource:(id)source indexPath:(NSIndexPath *)indexPath;

@end
