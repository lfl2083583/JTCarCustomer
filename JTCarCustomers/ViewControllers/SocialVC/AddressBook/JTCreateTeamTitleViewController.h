//
//  JTCreateTeamTitleViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/16.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTTeamInfoHandle.h"
#import "BaseRefreshViewController.h"
typedef NS_ENUM(NSInteger, JTTeamInfoType)
{
    /** 创建群 **/
    JTTeamInfoTypeCreate = 1,
    /** 编辑群 **/
    JTTeamInfoTypeEdite  = 2,
};
typedef NS_ENUM(NSInteger, JTTeamPositionType)
{
    /** 小区 **/
    JTTeamPositionTypeVillage = 1,
    /** 商业 **/
    JTTeamPositionTypeCommercial,
    /** 学校 **/
    JTTeamPositionTypeSchool,
    
};
typedef void (^zt_TeamInfoBlock)(UIImage *image, NSString *title, NSString *describe);
@interface JTCreateTeamTitleViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, copy) zt_TeamInfoBlock callBack;

- (instancetype)initWithTeamNearby:(JTTeamPositionType)positionType lng:(NSString *)lng lat:(NSString *)lat address:(NSString *)address classfy:(JTTeamCategoryType)classfy;

- (instancetype)initWithTeam:(NIMTeam *)team callBack:(zt_TeamInfoBlock)callBack;

@end
