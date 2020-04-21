//
//  JTUserSimpleTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTGenderGradeImageView.h"

static NSString *userSimpleCellIdentifier = @"JTUserSimpleTableViewCell";

@interface JTUserSimpleTableViewCell : UITableViewCell

@property (strong, nonatomic) ZTCirlceImageView *avatar;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) JTGenderGradeImageView *genderGradeImageView;
@property (strong, nonatomic) UIImageView *carImgeView;
@property (strong, nonatomic) UIView *horizontalView;

@end
