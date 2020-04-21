//
//  JTBonusRobView.h
//  JTSocial
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTBonusAttachment.h"
#import "ZTCirlceImageView.h"
#import "ZTAlignmentLabel.h"

typedef NS_ENUM(NSInteger, JTBonusStatus) {
    JTBonusStatusNormal = 0,  //
    JTBonusStatusGrabbed,     // 已抢
    JTBonusStatusOverTime,    // 超时
    JTBonusStatusOverGrab,    // 抢完
    JTBonusStatusGrabSuccess, // 抢成功
    JTBonusStatusGrabFailure, // 抢失败
    JTBonusStatusLookDetail   // 查看红包详情
};

@interface JTBonusRobView : UIView

@property (strong, nonatomic) JTBonusAttachment *attachment;
@property (strong, nonatomic) NIMMessage *message;
@property (copy, nonatomic) void (^completionHandler)(JTBonusStatus, BOOL, id);

- (instancetype)initWithAttachment:(JTBonusAttachment *)attachment message:(NIMMessage *)message completionHandler:(void (^)(JTBonusStatus bonusStatus, BOOL isDisplayDetails, id data))completionHandler;

@end
