//
//  JTSocialStautsUtil.h
//  JTSocial
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTLiveStatus) {
    JTLiveStatusNone,            // 无
    JTLiveStatusWatching,        // 观看直播中
    JTLiveStatusLiving           // 直播中
};

typedef NS_ENUM(NSInteger, JTNetCallStatus) {
    JTNetCallStatusNone,             // 无
    JTNetCallStatusConnect           // 音视频连接中
};


@interface JTSocialStautsUtil : NSObject

@property (nonatomic, assign) JTLiveStatus liveStatus;
@property (nonatomic, assign) JTNetCallStatus netCallStatus;
@property (nonatomic, assign) BOOL isAdoptReview;        // 是否通过审核
@property (nonatomic, assign) BOOL isFirstInstallation;  // 是否第一次安装

+ (instancetype)sharedCenter;
@end
