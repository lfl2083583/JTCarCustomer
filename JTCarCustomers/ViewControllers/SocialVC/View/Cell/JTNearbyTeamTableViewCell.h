//
//  JTNearbyTeamTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

@protocol JTNearbyTeamTableViewCellDelegate <NSObject>

- (void)tableCellRightBtnClick:(NSIndexPath *)indexPath;

@end

static NSString *nearbyTeamCellID = @"JTNearbyTeamTableViewCell";
@interface JTNearbyTeamTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatar;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIImageView *centerImgeView;
@property (nonatomic, strong) UILabel *rightBottomLB;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIImageView *rightImgeView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<JTNearbyTeamTableViewCellDelegate>delegate;

- (void)configNearbyCellWithTeamInfo:(id)teamInfo indexPath:(NSIndexPath *)indexPath;

@end
