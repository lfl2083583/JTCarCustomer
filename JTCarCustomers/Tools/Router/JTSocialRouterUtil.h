//
//  JTSocialRouterUtil.h
//  JTSocial
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 登录
 */
extern NSString *const JTPlatformLogin;
/**
 直播表演
 */
extern NSString *const JTPlatformLiveShow;
/**
 观看直播表演
 */
extern NSString *const JTPlatformWatchLive;
/**
 拨打视频电话
 */
extern NSString *const JTPlatformCallVideoIn;
/**
 拨打语音电话
 */
extern NSString *const JTPlatformCallAudioIn;
/**
 分享
 */
extern NSString *const JTPlatformShareToSocial;
/**
 跳到下一页
 */
extern NSString *const JTPlatformNextPage;
/**
 关闭页
 */
extern NSString *const JTPlatformClosePage;
/**
 支付结果
 */
extern NSString *const JTPlatformPaymentResults;
/**
 发送普通消息
 */
extern NSString *const JTPlatformSendNormalMessage;
/**
 转发普通消息
 */
extern NSString *const JTPlatformRepeatNormalMessage;

@interface JTSocialRouterUtil : NSObject

@property (copy, nonatomic) void(^complete)(BOOL status);

+ (instancetype)sharedCenter;

/**
 打开路由

 @param url 地址
 */
- (void)openURL:(NSURL *)url;

/**
 打开路由

 @param url 地址
 @param complete 回调
 */
- (void)openURL:(NSURL *)url complete:(void (^)(BOOL status))complete;

/**
 获得从sso或者web端回调到本app的回调

 @param url 第三方sdk的打开本app的回调的url
 @return 是否处理  YES代表处理成功，NO代表不处理
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 注册Scheme
 */
- (void)registerRouterWithScheme;
@end
