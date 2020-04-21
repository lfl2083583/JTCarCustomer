//
//  JTSocialStautsUtil.m
//  JTSocial
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSocialStautsUtil.h"
#import "AppDelegate+RootController.h"

@interface JTSocialStautsUtil()
{
    dispatch_semaphore_t semaphore_signal;
}
@end

@implementation JTSocialStautsUtil

+ (instancetype)sharedCenter
{
    static JTSocialStautsUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTSocialStautsUtil alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        semaphore_signal = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)setLiveStatus:(JTLiveStatus)liveStatus {
    dispatch_time_t overtime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore_signal, overtime);
    _liveStatus = liveStatus;
    dispatch_semaphore_signal(semaphore_signal);
}

- (BOOL)isAdoptReview
{
    return [CHANNEL_ID isEqualToString:@"appstore"] ? ([JTUserInfo shareUserInfo].isAdoptReview_Local && ![JTUserInfo shareUserInfo].isAppleAccount) : YES;
}

- (BOOL)isFirstInstallation
{
    static dispatch_once_t onceToken;
    __block BOOL isTemp = _isFirstInstallation;
    dispatch_once(&onceToken, ^{
        isTemp = [kAppDelegate isFirstInstallation];
    });
    _isFirstInstallation = isTemp;
    return _isFirstInstallation;
}
@end
