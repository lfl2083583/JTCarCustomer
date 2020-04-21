//
//  JTUserNotificationCenter.h
//  JTSocial
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTUserNotificationCenter : NSObject <NIMUserManagerDelegate, NIMTeamManagerDelegate>

+ (instancetype)sharedCenter;
- (void)start;
@end
