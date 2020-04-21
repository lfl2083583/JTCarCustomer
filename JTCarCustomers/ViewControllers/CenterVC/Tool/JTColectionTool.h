//
//  JTColectionTool.h
//  JTSocial
//
//  Created by lious on 2017/10/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class JTColectionTool ;

@protocol JTColectionToolDelegate <NSObject>

- (void)audioPlayerDidFinishPlaying:(JTColectionTool *)sender;

@end

@interface JTColectionTool : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, weak) id<JTColectionToolDelegate>delegate;

+ (void)playWithURL:(NSString*)url delegate:(id)del;

+ (void)cancel;

+ (void)pause;

@end

