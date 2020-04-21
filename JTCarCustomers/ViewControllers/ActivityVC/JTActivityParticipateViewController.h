//
//  JTActivityParticipateViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
typedef NS_ENUM(NSUInteger, JTActivityJoinStatus) {
    JTActivityJoinStatusNormal  = 1,//正常状态(没有参加活动)
    JTActivityJoinStatusFinish  = 2,//活动已结束
    JTActivityJoinStatusAudit   = 3,//已参加活动(未加入，退出了，审核中)
    JTActivityJoinStatusJoined  = 4,//已参加活动(已加入群聊)
    
};

typedef void(^ZT_ParticipateBlock)(JTActivityJoinStatus joinStatus);

#import "BaseRefreshViewController.h"

@interface JTActivityParticipateViewController : BaseRefreshViewController

@property (nonatomic, copy) id activityInfo;
@property (nonatomic, copy) ZT_ParticipateBlock callBack;


- (instancetype)initWithActivityInfo:(id)activityInfo;

@end
