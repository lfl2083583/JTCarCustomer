//
//  JTSessionBackgroundModel.h
//  JTSocial
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTDataBaseConfig.h"

#define kSessionBackgroundTable    @"kSessionBackgroundTable"   // 用户会话背景

@interface JTSessionBackgroundModel : NSObject <JTDataBaseConfig>

@property (copy, nonatomic) NSString *sessionID;     
@property (copy, nonatomic) NSString *background;

- (instancetype)initWithSessionID:(NSString *)sessionID;
- (instancetype)initWithSessionID:(NSString *)sessionID background:(NSString *)background;
@end
