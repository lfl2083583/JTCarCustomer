//
//  JTNormalUserInfo.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTNormalUserInfo.h"

@implementation JTNormalUserInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"userID"         : @"user.uid",
             @"userAvatar"     : @"user.avatar",
             @"userBirth"      : @"user.birth",
             @"userCompany"    : @"user.company",
             @"userGenter"     : @"user.gender",
             @"userGrade"      : @"user.grade",
             @"userName"       : @"user.nick_name",
             @"userPhone"      : @"user.phone",
             @"userSign"       : @"user.sign",
             @"userNumberCode" : @"user.user_name",
             @"userYXAccount"  : @"yx_accid",
             @"userAuthStatus" : @"user.is_auth",
             @"userTags"       : @"label",
             @"userBullet"     : @"barrage",
             @"userSameTags"   : @"same_label",
             @"userPostion"    : @"position",
             @"userAblum"      : @"album",
             @"characterTags"  : @"label_related",
             @"followType"     : @"follow.type",
             @"joinGroupType"  : @"user.join_group_type.type",
             @"inviteInfo"     : @"user.join_group_type.info",
             @"userAge"        : @"user.age",
             };
}


@end
