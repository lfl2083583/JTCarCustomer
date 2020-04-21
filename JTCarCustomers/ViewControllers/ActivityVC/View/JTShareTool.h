//
//  JTShareTool.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define ShareUrl      @"shareUrl"
#define ShareTitle    @"shareTitle"
#define ShareDescribe @"shareDescribe"
#define ShareThumbURL @"shareThumbURL"

typedef enum : NSUInteger {
    
    JTShareContentTypeUrl   = 201, // 分享URL
    JTShareContentTypeImage = 202, // 分类图片
    
} JTShareContentType;

typedef enum : NSUInteger {
    JTSharePlatformTypeWeichat        = 0, // 微信
    JTSharePlatformTypeQQ             = 1, // QQ
    JTSharePlatformTypeQQZone         = 2, // QQ空间
    JTSharePlatformTypeWechatCicle    = 3, // 朋友圈
    JTSharePlatformTypeTeam           = 4, // 溜车圈
    JTSharePlatformTypeFriend         = 5, // 溜车好友
    
} JTSharePlatformType;

typedef void(^ShareChooseBlock)(NSError *error, JTSharePlatformType platformType);

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"



@interface JTShareTool : NSObject

@property (nonatomic, strong) UIControl *shareControl;
@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, copy) id shareImage;
@property (nonatomic, copy) NSDictionary *shareDict;
@property (nonatomic, copy) ShareChooseBlock callBack;
@property (nonatomic, assign) JTShareContentType shareContentType;

+ (instancetype)instance;

- (void)shareInfo:(NSDictionary *)dict result:(void(^)(NSError *error, JTSharePlatformType platformType))block;

@end
