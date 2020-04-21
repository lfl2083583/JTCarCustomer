//
//  JTTeamPowerModel.h
//  JTCarCustomers
//
//  Created by apple on 2017/7/8.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTTeamPowerModel : NSObject

@property (nonatomic, assign) BOOL isMyTeam;                       // 根据群组ID判断是否是我所在的群
@property (nonatomic, copy) NIMTeam *team;
@property (nonatomic, strong) NIMTeamMember *myTeamMember;

@property (nonatomic, copy) NSString *ownerID;                     // 群主ID
@property (nonatomic, assign) BOOL isGroupMain;                    // 是否是群主
@property (nonatomic, assign) BOOL isMuted;                        // 被禁言
@property (nonatomic, strong) NSMutableArray *banPowerUserArray;   // 禁言权限用户组
@property (nonatomic, assign) BOOL isBanPower;                     // 禁言权限
@property (nonatomic, strong) NSMutableDictionary *bannedUserdict; // 被禁言用户
@property (nonatomic, assign) double bannedTimeInterval;           // 被禁言时间
@property (nonatomic, strong) NSMutableArray *oneEnterAddPowerUserArray;// 一键添加权限用户组
@property (nonatomic, assign) BOOL isOneEnterAddPower;             // 一键添加权限
@property (nonatomic, strong) NSMutableArray *removePowerUserArray;// 踢人权限用户组
@property (nonatomic, assign) BOOL isRemovePower;                  // 踢人权限
@property (nonatomic, strong) NSMutableArray *invitePowerUserArray;// 邀请权限用户组
@property (nonatomic, assign) BOOL isInvitePower;                  // 邀请权限
@property (nonatomic, assign) NSInteger joinTeamType;              // 加群方式 0拒绝任何人加群、1不需要审核、2群主审核
@property (nonatomic, assign) NSInteger category;                  // 群类别
@property (nonatomic, assign) BOOL isShowGroupNickName;            // 是否显示群昵称
@property (nonatomic, strong) NSString *displayedAnnounceTime;     // 已显示公告时间
@property (nonatomic, strong) NSString *announceID;                // 公告ID
@property (nonatomic, strong) NSString *announceTime;              // 公告时间


@end
