//
//  JTSessionContentConfig.m
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionContentConfig.h"

static JTSessionContentConfig * instance = nil;

@interface JTSessionContentConfig ()

@property (nonatomic, strong) NSDictionary *dict;

@end

@implementation JTSessionContentConfig

+ (instancetype)shareSessionContentConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTSessionContentConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _dict = @{@(NIMMessageTypeText)         :       [JTTextContentConfig new],
                  @(NIMMessageTypeImage)        :       [JTImageContentConfig new],
                  @(NIMMessageTypeAudio)        :       [JTAudioContentConfig new],
                  @(NIMMessageTypeVideo)        :       [JTVideoContentConfig new],
                  @(NIMMessageTypeLocation)     :       [JTLocationContentConfig new],
                  @(NIMMessageTypeNotification) :       [JTNotificationContentConfig new],
                  @(NIMMessageTypeTip)          :       [JTTipContentConfig new],
                  };
    }
    return self;
}


- (id<JTSessionContentConfig>)configBy:(NIMMessage *)message
{
    NIMMessageType type = message.messageType;
    id<JTSessionContentConfig> config = [_dict objectForKey:@(type)];
    return config;
}

@end
