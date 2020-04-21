//
//  JTTalentTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

@protocol JTTalentTableViewCellDelegate <NSObject>

- (void)talentTableViewCellDialogBoxClick:(NSIndexPath *)indexPath;

@end

static NSString *talentTableViewIndentify = @"JTTalentTableViewCell";

@interface JTTalentTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatarView;
@property (nonatomic, strong) UIImageView *identificateView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UILabel *centerLB;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<JTTalentTableViewCellDelegate>delegate;

- (void)configTalentTableViewCellWithTalentInfo:(id)talentInfo indexPath:(NSIndexPath *)indexPath;

@end
