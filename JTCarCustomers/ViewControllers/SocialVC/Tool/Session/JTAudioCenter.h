//
//  JTAudioCenter.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/16.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTAudioCenter : NSObject <NIMMediaManagerDelegate>

@property (nonatomic,strong) NIMMessage *currentPlayingMessage;

+ (instancetype)instance;

- (void)play:(NIMMessage *)message;

@end
