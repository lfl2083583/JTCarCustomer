//
//  JTSessionLayoutConfig.m
//  JTSocial
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionLayoutConfig.h"
#import "JTExpressionAttachment.h"
//#import "JTChartletAttachment.h"
//#import "JTGamePhotoAttachment.h"

@interface JTSessionLayoutConfig ()

@property (nonatomic, weak) NSString *sessionID;
@property (nonatomic, assign) BOOL isShowGroupNickName;

@end

@implementation JTSessionLayoutConfig

+ (instancetype)shareJTSessionLayoutConfig
{
    static JTSessionLayoutConfig *sessionLayoutConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionLayoutConfig = [[JTSessionLayoutConfig alloc] init];
    });
    return sessionLayoutConfig;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTUpdateSessionShowNickNameNotification object:nil];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChangeNotification:) name:kLoginStatusChangeNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSessionShowNickNameNotification:) name:kJTUpdateSessionShowNickNameNotification object:nil];
    }
    return self;
}

- (void)loginStatusChangeNotification:(NSNotification *)notification
{
    [self clean];
}

- (void)updateSessionShowNickNameNotification:(NSNotification *)notification
{
    [self clean];
}

- (void)clean
{
    self.sessionID = @"";
    self.isShowGroupNickName = NO;
}

- (BOOL)isShowTeamNickName:(NSString *)sessionID
{
    BOOL isShowTeamNickName = NO;
    if (self.sessionID && [self.sessionID isEqualToString:sessionID]) {
        return self.isShowGroupNickName;
    }
    else
    {
        self.sessionID = sessionID;
        self.isShowGroupNickName = isShowTeamNickName;
        NIMTeamMember *myTeamInfo = [[NIMSDK sharedSDK].teamManager teamMember:[[NIMSDK sharedSDK].loginManager currentAccount] inTeam:sessionID];
        if (myTeamInfo.customInfo && myTeamInfo.customInfo.length > 0) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[myTeamInfo.customInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL];
            if (info && [info isKindOfClass:[NSDictionary class]]) {
                if ([info objectForKey:@"isShowNickName"]) {
                    isShowTeamNickName = [[info objectForKey:@"isShowNickName"] boolValue];
                    self.isShowGroupNickName = isShowTeamNickName;
                }
            }
        }
    }
    return isShowTeamNickName;
}

- (BOOL)isHideBubbleImage:(NIMMessage *)message
{
    BOOL isHideBubbleImage = NO;
    if (message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        if ([object.attachment isKindOfClass:[JTExpressionAttachment class]]) {
            isHideBubbleImage = YES;
        }
    }
    else
    {
        if (message.messageType == NIMMessageTypeImage || message.messageType == NIMMessageTypeVideo) {
            isHideBubbleImage = YES;
        }
    }
    return isHideBubbleImage;
}
@end
