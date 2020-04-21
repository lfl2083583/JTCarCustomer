//
//  JTTeamInfoHandle.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, JTTeamCategoryType)
{
    /** 车友群 **/
    JTTeamCategoryTypeCarFriend = 1,
    /** 运动群 **/
    JTTeamCategoryTypeSport,
    /** 交友群 **/
    JTTeamCategoryTypeMakeFriend,
    /** 玩乐群 **/
    JTTeamCategoryTypePlay,
    /** 生活群 **/
    JTTeamCategoryTypeLive,
    /** 游戏群 **/
    JTTeamCategoryTypeGame,
    /** 同城群 **/
    JTTeamCategoryTypeTheSameCity,
    /** 兴趣群 **/
    JTTeamCategoryTypeInterest
    
    
};

@interface JTTeamInfoHandle : NSObject

/**
 获取群分类类型

 @param team 群信息
 @return 群分类类型
 */
+ (JTTeamCategoryType)showTeamCategoryWithTeam:(NIMTeam *)team;


/**
 获取群分类图片

 @param categoryTyoe 群分类
 @return 群分类图片
 */
+ (UIImage *)showTeamCategoryImage:(JTTeamCategoryType)categoryTyoe;
@end
