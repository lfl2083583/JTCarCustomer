//
//  JTUserTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTGenderGradeImageView.h"

@protocol JTUserTableViewCellDelegate <NSObject>

@optional
- (void)followUserWithInfo:(NIMUser *)user;

@end

static NSString *userTableViewIndentifier = @"JTUserTableViewCell";

@interface JTUserTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatar;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) JTGenderGradeImageView *genderView;
@property (nonatomic, strong) UIImageView *carImgeView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, weak) id<JTUserTableViewCellDelegate>delegate;


- (void)configUserCellWithUserInfo:(id)userInfo;

- (void)configCellWithNIMUser:(NIMUser *)user;

- (void)configCellWithNIMUser:(NIMUser *)user isTeamOwner:(BOOL)isOwner;

+ (NSInteger)caculateBirthWithBirthDate:(NSString *)birthDate;

@end
