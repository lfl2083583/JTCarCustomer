//
//  JTNormalUserInfo.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, JoinGroupType)
{
    /** 邀请加入 **/
    JoinGroupTypeInvite = 1,
    /** 二维码加入 **/
    JoinGroupTypeQr,
    /** 活动加入 **/
    JoinGroupTypeActivity,
    /** 申请加入 **/
    JoinGroupTypeApply,
    /** 再次申请加入 **/
    JoinGroupTypeApplyAgain
};

@interface JTNormalUserInfo : NSObject

@property (nonatomic, copy) NSString *userID;
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
 用户相册
 */
@property (nonatomic, strong) NSDictionary *userAblum;
/**
 用户年龄
 */
@property (nonatomic, assign) NSInteger userAge;
/**
 实名认证状态 0 : 未认证 1：已认证 2：认证中 3：认证失败
 */
@property (nonatomic, assign) NSInteger userAuthStatus;
/**
 用户标签
 */
@property (nonatomic, strong) NSArray *userTags;
/**
 用户标签
 */
@property (nonatomic, strong) NSArray *userBullet;
/**
 共同标签
 */
@property (nonatomic, strong) NSArray *userSameTags;
/**
 用户位置
 */
@property (nonatomic, strong) NSDictionary *userPostion;

@property (nonatomic, strong) NSArray *characterTags;

@property (nonatomic, assign) NSInteger followType;

@property (nonatomic, assign) JoinGroupType joinGroupType;

@property (nonatomic, strong) NSDictionary *inviteInfo;

@end
