//
//  JTAudioCenter.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/16.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTAudioCenter.h"

@implementation JTAudioCenter

+ (instancetype)instance
{
    static JTAudioCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTAudioCenter alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
    }
    return self;
}

- (void)play:(NIMMessage *)message
{
    NIMAudioObject *audioObject = (NIMAudioObject *)message.messageObject;
    if ([audioObject isKindOfClass:[NIMAudioObject class]]) {
        self.currentPlayingMessage = message;
        message.isPlayed = YES;
        [[NIMSDK sharedSDK].mediaManager play:audioObject.path];
    }
}


#pragma mark - NIMMediaManagerDelegate

- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error
{
    if (error) {
        self.currentPlayingMessage = nil;
    }
}


- (void)playAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error
{
    self.currentPlayingMessage = nil;
}


@end
