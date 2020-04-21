//
//  MacroMethod.h
//  SexIndustry
//
//  Created by Sha Na on 13-2-25.
//  Copyright (c) 2013年 Sha Na. All rights reserved.
//

//设置DEBUG调试的输出方式
#if !defined(DEBUG) || DEBUG == 0
#define CCLOG(...) do {} while (0)
#define CCLOGINFO(...) do {} while (0)
#define CCLOGERROR(...) do {} while (0)

#elif DEBUG == 1
#define CCLOG(...) NSLog(__VA_ARGS__)
#define CCLOGERROR(...) NSLog(__VA_ARGS__)
#define CCLOGINFO(...) do {} while (0)

#elif DEBUG > 1
#define CCLOG(...) NSLog(__VA_ARGS__)
#define CCLOGERROR(...) NSLog(__VA_ARGS__)
#define CCLOGINFO(...) NSLog(__VA_ARGS__)
#endif // DEBUG


//设置DEBUG调试的输出方式
#if !defined(DEBUG) || DEBUG == 0
#define XXLOG do {} while (0)

#elif DEBUG == 1
#define XXLOG NSLog(@"-->> <<%@>> -->> <<%@>> ", self.class, NSStringFromSelector(_cmd));

#elif DEBUG > 1
#define XXLOG NSLog(@"-->> <<%@>> -->> <<%@>> ", self.class, NSStringFromSelector(_cmd));
#endif // DEBUG


#define __WEAKSELF(X) __weak typeof(X) weakself = X;
#define __STRONGSELF(X) __strong typeof(X) strongself = X;

/**
 *	@brief	视图信息
 */
#define IOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS8  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define IOS9  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES : NO)
#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 ? YES : NO)

#define kIsIphone4s    (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)))
#define kIsIphone5     (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568)))
#define kIsIphone6     (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667)))
#define kIsIphone6p    (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736)))
#define kIsIphonex     (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)))

#define kScreenHeight  (kIsIphone4s ? 480.f : (kIsIphone5 ? 568.f : (kIsIphone6 ? 667.f : (kIsIphone6p ? 736.f : 812.f))))
#define kScreenWidth   (kIsIphone4s ? 320.f : (kIsIphone5 ? 320.f : (kIsIphone6 ? 375.f : (kIsIphone6p ? 414.f : 375.f))))

#define kStatusBarHeight   (kIsIphonex ? 44.f : 20.f)
#define kTopBarHeight      (44.f)
#define kBottomBarHeight   (kIsIphonex ? 83.f : 49.f)

#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

#define SC_DEVICE_BOUNDS    [[UIScreen mainScreen] bounds]
#define SC_DEVICE_SIZE      [[UIScreen mainScreen] bounds].size

#define SC_APP_FRAME        [[UIScreen mainScreen] applicationFrame]
#define SC_APP_SIZE         [[UIScreen mainScreen] applicationFrame].size

#define APP_Frame_Height    [UIScreen mainScreen].bounds.size.height
#define App_Frame_Width     [UIScreen mainScreen].bounds.size.width

