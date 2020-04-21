//
//  JTJoinTeamViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef NS_ENUM(NSInteger, JTTeamSource)
{
    JTTeamSourceUnknow              = 0, //未知源
    
    JTTeamSourceInvite              = 1, //用户邀请
    
    JTTeamSourceFromQR              = 2, //二维码分享
    
    JTTeamSourceFromActivity        = 3, //活动
    
    JTTeamSourceFromNormal          = 4, //附近的群、推荐的群
    
    JTTeamSourceJoinAgain           = 5, //再次申请
    
};

@interface JTJoinTeamViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, assign) JTTeamSource teamSource;
@property (nonatomic, copy) NSString *inviteID;


/**
 申请加入群

 @param team 群信息
 @param teamSource 群信息来源
 @param inviteID 邀请人ID（没有邀请人传nil）
 @return 申请加入群实例
 */
- (instancetype)initWithTeam:(NIMTeam *)team teamSource:(JTTeamSource)teamSource inviteID:(NSString *)inviteID;

@end
