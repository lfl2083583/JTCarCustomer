//
//  JTSessionContentConfig.h
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTTextContentConfig.h"
#import "JTImageContentConfig.h"
#import "JTAudioContentConfig.h"
#import "JTVideoContentConfig.h"
#import "JTLocationContentConfig.h"
#import "JTNotificationContentConfig.h"
#import "JTTipContentConfig.h"

@interface JTSessionContentConfig : NSObject

+ (instancetype)shareSessionContentConfig;

- (id<JTSessionContentConfig>)configBy:(NIMMessage *)message;

@end