#define SELF_CON_FRAME      self.view.frame
#define SELF_CON_SIZE       self.view.frame.size
#define SELF_VIEW_FRAME     self.frame
#define SELF_VIEW_SIZE      self.frame.size

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBoraAlpha(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define RGBCOLOR(r,g,b,a)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define PNGIMAGE(NAME)           [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)           [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]

#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define CompareStirng(string1, string2)                          (string1 && ![string1 isEqualToString:@""] && ![string1 isEqualToString:@"null"])?string1:string2

/**
 *	@brief	接口
 */
#define kBase_url(action)    [@"https://api.6che.vip/" stringByAppendingString:action]          //测试接口
//#define kBase_url(action)    [@"https://api.boshangquan.com/" stringByAppendingString:action]               //正式接口
#define kShareUrl            @"http://www.boshangquan.com/downloadGuide.html"

/*
 手机info
 */
#define System_Version [[UIDevice currentDevice] systemVersion]                                             //用户手机系统版本
#define System_Model   [[UIDevice currentDevice] model]                                                     //用户手机型号
#define App_Name       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]         //app的名字
#define App_Version    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]  //app的版本号
#define App_BundleID   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]          //app的BundleID
#define CHANNEL_ID     @"appstore"
//#define CHANNEL_ID     @"enterprise"

#define kJTCarCustomersScheme @"kJTCarCustomers"


/**
 *	@brief	密钥
 */
//友盟
#define USHARE_APPKEY             @"5aa236b7f43e484ee20000a6"

//微信分享
#define WeChatHandler_AppId     @"wx00189971ab4945ee"
#define WeChatHandler_appSecret @"b5ef44fbe259f530c382ed5f31860644"

//QQ分享
#define QQHander_AppId          @"1106760272"
#define QQHander_appkey         @"i0l7yG7UhPaOz5bk"

//sina分享
#define SinaHandler_AppId       @"1452964788"
#define SinaHandler_appKey      @"f95838882a3b3a01d0a6f18ccc7d7ec5"

//网易
#define kNIMAppKey  @"84e011283267f508d362de156d166dcc"
//#define kNIMCerName @"YuRenQuanDev"  
#define kNIMCerName @"YuRenQuanDis"
//#define kNIMCerName @"enterpriseDis"

#define kJTSystemID     @"msg_6666"  // 芝麻认证成功,实名认证成功,实名认证失败,用户反馈消息,活动消息,用户注册消息
#define kJTNomeyID      @"msg_5555"  // 支付成功,支付失败,红包退款
#define kJTNormalID     @"msg_4444"  // 关注消息
#define kJTTeamID       @"msg_3333"  // 邀请加群通知,申请加群通知,群主拒绝加群通知,群主奖用户移除群通知
#define kJTCallBonusID  @"msg_7777"  // 抢红包消息
#define kJTActivityID   @"msg_8888"  // 活动评论通知

//openInstall
#define OpenInstallKey   @"jhk79a"
//#define OpenInstallKey   @"dfugku"

//百度OCR
#define AipOcr_Appkey       @"1ShcNb0MhewsaMvCSl9PDq7b"
#define AipOcr_AppSecret    @"4ljiWKBnB4bvxAxujf6YHwNtO9wbk1Cq"

//高德
#define LBS_Key               @"d36ffe3748848f28d28a3e4a3192cb2c"
#define LBS_SearchApi         @"http://restapi.amap.com/v3/place/around"
#define LBS_Static            @"http://restapi.amap.com/v3/staticmap"
#define LBS_WalkApi           @"http://restapi.amap.com/v3/direction/walking"
#define LBS_DrivingApi        @"http://restapi.amap.com/v3/direction/driving"
#define Camera_Start          @"https://open.ys7.com/api/lapp/device/ptz/start"
#define Camera_Stop           @"https://open.ys7.com/api/lapp/device/ptz/stop"
/**
 *	@brief	用户信息
 */
#define DEFAULTS_INFO(_OBJECT, _NAME) [[NSUserDefaults standardUserDefaults] setObject:_OBJECT forKey:_NAME]
#define DEFAULTS_SYNCHRONIZE          [[NSUserDefaults standardUserDefaults] synchronize]


//登录开关
#define Location_Info                 [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationInfo"]//位置信息

/**
 *	@brief	加载提示
 */
#define kPlaceholder  @"请稍等..."

/**
 *	@brief	UI规范
 */
#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

/**
 *	@brief	通知
 */
#define kLoginStatusChangeNotification          @"kLoginStatusChangeNotification"             // 登录状态改变通知
#define kViewControllerShouldReloadNotification @"kViewControllerShouldReloadNotification"    // 界面改变通知
#define kReachabilityStatusChangeNotification   @"kReachabilityStatusChangeNotification"      // 网络改变通知
#define kCallStateChangeNotification            @"kCallStateChangeNotification"               // 手机电话状态改变通知
#define kJTUserInfoUpdatedNotification          @"kJTUserInfoUpdatedNotification"             // 云信用户信息更新通知
#define kJTTeamInfoUpdatedNotification          @"kJTTeamInfoUpdatedNotification"             // 云信群信息更新通知
#define kJTTeamMembersUpdatedNotification       @"kJTTeamMembersUpdatedNotification"          // 云信群成员信息更新通知
#define kJTUpdateSessionShowNickNameNotification  @"kJTUpdateSessionShowNickNameNotification" // 更新是否显示群昵称通知


//#define kJTUpdateDraftNotification            @"kJTUpdateDraftNotification"           // 添加删除草稿
//#define kJTUpdateSessionTopNotification       @"kJTUpdateSessionTopNotification"      // 更新消息置顶通知

//#define kUpdateUserRelationsNotification      @"kUpdateUserRelationsNotification"     // 修改用户关系通知
//#define kCleanSessionMessageNotification      @"kCleanSessionMessageNotification"     // 清空单个会话消息通知
//#define kUpdateAliasNotification              @"kUpdateAliasNotification"             // 修改备注通知
//#define kUpdateLabelNotification              @"kUpdateLabelNotification"             // 修改标签通知（单个用户）
//
//#define kHideInputViewNotification            @"kHideInputViewNotification"           // 收起会话输入
#define kJTUpdateDraftNotification            @"kJTUpdateDraftNotification"             // 添加删除草稿
#define kCleanSessionMessageNotification      @"kCleanSessionMessageNotification"       // 清空单个会话消息通知
#define kJTUpdateSessionTopNotification       @"kJTUpdateSessionTopNotification"        // 更新消息置顶通知
#define kJTUpdateNotifyForNewMsgNotification  @"kJTUpdateNotifyForNewMsgNotification"   // 修改免打扰状态
#define kUpdateSessionBottomNotification      @"kUpdateSessionBottomNotification"       // 修改聊天背景
#define kResetInputExpressionNotification     @"kResetInputExpressionNotification"      // 重置键盘表情
#define kModifyExpressionNotification         @"kModifyExpressionNotification"          // 修改表情
#define kDeleteCollectionNotification         @"kDeleteCollectionNotification"          // 删除收藏

//#define ORDER_PAY_NOTIFICATION                @"ORDER_PAY_NOTIFICATION"               // 支付回调
//
//#define kBanNotification                      @"kBanNotification"                     // 禁播消息
//#define kJTAuthenSuccessNotification          @"kJTAuthenSuccessNotification"         // 实名认证成功消息
//#define kUpGradeNotification                  @"kUpGradeNotification"                 // 升级消息
//#define kJTRemoveAnchorNotification           @"kJTRemoveAnchorNotification"          // 移除主播消息
//
#define kUpdateBalanceNotification            @"kUpdateBalanceNotification"           // 刷新余额
#define kUpdateMyCarListNotification          @"kUpdateMyCarListNotification"         // 刷新我的爱车列表
//
//#define kLiveStateControlPlayNotification     @"kLiveStateControlPlayNotification"    // 观看直播状态控制-播放
//#define kLiveStateControlPauseNotification    @"kLiveStateControlPauseNotification"   // 观看直播状态控制-暂停
//
//#define kChangedBindPhoneNotification           @"kChangedBindPhoneNotification"           //改变手机号


/**
 *	@brief	GCD
 */
#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
