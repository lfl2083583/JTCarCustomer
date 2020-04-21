//
//  JTUserInfo.h
//  JTDirectSeeding
//
//  Created by apple on 2017/4/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "OpenUDID.h"
#import "JTCarModel.h"

typedef NS_ENUM(NSInteger, JTLoginState) {
    JTLoginStateNone = 0,        // 未注册，未绑定
    JTLoginStateUnBinding = 1,   // 未绑定，已注册
    JTLoginStateSuccess = 2      // 已绑定，已注册
};

typedef NS_ENUM(NSInteger, JTLoginType)
{
    /** 普通手机号登录 **/
    JTLoginTypeNormal = 0,
    /** 微信 **/
    JTLoginTypeWeChat,
    /** QQ **/
    JTLoginTypeQQ,
    /** 微博 **/
    JTLoginTypeSina
};

typedef NS_ENUM(NSInteger, JTRealCertificationStatus)
{
    /** 未认证 **/
    JTRealCertificationStatusUnAuth    = 0,
    /** 已认证 **/
    JTRealCertificationStatusApproved  = 1,
    /** 认证审核中 **/
    JTRealCertificationStatusAudit     = 2,
    /** 认证失败 **/
    JTRealCertificationStatusAuthFail  = 3,
};

@interface JTUserInfo : MTLModel

+ (NSString *)deviceUDID;

/**
 是否登录
 */
@property (nonatomic, assign) BOOL isLogin;
/**
 用户ID
 */
@property (nonatomic, copy) NSString *userID;
/**
 登录令牌
 */
@property (nonatomic, copy) NSString *userToken;
/**
 是否是苹果账号
 */
@property (nonatomic, assign) BOOL isAppleAccount;
/**
 是否是通过审核
 */
@property (nonatomic, assign) BOOL isAdoptReview_Local;
/**
 用户头像
 */
@property (nonatomic, copy) NSString *userAvatar;
/**
 用户生日
 */
@property (nonatomic, copy) NSString *userBirth;
/**
 用户公司
 */
@property (nonatomic, copy) NSString *userCompany;
/**
 用户性别
 */
@property (nonatomic, assign) NSInteger userGenter;
/**
 用户等级
 */
@property (nonatomic, assign) NSInteger userGrade;
/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;
/**
 用户手机号
 */
@property (nonatomic, copy) NSString *userPhone;
/**
 用户个性签名
 */
@property (nonatomic, copy) NSString *userSign;
/**
 用户溜车圈号
 */
@property (nonatomic, copy) NSString *userNumberCode;
/**
 用户云信账号
 */
@property (nonatomic, copy) NSString *userYXAccount;
/**
 用户云信Token
 */
@property (nonatomic, copy) NSString *userYXToken;
/**
 是否设置了支付密码
 */
@property (nonatomic, assign) BOOL isUserPaymentPassword;
/**
 余额
 */
@property (nonatomic, assign) double userBalance;
/**
 实名认证状态 0 : 未认证 1：已认证 2：认证中 3：认证失败
 */
@property (nonatomic, assign) NSInteger userAuthStatus;
/**
 用户相册
 */
@property (nonatomic, strong) NSDictionary *userAblum;
/**
 用户标签
 */
@property (nonatomic, strong) NSArray *userTags;
/**
 用户弹幕
 */
@property (nonatomic, strong) NSArray *userBullet;
/**
 用户位置
 */
@property (nonatomic, strong) NSDictionary *userPostion;
/**
 个性标签
 */
@property (nonatomic, strong) NSArray *relateTags;
/**
  是否绑定QQ
 */
@property (nonatomic, assign) BOOL isBindQQ;
/**
 是否绑定微信
 */
@property (nonatomic, assign) BOOL isBindWeiChat;


/**
 我的车列表 第0个元素是默认车辆
 */
@property (nonatomic, strong) NSMutableArray<JTCarModel *> *myCarList;


/**
 会话置顶数组
 */
@property (strong, nonatomic) NSMutableArray *sessionTops;
/**
 是否关闭声音提示
 */
@property (nonatomic, assign) BOOL isCloseAudio;
/**
 是否关闭震动提示
 */
@property (nonatomic, assign) BOOL isCloseShock;

+ (instancetype)shareUserInfo;

/**
 保存数据
 */
- (void)save;

/**
 清楚数据
 */
- (void)clear;

/****** 爱车操作 *******/
/**
 添加车辆模型

 @param carModels 模型数组
 */
- (void)addCarModels:(NSArray<JTCarModel *> *)carModels;

/**
 重置默认车辆

 @param carModel 默认车辆
 */
- (void)resetDefaultCarModel:(JTCarModel *)carModel;

@end
