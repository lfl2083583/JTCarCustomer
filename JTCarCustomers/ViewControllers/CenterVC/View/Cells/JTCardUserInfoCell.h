//
//  JTCardUserInfoCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTGenderGradeImageView.h"
#import "JTNormalUserInfo.h"

static NSString *cardUserInfoIdentifier = @"JTCardUserInfoCell";

@interface JTCardUserInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) JTGenderGradeImageView *genderView;

- (void)configCellWithUserInfo:(JTNormalUserInfo *)userInfo;

@end
