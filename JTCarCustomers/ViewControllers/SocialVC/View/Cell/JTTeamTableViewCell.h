//
//  JTGroupTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

typedef NS_ENUM(NSInteger, JTTeamMemeberType)
{
    /** 普通成员 **/
    JTTeamMemeberTypeNormal = 0,
    /** 群主 **/
    JTTeamMemeberTypeOwner,
    /** 管理员 **/
    JTTeamMemeberTypeManager,
    
};

static NSString *teamCellIndentifer = @"JTGroupTableViewCell";

@interface JTTeamTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatar;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIImageView *rightImgeView;
@property (nonatomic, strong) UIView *bottomView;

- (void)configTeamCellWithTeamInfo:(id)teamInfo;

- (void)configTeamCellWithTeam:(NIMTeam *)team;


@end
