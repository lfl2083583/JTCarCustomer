//
//  JTColectionTool.m
//  JTSocial
//
//  Created by lious on 2017/10/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTColectionTool.h"

static JTColectionTool * sharedTool = nil;

@interface JTColectionTool ()

{
    NSMutableArray * contentArray;
    AVAudioPlayer * player;
}
@property (nonatomic, copy) NSString * currentTag;

@end

@implementation JTColectionTool

@synthesize currentTag;

+ (void)playWithURL:(NSString*)url delegate:(id)del {
    JTColectionTool *sharedTool = [JTColectionTool sharedTools];
    [sharedTool playWithURL:url delegate:del];
}

+ (JTColectionTool *)sharedTools {
    if (sharedTool == nil) {
        sharedTool = [[JTColectionTool alloc] init];
    }
    return sharedTool;
}

+ (void)cancel {
    JTColectionTool *sharedTools = [JTColectionTool sharedTools];
    [sharedTools cancel];
}

+ (void)pause
{
    JTColectionTool *sharedTools = [JTColectionTool sharedTools];
    [sharedTools pause];
}

- (id)init {
    if (self = [super init]) {
        contentArray = [[NSMutableArray alloc] init];
    }
    return self;
}



- (void)dealloc {
    if (player) {
        [player stop];
        player = nil;
    }
    self.delegate = nil;
    self.currentTag = nil;
}

- (void)cancel {
    self.currentTag = nil;
    if (player) {
        [player stop];
        player = nil;
    }
    [self callBackWith:nil];
    self.delegate = nil;
}

- (void)pause
{
    if (player) {
        [player pause];
    }
}

- (void)playWithURL:(NSString*)url delegate:(id)del {
    NSString* urlTag = url;
    self.currentTag = urlTag;
    self.delegate = del;
    if (player) {
        [player stop];
        player = nil;
    }
    [NSThread detachNewThreadSelector:@selector(downLoadInThread:) toTarget:self withObject:url];
    
}

- (void)downLoadInThread:(NSString*)url {
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data) {
        // 下载成功
        [self playWithData:data];
    } else {
        // 下载失败
        [self performSelectorOnMainThread:@selector(failToDownloadInMainThread:) withObject:url waitUntilDone:YES];
    }
}


- (void)failToDownloadInMainThread:(NSString*)url {
    NSString* urlTag = url;
    for (NSString* tag in contentArray) {
        if ([urlTag isEqualToString:tag]) {
            [contentArray removeObject:tag];
            break;
        }
    }
    [self callBackWith:nil];
}

- (NSString*)pathWithURL:(NSString*)url {
    return [NSString stringWithFormat:@"%@/Library/Cache/Audios/%@.mp3",NSHomeDirectory(),url];
}

- (void)callBackWith:(id)info {
    [self.delegate audioPlayerDidFinishPlaying:self];
    self.delegate = nil;
}

- (void)playWithData:(NSData*)data {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSError * error = nil;
    player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (error != nil) {
        
        player = nil;
        [self callBackWith:nil];
    } else {
        player.delegate = self;
        [player prepareToPlay];
        [player play];
    }
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)sender successfully:(BOOL)flag{
    //播放结束时执行的动作
    
    player = nil;
    [self callBackWith:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)sender error:(NSError*)error{
    //解码错误执行的动作
    
    player = nil;
    [self callBackWith:nil];
}


@end
